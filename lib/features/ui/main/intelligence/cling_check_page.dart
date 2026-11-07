import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/financial_intelligence.dart';
import '../../../../core/money_amount.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/financial_planning_models.dart';
import '../../../model/wallet_model.dart';
import '../../../repository/database_repository.dart';

class ClingCheckPage extends StatefulWidget {
  const ClingCheckPage({super.key});
  @override
  State<ClingCheckPage> createState() => _ClingCheckPageState();
}

class _ClingCheckPageState extends State<ClingCheckPage> {
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  late final DatabaseRepository _repository;
  late final int _revision;
  late Future<({List<WalletModel> wallets, PaydayRunwayModel? runway})>
      _contextFuture;
  int? _walletId;

  @override
  void initState() {
    super.initState();
    _repository = GetIt.I<DatabaseRepository>();
    _revision = _repository.revision;
    _contextFuture = _repository.getClingCheckContext(DateTime.now());
    _contextFuture.then((data) {
      if (mounted &&
          _revision == _repository.revision &&
          data.wallets.isNotEmpty) {
        setState(
          () => _walletId = data.wallets
              .firstWhere(
                (wallet) => wallet.isDefault,
                orElse: () => data.wallets.first,
              )
              .id,
        );
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  int? _parseMinor(String value) {
    final input = value.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(input)) return null;
    final parts = input.split('.');
    final major = int.tryParse(parts.first);
    final fraction =
        parts.length == 1 ? 0 : int.tryParse(parts.last.padRight(2, '0'));
    if (major == null || fraction == null) return null;
    return major * MoneyAmount.factor + fraction;
  }

  String _money(BuildContext context, int minor, String currency) =>
      NumberFormat.currency(
        locale: Localizations.localeOf(context).toString(),
        name: currency,
      ).format(minor / MoneyAmount.factor);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        title:
            Text(l10n.clingCheck, style: const TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<
          ({List<WalletModel> wallets, PaydayRunwayModel? runway})>(
        future: _contextFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF599DA)),
            );
          }
          if (snapshot.hasError || _revision != _repository.revision) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error?.toString() ??
                      l10n.purchaseInsufficientInformation,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final data = snapshot.requireData;
          if (data.wallets.isEmpty) {
            return Center(
              child: Text(
                l10n.noWallets,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }
          final wallets = data.wallets;
          var selected = wallets.first;
          for (final wallet in wallets) {
            if (wallet.id == _walletId) selected = wallet;
          }
          final amountMinor = _parseMinor(_amount.text);
          final runway = data.runway;
          final projection = amountMinor == null || amountMinor <= 0
              ? null
              : assessClingCheck(
                  purchaseMinor: amountMinor,
                  selectedWalletBalanceMinor: selected.balanceMinor,
                  availableBalanceMinor:
                      runway?.availableMinor ?? selected.balanceMinor,
                  spendableBeforeMinor: runway?.estimatedSpendableMinor,
                  daysRemaining: runway?.daysRemaining,
                  selectedDailyAllowanceMinor: runway?.dailyAllowanceMinor,
                  currencyMatches:
                      runway != null && selected.currency == runway.currency,
                );
          final currency = runway?.currency ?? selected.currency;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _panel(
                child: Text(
                  l10n.estimateNotGuarantee,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(l10n.checkPurchaseName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amount,
                onChanged: (_) => setState(() {}),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(l10n.purchaseAmount),
              ),
              if (_amount.text.isNotEmpty &&
                  (_parseMinor(_amount.text) ?? 0) <= 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l10n.invalidAmount,
                    style: const TextStyle(color: Color(0xFFFF8A8A)),
                  ),
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selected.id,
                dropdownColor: const Color(0xFF292929),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(l10n.sourceWallet),
                items: wallets
                    .map(
                      (wallet) => DropdownMenuItem(
                        value: wallet.id,
                        child: Text(
                          '${wallet.name} · ${_money(context, wallet.balanceMinor, wallet.currency)}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (id) => setState(() => _walletId = id),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                onChanged: (_) => setState(() {}),
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(l10n.note),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.plannedTodayOnly,
                style: const TextStyle(color: Colors.white54),
              ),
              if (projection != null) ...[
                const SizedBox(height: 16),
                _resultCard(
                  context,
                  l10n,
                  projection,
                  currency,
                  runway,
                  _name.text.trim(),
                  _note.text.trim(),
                ),
                if (runway != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.obligationsBeforePayday,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...runway.includedBills.map(
                    (item) => _obligation(
                      context,
                      item.name,
                      item.amountMinor,
                      currency,
                    ),
                  ),
                  ...runway.includedRecurringDetails.map(
                    (item) => _obligation(
                      context,
                      item.name,
                      item.amountMinor,
                      currency,
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _resultCard(
    BuildContext context,
    AppLocalizations l10n,
    ClingCheckProjection projection,
    String currency,
    PaydayRunwayModel? runway,
    String itemName,
    String note,
  ) {
    final title = switch (projection.assessment) {
      ClingCheckAssessment.withinBudget => l10n.purchaseWithinBudget,
      ClingCheckAssessment.caution => l10n.purchaseCaution,
      ClingCheckAssessment.exceedsSpendable => l10n.purchaseExceedsSpendable,
      ClingCheckAssessment.insufficientWallet =>
        l10n.purchaseInsufficientWallet,
      ClingCheckAssessment.insufficientInformation =>
        l10n.purchaseInsufficientInformation,
    };
    String reason;
    switch (projection.reason) {
      case ClingCheckReason.walletShortfall:
        reason = l10n.reasonWalletShortfall(
          _money(context, -projection.selectedWalletAfterMinor, currency),
        );
      case ClingCheckReason.projectedShortfall:
        reason = l10n.reasonProjectedShortfall(
          _money(context, -projection.spendableAfterMinor!, currency),
        );
      case ClingCheckReason.flexibilityReduced:
        reason = l10n.reasonFlexibilityReduced(
          _money(context, projection.dailyAllowanceBeforeMinor!, currency),
          _money(context, projection.dailyAllowanceAfterMinor!, currency),
        );
      case ClingCheckReason.withinBudget:
        reason = l10n.reasonWithinBudget;
      case ClingCheckReason.noPlanningProjection:
      case ClingCheckReason.mixedCurrency:
        reason = l10n.reasonNoProjection;
    }
    final color = projection.assessment == ClingCheckAssessment.withinBudget
        ? const Color(0xFF7CD992)
        : projection.assessment == ClingCheckAssessment.caution
            ? const Color(0xFFF2C66D)
            : const Color(0xFFFF8A8A);
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (itemName.isNotEmpty) ...[
            Text(itemName, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
          ],
          if (note.isNotEmpty) ...[
            Text(note, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(reason, style: const TextStyle(color: Colors.white70)),
          const Divider(color: Colors.white24, height: 24),
          _value(
            l10n.availableBefore,
            _money(context, projection.balanceBeforeMinor, currency),
          ),
          _value(
            l10n.walletAfterPurchase,
            _money(context, projection.selectedWalletAfterMinor, currency),
          ),
          if (runway != null) ...[
            _value(
              l10n.nextPayday,
              DateFormat.yMMMd(Localizations.localeOf(context).toString())
                  .format(runway.payday),
            ),
            _value(
              l10n.expectedIncome,
              _money(context, runway.expectedIncomeMinor, currency),
            ),
          ],
          if (projection.spendableBeforeMinor != null) ...[
            _value(
              l10n.spendableBefore,
              _money(context, projection.spendableBeforeMinor!, currency),
            ),
            _value(
              l10n.spendableAfter,
              _money(context, projection.spendableAfterMinor!, currency),
            ),
            _value(
              l10n.dailyAllowanceBefore,
              _money(context, projection.dailyAllowanceBeforeMinor!, currency),
            ),
            _value(
              l10n.dailyAllowanceAfter,
              _money(context, projection.dailyAllowanceAfterMinor!, currency),
            ),
            if (projection.spendableConsumedPercent != null)
              _value(
                l10n.budgetConsumed,
                '${projection.spendableConsumedPercent}%',
              ),
          ],
        ],
      ),
    );
  }

  Widget _obligation(
    BuildContext context,
    String name,
    int amount,
    String currency,
  ) =>
      ListTile(
        dense: true,
        title: Text(name, style: const TextStyle(color: Colors.white70)),
        trailing: Text(
          _money(context, amount, currency),
          style: const TextStyle(color: Colors.white70),
        ),
      );

  Widget _value(String label, String value) => Padding(
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

  Widget _panel({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF292929),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );
}
