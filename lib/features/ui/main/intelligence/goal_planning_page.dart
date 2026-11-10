import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/financial_intelligence.dart';
import '../../../../core/financial_feature_theme.dart';
import '../../../../core/money_amount.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/goal_model.dart';
import '../../../model/wallet_model.dart';
import '../../../repository/database_repository.dart';

class GoalPlanningPage extends StatefulWidget {
  const GoalPlanningPage({super.key, required this.goalId});
  final int goalId;
  @override
  State<GoalPlanningPage> createState() => _GoalPlanningPageState();
}

class _GoalPlanningPageState extends State<GoalPlanningPage> {
  late final DatabaseRepository _repository;
  late final int _revision;
  late final Future<
      ({
        GoalModel goal,
        List<WalletModel> wallets,
        String currency,
        int? discretionaryMinorPerDay,
        int recentContributionMinor,
        int recentContributionDays,
      })> _future;

  @override
  void initState() {
    super.initState();
    _repository = GetIt.I<DatabaseRepository>();
    _revision = _repository.revision;
    _future = _repository.getGoalPlanningContext(widget.goalId, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FinancialFeatureTheme(
      child: Scaffold(
        backgroundColor: const Color(0xFF101010),
        appBar: AppBar(
          backgroundColor: const Color(0xFF101010),
          title: Text(
            l10n.smartGoalPlanning,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF599DA)),
              );
            }
            if (snapshot.hasError || _revision != _repository.revision) {
              return Center(
                child: Text(
                  snapshot.error?.toString() ??
                      l10n.purchaseInsufficientInformation,
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }
            return _GoalPlanForm(
              repository: _repository,
              contextData: snapshot.requireData,
            );
          },
        ),
      ),
    );
  }
}

typedef _PlanningContext = ({
  GoalModel goal,
  List<WalletModel> wallets,
  String currency,
  int? discretionaryMinorPerDay,
  int recentContributionMinor,
  int recentContributionDays,
});

class _GoalPlanForm extends StatefulWidget {
  const _GoalPlanForm({required this.repository, required this.contextData});
  final DatabaseRepository repository;
  final _PlanningContext contextData;
  @override
  State<_GoalPlanForm> createState() => _GoalPlanFormState();
}

