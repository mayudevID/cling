import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/money_amount.dart';
import '../../../../l10n/app_localizations.dart';
import '../main_widget/finance_refresh.dart';
import '../../../model/financial_planning_models.dart';
import '../../../model/wallet_model.dart';
import '../../../repository/database_repository.dart';
import '../../language_currency/lang_export.dart';
import 'planning_bloc.dart';

enum _PlanningSection { overview, recurring, bills, runway, settings }

class FinancialPlanningPage extends StatelessWidget {
  const FinancialPlanningPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => PlanningBloc(GetIt.I<DatabaseRepository>())
          ..add(LoadPlanning(DateTime.now())),
        child: const _PlanningScreen(section: _PlanningSection.overview),
      );
}

class _PlanningScreen extends StatelessWidget {
  const _PlanningScreen({required this.section});
  final _PlanningSection section;

  void _open(BuildContext context, _PlanningSection target) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: context.read<PlanningBloc>(),
        child: _PlanningScreen(section: target),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = switch (section) {
      _PlanningSection.overview => l10n.financialPlanning,
      _PlanningSection.recurring => l10n.recurringExpenses,
      _PlanningSection.bills => l10n.billsAndReminders,
      _PlanningSection.runway => l10n.paydayRunway,
      _PlanningSection.settings => l10n.planningSettings,
    };
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: BlocConsumer<PlanningBloc, PlanningState>(
        listenWhen: (previous, current) =>
            (previous.error != current.error && current.error != null) ||
            previous.financialMutationId != current.financialMutationId,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          } else {
            refreshFinancialViews(context, refreshPlanning: false);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.rules.isEmpty && state.bills.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF599DA)));
          }
          if (state.error != null &&
              state.rules.isEmpty &&
              state.bills.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(state.error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center),
                TextButton(
                    onPressed: () => context
                        .read<PlanningBloc>()
                        .add(LoadPlanning(DateTime.now())),
                    child: Text(l10n.change)),
              ]),
            ));
          }
          return switch (section) {
            _PlanningSection.overview => _overview(context, state),
            _PlanningSection.recurring => _recurring(context, state),
            _PlanningSection.bills => _bills(context, state),
            _PlanningSection.runway => _runway(context, state),
            _PlanningSection.settings => _settings(context, state),
          };
        },
      ),
    );
  }

  Widget _overview(BuildContext context, PlanningState state) {
    final l10n = AppLocalizations.of(context)!;
    final runway = state.runway;
    final today = DateTime.now();
    final upcoming = state.bills
        .where(
            (bill) => ['upcoming', 'due_today'].contains(bill.statusOn(today)))
        .toList();
    final overdue =
        state.bills.where((bill) => bill.statusOn(today) == 'overdue').toList();
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<PlanningBloc>().add(LoadPlanning(DateTime.now())),
      child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (runway == null)
              _card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(l10n.setupPayday,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    TextButton(
                        onPressed: () =>
                            _open(context, _PlanningSection.settings),
                        child: Text(l10n.planningSettings)),
                  ]))
            else
              _card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    _labelValue(
                        l10n.nextPayday,
                        DateFormat.yMMMd(
                                Localizations.localeOf(context).toString())
                            .format(runway.payday)),
                    _labelValue(l10n.dailyAllowance,
                        _money(runway.dailyAllowanceMinor, runway.currency),
                        large: true),
                    _labelValue(
                        l10n.estimatedSpendable,
                        _money(
                            runway.estimatedSpendableMinor, runway.currency)),
                    Text('${runway.daysRemaining} ${l10n.days}',
                        style: const TextStyle(color: Colors.white60)),
                  ])),
            const SizedBox(height: 12),
            _navigationTile(context, l10n.paydayRunway, Icons.route_outlined,
                _PlanningSection.runway),
            _navigationTile(context, l10n.recurringExpenses, Icons.repeat,
                _PlanningSection.recurring,
                trailing: '${state.rules.where((r) => r.enabled).length}'),
            _navigationTile(context, l10n.billsAndReminders,
                Icons.receipt_long_outlined, _PlanningSection.bills,
                trailing: '${upcoming.length + overdue.length}'),
            _navigationTile(context, l10n.planningSettings, Icons.tune,
                _PlanningSection.settings),
            const SizedBox(height: 12),
            _sectionHeader(l10n.overdueBills, overdue.length),
            if (overdue.isEmpty) _empty(l10n.noPlanningItems),
            ...overdue.take(3).map((bill) => _billTile(context, bill)),
            _sectionHeader(l10n.upcomingBills, upcoming.length),
            if (upcoming.isEmpty) _empty(l10n.noPlanningItems),
            ...upcoming.take(4).map((bill) => _billTile(context, bill)),
            _sectionHeader(l10n.activeRecurring,
                state.rules.where((r) => r.enabled).length),
            if (state.rules.where((r) => r.enabled).isEmpty)
              _empty(l10n.noPlanningItems),
            ...state.rules
                .where((r) => r.enabled)
                .take(3)
                .map((rule) => ListTile(
                      title: Text(rule.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                          '${_money(rule.amountMinor, _walletCurrency(state, rule.walletId))} · ${_frequencyName(context, rule.frequency)}',
                          style: const TextStyle(color: Colors.white60)),
                    )),
          ]),
    );
  }

  Widget _recurring(BuildContext context, PlanningState state) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(padding: const EdgeInsets.all(16), children: [
      if (state.rules.isEmpty && state.occurrences.isEmpty)
        _empty(l10n.noPlanningItems),
      ...state.occurrences.map((occurrence) => Card(
            color: const Color(0xFF292929),
            child: ListTile(
              title: Text(occurrence['rule_name'] as String,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                  '${occurrence['scheduled_date']} · ${occurrence['status']} · ${occurrence['wallet_name']}',
                  style: const TextStyle(color: Colors.white60)),
              trailing: Wrap(children: [
                IconButton(
                    tooltip: l10n.confirmPayment,
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.pinkAccent),
                    onPressed: () => _confirmOccurrence(context, occurrence)),
                IconButton(
                    tooltip: l10n.cancel,
                    icon: const Icon(Icons.skip_next, color: Colors.white70),
                    onPressed: () => context.read<PlanningBloc>().add(
                        SkipOccurrence(occurrence['occurrence_id'] as int))),
              ]),
            ),
          )),
      ...state.rules.map((rule) => Card(
          color: const Color(0xFF292929),
          child: ListTile(
            title: Text(rule.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
                '${_money(rule.amountMinor, _walletCurrency(state, rule.walletId))} · ${_frequencyName(context, rule.frequency)} · ${rule.postingMode == 'automatic' ? l10n.automatic : l10n.manual}',
                style: const TextStyle(color: Colors.white60)),
            onTap: () => _editRule(context, state, rule),
            trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'toggle')
                    context
                        .read<PlanningBloc>()
                        .add(ToggleRecurringRule(rule.id!, !rule.enabled));
                  if (value == 'delete') _deleteRule(context, rule);
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                          value: 'toggle',
                          child: Text(rule.enabled ? l10n.pause : l10n.resume)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                    ]),
          ))),
      const SizedBox(height: 12),
      FilledButton.icon(
          onPressed: () => _editRule(context, state),
          icon: const Icon(Icons.add),
          label: Text(l10n.addRecurringExpense)),
    ]);
  }

  Widget _bills(BuildContext context, PlanningState state) {
    final l10n = AppLocalizations.of(context)!;
    final bills = state.bills;
    return ListView(padding: const EdgeInsets.all(16), children: [
      if (bills.isEmpty) _empty(l10n.noPlanningItems),
      ...bills.map((bill) => Card(
          color: const Color(0xFF292929),
          child: ListTile(
            title:
                Text(bill.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
                '${_money(bill.amountMinor, _walletCurrency(state, bill.walletId))} · ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(bill.dueDate)} · ${_billStatus(context, bill.statusOn(DateTime.now()))}',
                style: const TextStyle(color: Colors.white60)),
            onTap: bill.expenseId == null && !bill.isCancelled
                ? () => _editBill(context, state, bill)
                : null,
            trailing: bill.expenseId != null || bill.isCancelled
                ? null
                : PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'pay') _confirmBillPayment(context, bill);
                      if (value == 'cancel')
                        context
                            .read<PlanningBloc>()
                            .add(CancelPlanningBill(bill.id!));
                      if (value == 'link') _linkExistingExpense(context, bill);
                    },
                    itemBuilder: (_) => [
                          PopupMenuItem(
                              value: 'pay', child: Text(l10n.confirmPayment)),
                          PopupMenuItem(
                              value: 'link',
                              child: Text(l10n.linkExistingExpense)),
                          PopupMenuItem(
                              value: 'cancel', child: Text(l10n.cancelBill)),
                        ]),
          ))),
      const SizedBox(height: 12),
      FilledButton.icon(
          onPressed: () => _editBill(context, state),
          icon: const Icon(Icons.add),
          label: Text(l10n.addBill)),
    ]);
  }

  Widget _runway(BuildContext context, PlanningState state) {
    final l10n = AppLocalizations.of(context)!;
    final runway = state.runway;
    if (runway == null)
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l10n.setupPayday, style: const TextStyle(color: Colors.white)),
          TextButton(
              onPressed: () => _open(context, _PlanningSection.settings),
              child: Text(l10n.planningSettings)),
        ]),
      ));
    return ListView(padding: const EdgeInsets.all(16), children: [
      _card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.estimateDisclaimer,
            style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        _labelValue(
            l10n.nextPayday,
            DateFormat.yMMMd(Localizations.localeOf(context).toString())
                .format(runway.payday)),
        _labelValue(l10n.availableBalance,
            _money(runway.availableMinor, runway.currency)),
        _labelValue(l10n.upcomingBills,
            '- ${_money(runway.billsMinor, runway.currency)}'),
        _labelValue(l10n.includedRecurring,
            '- ${_money(runway.recurringMinor, runway.currency)}'),
        _labelValue(l10n.safetyReserve,
            '- ${_money(runway.reserveMinor, runway.currency)}'),
        const Divider(color: Colors.white24),
        _labelValue(
            runway.estimatedSpendableMinor < 0
                ? l10n.shortfall
                : l10n.estimatedSpendable,
            _money(runway.estimatedSpendableMinor, runway.currency),
            large: true),
        _labelValue(l10n.dailyAllowance,
            _money(runway.dailyAllowanceMinor, runway.currency),
            large: true),
        _labelValue(l10n.expectedIncome,
            _money(runway.expectedIncomeMinor, runway.currency)),
        Text('${runway.daysRemaining} ${l10n.days}',
            style: const TextStyle(color: Colors.white60)),
      ])),
      const SizedBox(height: 12),
      _card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.includedWallets,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        ...state.wallets.where((wallet) => !wallet.isArchived).map((wallet) =>
            Text(
                '${wallet.name}: ${_money(wallet.balanceMinor, wallet.currency)}',
                style: const TextStyle(color: Colors.white70))),
        if (runway.excludedWalletNames.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.excludedWallets,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(runway.excludedWalletNames.join(', '),
              style: const TextStyle(color: Colors.white70)),
        ],
        const SizedBox(height: 8),
        Text(l10n.includedBills,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        ...runway.includedBills.map((bill) => Text(
            '${bill.name} · ${DateFormat.yMMMd().format(bill.date)} · ${_money(bill.amountMinor, runway.currency)}',
            style: const TextStyle(color: Colors.white70))),
        const SizedBox(height: 8),
        Text(l10n.includedRecurring,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        ...runway.includedRecurringDetails.map((obligation) => Text(
            '${obligation.name} · ${DateFormat.yMMMd().format(obligation.date)} · ${_money(obligation.amountMinor, runway.currency)}',
            style: const TextStyle(color: Colors.white70))),
      ])),
    ]);
  }

  Widget _settings(BuildContext context, PlanningState state) {
    final l10n = AppLocalizations.of(context)!;
    final day = TextEditingController(
        text: state.configuredPaydayDay?.toString() ?? '');
    final reserve =
        TextEditingController(text: _amountInput(state.safetyReserveMinor));
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(l10n.paydayDay, style: const TextStyle(color: Colors.white)),
      TextField(
          controller: day,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: state.runway == null ? l10n.setupPayday : null,
              hintStyle: const TextStyle(color: Colors.white54))),
      const SizedBox(height: 16),
      Text(l10n.safetyReserve, style: const TextStyle(color: Colors.white)),
      TextField(
          controller: reserve,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 20),
      FilledButton(
          onPressed: state.isLoading
              ? null
              : () {
                  final parsedDay = day.text.trim().isEmpty
                      ? null
                      : int.tryParse(day.text.trim());
                  final parsedReserve = _parseMinor(reserve.text);
                  if ((day.text.trim().isNotEmpty &&
                          (parsedDay == null ||
                              parsedDay < 1 ||
                              parsedDay > 31)) ||
                      parsedReserve == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.invalidAmount)));
                    return;
                  }
                  context
                      .read<PlanningBloc>()
                      .add(SavePlanningPreferences(parsedDay, parsedReserve));
                },
          child: Text(l10n.save)),
      const SizedBox(height: 12),
      Text(l10n.estimateDisclaimer,
          style: const TextStyle(color: Colors.white60)),
    ]);
  }

  Future<void> _editRule(BuildContext context, PlanningState state,
      [RecurringExpenseRuleModel? current]) async {
    final l10n = AppLocalizations.of(context)!;
    if (state.categories.isEmpty ||
        state.wallets.where((w) => !w.isArchived).isEmpty) return;
    final name = TextEditingController(text: current?.name ?? '');
    final description = TextEditingController(text: current?.description ?? '');
    final amount =
        TextEditingController(text: _amountInput(current?.amountMinor ?? 0));
    final day = TextEditingController(
        text: current?.scheduledDay.toString() ?? '${DateTime.now().day}');
    var categoryId = current?.categoryId ?? state.categories.first.id;
    final activeWallets = state.wallets.where((w) => !w.isArchived).toList();
    var walletId = current?.walletId ??
        activeWallets
            .firstWhere((w) => w.isDefault, orElse: () => activeWallets.first)
            .id!;
    var frequency = current?.frequency ?? 'monthly';
    var mode = current?.postingMode ?? 'manual';
    var start = current?.startDate ?? DateTime.now();
    var end = current?.endDate;
    final result = await showDialog<RecurringExpenseRuleModel>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF292929),
                  title: Text(
                      current == null
                          ? l10n.addRecurringExpense
                          : l10n.recurringExpenses,
                      style: const TextStyle(color: Colors.white)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _textField(name, l10n.title),
                    _textField(description, l10n.description),
                    _textField(amount, l10n.amount, numeric: true),
                    _dropdown<int>(
                        l10n.category,
                        categoryId,
                        state.categories
                            .map((c) => DropdownMenuItem(
                                value: c.id, child: Text(c.expenseCategories)))
                            .toList(),
                        (v) => setState(() => categoryId = v!)),
                    _dropdown<int>(
                        l10n.wallet,
                        walletId,
                        activeWallets
                            .map((w) => DropdownMenuItem(
                                value: w.id!, child: Text(w.name)))
                            .toList(),
                        (v) => setState(() => walletId = v!)),
                    _dropdown<String>(
                        l10n.frequency,
                        frequency,
                        [
                          DropdownMenuItem(
                              value: 'weekly', child: Text(l10n.weekly)),
                          DropdownMenuItem(
                              value: 'monthly', child: Text(l10n.monthly))
                        ],
                        (v) => setState(() {
                              frequency = v!;
                              if (frequency == 'weekly')
                                day.text = '${DateTime.now().weekday}';
                              else
                                day.text = '${DateTime.now().day}';
                            })),
                    _textField(day, l10n.scheduledDay, numeric: true),
                    if (frequency == 'weekly')
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(l10n.weeklyWeekdayHint,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 12)),
                      ),
                    ListTile(
                        title: Text(
                            '${l10n.startDate}: ${DateFormat.yMMMd().format(start)}',
                            style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.calendar_month,
                            color: Colors.white70),
                        onTap: () async {
                          final selected = await _pickDate(context, start);
                          if (selected != null)
                            setState(() => start = selected);
                        }),
                    ListTile(
                        title: Text(
                            '${l10n.endDateOptional}: ${end == null ? '-' : DateFormat.yMMMd().format(end!)}',
                            style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.calendar_month,
                            color: Colors.white70),
                        onTap: () async {
                          final selected =
                              await _pickDate(context, end ?? start);
                          if (selected != null) setState(() => end = selected);
                        }),
                    _dropdown<String>(
                        l10n.postingMode,
                        mode,
                        [
                          DropdownMenuItem(
                              value: 'manual',
                              child: Text(l10n.manualConfirmation)),
                          DropdownMenuItem(
                              value: 'automatic',
                              child: Text(l10n.automaticPosting))
                        ],
                        (v) => setState(() => mode = v!)),
                    if (mode == 'automatic')
                      Text(l10n.automaticPostingNotice,
                          style: const TextStyle(color: Colors.orangeAccent)),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.cancel)),
                    FilledButton(
                        onPressed: () {
                          final minor = _parseMinor(amount.text);
                          final scheduledDay = int.tryParse(day.text);
                          final dayValid = scheduledDay != null &&
                              (frequency == 'weekly'
                                  ? scheduledDay >= 1 && scheduledDay <= 7
                                  : scheduledDay >= 1 && scheduledDay <= 31);
                          if (name.text.trim().isEmpty ||
                              minor == null ||
                              minor <= 0 ||
                              !dayValid ||
                              (end != null && end!.isBefore(start))) return;
                          Navigator.pop(
                              dialogContext,
                              RecurringExpenseRuleModel(
                                  id: current?.id,
                                  name: name.text,
                                  description: description.text.trim().isEmpty
                                      ? null
                                      : description.text.trim(),
                                  amountMinor: minor,
                                  categoryId: categoryId,
                                  walletId: walletId,
                                  frequency: frequency,
                                  scheduledDay: scheduledDay,
                                  startDate: start,
                                  endDate: end,
                                  nextDate: current?.nextDate ?? start,
                                  enabled: current?.enabled ?? true,
                                  postingMode: mode));
                        },
                        child: Text(l10n.save))
                  ],
                )));
    if (result != null && context.mounted)
      context.read<PlanningBloc>().add(SaveRecurringRule(result));
  }

  Future<void> _editBill(BuildContext context, PlanningState state,
      [PlanningBillModel? current]) async {
    final l10n = AppLocalizations.of(context)!;
    if (state.categories.isEmpty ||
        state.wallets.where((w) => !w.isArchived).isEmpty) return;
    final title = TextEditingController(text: current?.title ?? '');
    final amount =
        TextEditingController(text: _amountInput(current?.amountMinor ?? 0));
    final note = TextEditingController(text: current?.note ?? '');
    final activeWallets = state.wallets.where((w) => !w.isArchived).toList();
    var categoryId = current?.categoryId ?? state.categories.first.id;
    var walletId = current?.walletId ??
        activeWallets
            .firstWhere((w) => w.isDefault, orElse: () => activeWallets.first)
            .id!;
    var due = current?.dueDate ?? DateTime.now();
    var reminders = current?.reminderMask ?? 7;
    final result = await showDialog<PlanningBillModel>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF292929),
                  title: Text(
                      current == null ? l10n.addBill : l10n.billsAndReminders,
                      style: const TextStyle(color: Colors.white)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _textField(title, l10n.title),
                    _textField(amount, l10n.amount, numeric: true),
                    _textField(note, l10n.description),
                    _dropdown<int>(
                        l10n.category,
                        categoryId,
                        state.categories
                            .map((c) => DropdownMenuItem(
                                value: c.id, child: Text(c.expenseCategories)))
                            .toList(),
                        (v) => setState(() => categoryId = v!)),
                    _dropdown<int>(
                        l10n.wallet,
                        walletId,
                        activeWallets
                            .map((w) => DropdownMenuItem(
                                value: w.id!, child: Text(w.name)))
                            .toList(),
                        (v) => setState(() => walletId = v!)),
                    ListTile(
                        title: Text(
                            '${l10n.dueDate}: ${DateFormat.yMMMd().format(due)}',
                            style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.calendar_month,
                            color: Colors.white70),
                        onTap: () async {
                          final selected = await _pickDate(context, due);
                          if (selected != null) setState(() => due = selected);
                        }),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(l10n.reminders,
                            style: const TextStyle(color: Colors.white))),
                    for (final entry in [
                      (3, l10n.threeDaysBefore),
                      (1, l10n.oneDayBefore),
                      (0, l10n.onDueDate)
                    ])
                      CheckboxListTile(
                          value: reminders & _reminderBit(entry.$1) != 0,
                          title: Text(entry.$2,
                              style: const TextStyle(color: Colors.white70)),
                          onChanged: (v) => setState(() => reminders = v == true
                              ? reminders | _reminderBit(entry.$1)
                              : reminders & ~_reminderBit(entry.$1))),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.cancel)),
                    FilledButton(
                        onPressed: () {
                          final minor = _parseMinor(amount.text);
                          if (title.text.trim().isEmpty ||
                              minor == null ||
                              minor <= 0) return;
                          Navigator.pop(
                              dialogContext,
                              PlanningBillModel(
                                  id: current?.id,
                                  title: title.text,
                                  amountMinor: minor,
                                  categoryId: categoryId,
                                  walletId: walletId,
                                  dueDate: due,
                                  reminderMask: reminders,
                                  note: note.text.trim().isEmpty
                                      ? null
                                      : note.text.trim(),
                                  recurringRuleId: current?.recurringRuleId));
                        },
                        child: Text(l10n.save))
                  ],
                )));
    if (result != null && context.mounted)
      context.read<PlanningBloc>().add(SavePlanningBill(result));
  }

  Future<void> _confirmBillPayment(
      BuildContext context, PlanningBillModel bill) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF292929),
              title: Text(l10n.confirmPayment,
                  style: const TextStyle(color: Colors.white)),
              content: Text(
                  '${bill.title} · ${_money(bill.amountMinor, _walletCurrency(context.read<PlanningBloc>().state, bill.walletId))}',
                  style: const TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.pay))
              ],
            ));
    if (confirmed == true && context.mounted)
      context
          .read<PlanningBloc>()
          .add(PayPlanningBill(bill.id!, DateTime.now()));
  }

  Future<void> _confirmOccurrence(
      BuildContext context, Map<String, Object?> occurrence) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF292929),
              title: Text(l10n.confirmPayment,
                  style: const TextStyle(color: Colors.white)),
              content: Text(occurrence['rule_name'] as String,
                  style: const TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.pay))
              ],
            ));
    if (ok == true && context.mounted)
      context.read<PlanningBloc>().add(
          PayOccurrence(occurrence['occurrence_id'] as int, DateTime.now()));
  }

  Future<void> _deleteRule(
      BuildContext context, RecurringExpenseRuleModel rule) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF292929),
              content: Text(l10n.deleteConfirmation,
                  style: const TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.delete))
              ],
            ));
    if (confirmed == true && context.mounted)
      context.read<PlanningBloc>().add(RemoveRecurringRule(rule.id!));
  }

  Future<void> _linkExistingExpense(
      BuildContext context, PlanningBillModel bill) async {
    final l10n = AppLocalizations.of(context)!;
    final repository = GetIt.I<DatabaseRepository>();
    final candidates = await repository.getBillExpenseCandidates(bill);
    if (!context.mounted) return;
    final result = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF292929),
              title: Text(l10n.linkExistingExpense,
                  style: const TextStyle(color: Colors.white)),
              content: SizedBox(
                width: 420,
                child: candidates.isEmpty
                    ? Text(l10n.noPlanningItems,
                        style: const TextStyle(color: Colors.white70))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: candidates.length,
                        itemBuilder: (context, index) {
                          final expense = candidates[index];
                          return ListTile(
                            title: Text(expense.item,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                                '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(expense.date)} · ${_money(MoneyAmount.toMinorUnits(expense.amount), _walletCurrency(context.read<PlanningBloc>().state, expense.walletId))}',
                                style: const TextStyle(color: Colors.white60)),
                            onTap: () => Navigator.pop(context, expense.id),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel)),
              ],
            ));
    if (result != null && context.mounted) {
      try {
        await GetIt.I<DatabaseRepository>().linkBillExpense(bill.id!, result);
        if (context.mounted)
          context.read<PlanningBloc>().add(LoadPlanning(DateTime.now()));
      } catch (error) {
        if (context.mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  Widget _navigationTile(BuildContext context, String title, IconData icon,
          _PlanningSection target, {String? trailing}) =>
      Card(
          color: const Color(0xFF292929),
          child: ListTile(
              leading: Icon(icon, color: const Color(0xFFF599DA)),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              trailing: trailing == null
                  ? const Icon(Icons.chevron_right, color: Colors.white60)
                  : Text(trailing,
                      style: const TextStyle(color: Colors.white70)),
              onTap: () => _open(context, target)));

  Widget _billTile(BuildContext context, PlanningBillModel bill) => ListTile(
        title: Text(bill.title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
            '${DateFormat.yMMMd().format(bill.dueDate)} · ${_billStatus(context, bill.statusOn(DateTime.now()))}',
            style: const TextStyle(color: Colors.white60)),
        trailing: Text(
            _money(
                bill.amountMinor,
                _walletCurrency(
                    context.read<PlanningBloc>().state, bill.walletId)),
            style: const TextStyle(color: Colors.white)),
      );

  Widget _sectionHeader(String label, int count) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text('$label ($count)',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)));
  Widget _empty(String label) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(label,
          style: const TextStyle(color: Colors.white54),
          textAlign: TextAlign.center));
  Widget _card({required Widget child}) => Card(
      color: const Color(0xFF292929),
      child: Padding(padding: const EdgeInsets.all(16), child: child));
  Widget _labelValue(String label, String value, {bool large = false}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: Colors.white70, fontSize: large ? 16 : 14))),
            const SizedBox(width: 8),
            Flexible(
                child: Text(value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: large ? 20 : 14,
                        fontWeight:
                            large ? FontWeight.bold : FontWeight.normal)))
          ]));
  Widget _textField(TextEditingController controller, String label,
          {bool numeric = false}) =>
      TextField(
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70)));
  Widget _dropdown<T>(String label, T value, List<DropdownMenuItem<T>> items,
          ValueChanged<T?> onChanged) =>
      DropdownButtonFormField<T>(
          value: value,
          dropdownColor: const Color(0xFF353535),
          decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70)),
          items: items,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white));

  Future<DateTime?> _pickDate(BuildContext context, DateTime initial) =>
      showDatePicker(
        context: context,
        initialDate: DateTime(initial.year, initial.month, initial.day),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                    primary: Color(0xFFF599DA), surface: Color(0xFF292929))),
            child: child!),
      );

  String _money(int minor, String currency) {
    final sign = minor < 0 ? '-' : '';
    final absolute = minor.abs();
    final major =
        NumberFormat.decimalPattern().format(absolute ~/ MoneyAmount.factor);
    final fraction = (absolute % MoneyAmount.factor).toString().padLeft(2, '0');
    return '$sign$currency $major.$fraction';
  }

  String _amountInput(int minor) =>
      '${minor ~/ 100}.${(minor.abs() % 100).toString().padLeft(2, '0')}';
  int? _parseMinor(String text) {
    final match = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$').firstMatch(text.trim());
    if (match == null) return null;
    return int.parse(match[1]!) * 100 +
        int.parse((match[2] ?? '').padRight(2, '0'));
  }

  int _reminderBit(int days) => switch (days) { 3 => 1, 1 => 2, _ => 4 };
  String _walletCurrency(PlanningState state, int id) {
    for (final wallet in state.wallets) {
      if (wallet.id == id) return wallet.currency;
    }
    return state.wallets.isEmpty ? 'IDR' : state.wallets.first.currency;
  }

  String _frequencyName(BuildContext context, String frequency) =>
      frequency == 'weekly'
          ? AppLocalizations.of(context)!.weekly
          : AppLocalizations.of(context)!.monthly;
  String _billStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      'paid' => l10n.paid,
      'overdue' => l10n.overdue,
      'due_today' => l10n.dueToday,
      'cancelled' => l10n.cancelled,
      _ => l10n.upcoming
    };
  }
}