class _GoalPlanFormState extends State<_GoalPlanForm> {
  late final TextEditingController _target;
  late final TextEditingController _whatIfContribution;
  late DateTime? _targetDate;
  late String _frequency;
  late int _priority;
  late int _walletId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final goal = widget.contextData.goal;
    _target = TextEditingController(text: goal.target.toStringAsFixed(2));
    _whatIfContribution = TextEditingController();
    _targetDate = goal.targetDate;
    _frequency = goal.contributionFrequency;
    _priority = goal.planningPriority ?? 0;
    _walletId = widget.contextData.wallets
            .any((wallet) => wallet.id == goal.planningWalletId)
        ? goal.planningWalletId!
        : -1;
    _target.addListener(() => setState(() {}));
    _whatIfContribution.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _target.dispose();
    _whatIfContribution.dispose();
    super.dispose();
  }

  int? _parseMinor(String input) {
    final value = input.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final major = int.tryParse(parts.first);
    final fraction =
        parts.length == 1 ? 0 : int.tryParse(parts.last.padRight(2, '0'));
    if (major == null || fraction == null) return null;
    return major * 100 + fraction;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goal = widget.contextData.goal;
    final targetMinor = _parseMinor(_target.text);
    final whatIfContributionMinor = _parseMinor(_whatIfContribution.text) ?? 0;
    final validTarget = targetMinor != null &&
        targetMinor > 0 &&
        targetMinor >=
            MoneyAmount.toMinorUnits(goal.collected, allowZero: true);
    final projection = validTarget
        ? projectGoalPlan(
            targetMinor: targetMinor,
            collectedMinor:
                MoneyAmount.toMinorUnits(goal.collected, allowZero: true),
            today: DateTime.now(),
            targetDate: _targetDate,
            frequency: _frequency,
            discretionaryMinorPerDay:
                widget.contextData.discretionaryMinorPerDay,
            recentContributionMinor: widget.contextData.recentContributionMinor,
            recentContributionDays: widget.contextData.recentContributionDays,
            simulatedContributionMinor: whatIfContributionMinor,
          )
        : null;
    final wallets = widget.contextData.wallets;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _box(
          child: Text(
            l10n.goalTrackingOnlyDisclosure,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _target,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(l10n.targetAmount),
        ),
        if (!validTarget)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.collectedHigher,
              style: const TextStyle(color: Color(0xFFFF8A8A)),
            ),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _whatIfContribution,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(l10n.goalWhatIfContribution),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _frequency,
          dropdownColor: const Color(0xFF292929),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(l10n.goalContributionFrequency),
          items: [
            DropdownMenuItem(value: 'weekly', child: Text(l10n.weekly)),
            DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
          ],
          onChanged: (value) => setState(() => _frequency = value ?? 'monthly'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final latest = DateTime(now.year + 30, now.month, now.day);
            final stored = _targetDate;
            final initial = stored == null || stored.isBefore(today)
                ? DateTime(now.year, now.month + 3, now.day)
                : stored.isAfter(latest)
                    ? latest
                    : stored;
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: today,
              lastDate: latest,
            );
            if (picked != null && mounted) setState(() => _targetDate = picked);
          },
          icon: const Icon(Icons.event, color: Color(0xFFF599DA)),
          label: Text(
            _targetDate == null
                ? l10n.goalTargetDate
                : '${l10n.goalTargetDate}: ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_targetDate!)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        if (_targetDate != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _targetDate = null),
              child: Text(
                l10n.clear,
                style: const TextStyle(color: Color(0xFFF599DA)),
              ),
            ),
          ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _priority,
          dropdownColor: const Color(0xFF292929),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(l10n.goalPriority),
          items: [
            DropdownMenuItem(value: 0, child: Text(l10n.none)),
            for (var i = 1; i <= 5; i++)
              DropdownMenuItem(value: i, child: Text('$i')),
          ],
          onChanged: (value) => setState(() => _priority = value ?? 0),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: wallets.any((w) => w.id == _walletId) ? _walletId : -1,
          dropdownColor: const Color(0xFF292929),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(l10n.goalPlanningWallet),
          items: [
            DropdownMenuItem(value: -1, child: Text(l10n.none)),
            ...wallets.map(
              (wallet) =>
                  DropdownMenuItem(value: wallet.id, child: Text(wallet.name)),
            ),
          ],
          onChanged: (value) => setState(() => _walletId = value ?? -1),
        ),
        const SizedBox(height: 18),
        if (projection != null) _projection(context, l10n, projection),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: _saving || !validTarget ? null : () => _save(targetMinor),
          style:
              FilledButton.styleFrom(backgroundColor: const Color(0xFFF599DA)),
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.saveGoalPlan),
        ),
      ],
    );
  }

  Widget _projection(
    BuildContext context,
    AppLocalizations l10n,
    GoalPlanProjection p,
  ) {
    String money(int amount) => NumberFormat.currency(
          locale: Localizations.localeOf(context).toString(),
          name: widget.contextData.currency,
        ).format(amount / 100);
    final status = switch (p.feasibility) {
      GoalFeasibility.completed => l10n.goalCompleted,
      GoalFeasibility.onTrack => l10n.goalOnTrack,
      GoalFeasibility.needsAdjustment => l10n.goalNeedsAdjustment,
      GoalFeasibility.behindTarget => l10n.goalBehind,
      GoalFeasibility.unknown => l10n.goalAffordabilityUnknown,
    };
    final statusColor = switch (p.feasibility) {
      GoalFeasibility.completed ||
      GoalFeasibility.onTrack =>
        const Color(0xFF7CD992),
      GoalFeasibility.needsAdjustment => const Color(0xFFF2C66D),
      GoalFeasibility.behindTarget => const Color(0xFFFF8A8A),
      GoalFeasibility.unknown => Colors.white70,
    };
    return _box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _row(l10n.goalRemaining, money(p.remainingMinor)),
          _row(l10n.goalProgressPercent, '${p.progressPercent}%'),
          if (p.requiredContributionMinor != null)
            _row(
              '${l10n.goalRequiredContribution} (${_frequencyName(context)})',
              money(p.requiredContributionMinor!),
            ),
          if (p.estimatedCompletionDate != null)
            _row(
              l10n.goalEstimatedCompletion,
              DateFormat.yMMMd(Localizations.localeOf(context).toString())
                  .format(p.estimatedCompletionDate!),
            ),
          if (p.whatIfCompletionDate != null)
            _row(
              l10n.goalWhatIfCompletion,
              DateFormat.yMMMd(Localizations.localeOf(context).toString())
                  .format(p.whatIfCompletionDate!),
            ),
          if (widget.contextData.discretionaryMinorPerDay == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.goalAffordabilityUnknown,
                style: const TextStyle(color: Colors.white60),
              ),
            ),
        ],
      ),
    );
  }

  String _frequencyName(BuildContext context) => _frequency == 'weekly'
      ? AppLocalizations.of(context)!.weekly
      : AppLocalizations.of(context)!.monthly;

  Future<void> _save(int targetMinor) async {
    setState(() => _saving = true);
    try {
      final goal = widget.contextData.goal;
      final updated = goal.copyWith(
        target: targetMinor / 100.0,
        targetDate: _targetDate,
        clearTargetDate: _targetDate == null,
        contributionFrequency: _frequency,
        planningPriority: _priority == 0 ? null : _priority,
        clearPlanningPriority: _priority == 0,
        planningWalletId: _walletId < 0 ? null : _walletId,
        clearPlanningWalletId: _walletId < 0,
      );
      await widget.repository.updateGoal(updated);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white60)),
            ),
            const SizedBox(width: 12),
            Text(value, style: const TextStyle(color: Colors.white)),
          ],
        ),
      );

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF599DA)),
        ),
      );

  Widget _box({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF292929),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );
}
