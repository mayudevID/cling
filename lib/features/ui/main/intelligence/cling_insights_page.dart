import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/financial_intelligence.dart';
import '../../../../core/init_database.dart';
import '../../../../core/money_amount.dart';
import '../../../../core/route.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/database_repository.dart';
import '../../../repository/settings_repository.dart';
import 'financial_insights_bloc.dart';

class ClingInsightsPage extends StatelessWidget {
  const ClingInsightsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => FinancialInsightsBloc(GetIt.I<DatabaseRepository>()),
        child: const _InsightsContent(),
      );
}

class _InsightsContent extends StatefulWidget {
  const _InsightsContent();
  @override
  State<_InsightsContent> createState() => _InsightsContentState();
}

class _InsightsContentState extends State<_InsightsContent> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = GetIt.I<DatabaseRepository>();
    final revision = repository.revision;
    int? budgetMinor;
    try {
      final user = GetIt.I<AuthRepository>().currentUserModel;
      final currencyPreference =
          GetIt.I<SettingsRepository>().getCurrentCurrency();
      final wallets = await repository.getWallets(includeArchived: false);
      if (user != null && user.monthlyBudget > 0 && wallets.isNotEmpty) {
        final homogeneous = wallets
            .every((wallet) => wallet.currency == wallets.first.currency);
        if (homogeneous &&
            (currencyPreference == null ||
                currencyPreference == wallets.first.currency)) {
          budgetMinor = MoneyAmount.toMinorUnits(user.monthlyBudget);
        }
      }
    } catch (_) {
      budgetMinor = null;
    }
    if (!mounted || revision != repository.revision) return;
    context.read<FinancialInsightsBloc>().add(LoadFinancialInsights(
          now: DateTime.now(),
          budgetMinor: budgetMinor,
        ));
  }

  String _money(BuildContext context, int? amount, String currency) =>
      NumberFormat.currency(
        locale: Localizations.localeOf(context).toString(),
        name: currency,
      ).format((amount ?? 0) / MoneyAmount.factor);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        title: Text(l10n.clingInsights,
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocBuilder<FinancialInsightsBloc, FinancialInsightsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF599DA)));
          }
          if (state.error != null) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                  state.currencyMismatch
                      ? l10n.insightsCurrencyUnavailable
                      : l10n.financialInsightsError,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
            ));
          }
          if (state.insights.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(28),
              child: Text(l10n.noInsightsYet,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
            ));
          }
          final visible = state.insights.take(3).toList();
          return RefreshIndicator(
            onRefresh: _load,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Text(l10n.insightsExplainable,
                  style: const TextStyle(color: Colors.white60)),
              const SizedBox(height: 12),
              ...visible.map((insight) => _InsightCard(
                    insight: insight,
                    currency: state.currency,
                    money: (amount) => _money(context, amount, state.currency),
                  )),
              if (state.insights.length > visible.length) ...[
                const SizedBox(height: 12),
                Text(l10n.moreInsights,
                    style: const TextStyle(color: Colors.white70)),
                ...state.insights
                    .skip(visible.length)
                    .map((insight) => _InsightCard(
                          insight: insight,
                          currency: state.currency,
                          money: (amount) =>
                              _money(context, amount, state.currency),
                        )),
              ],
            ]),
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard(
      {required this.insight, required this.currency, required this.money});
  final FinancialInsight insight;
  final String currency;
  final String Function(int?) money;

  String titleFor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (insight.type) {
      FinancialInsightType.spendingTrend => l10n.insightSpendingTrend,
      FinancialInsightType.categoryAnalysis => l10n.insightCategoryAnalysis,
      FinancialInsightType.spendingPace => l10n.insightSpendingPace,
      FinancialInsightType.recurringCommitments => l10n.insightCommitments,
      FinancialInsightType.financialProgress => l10n.insightFinancialProgress,
    };
  }

  String descriptionFor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (insight.type) {
      FinancialInsightType.spendingTrend => insight.categoryId != null
          ? (insight.count != null && insight.count! > 0
              ? l10n.insightCategoryTrendUp(
                  _categoryName(insight.categoryId), insight.ratioPercent ?? 0)
              : l10n.insightCategoryTrendDown(
                  _categoryName(insight.categoryId), insight.ratioPercent ?? 0))
          : (insight.count != null && insight.count! > 0
              ? l10n.insightTrendUp(insight.ratioPercent ?? 0)
              : l10n.insightTrendDown(insight.ratioPercent ?? 0)),
      FinancialInsightType.categoryAnalysis =>
        l10n.insightCategoryShareDescription(
            _categoryName(insight.categoryId), insight.ratioPercent ?? 0),
      FinancialInsightType.spendingPace => l10n.insightPaceDescription(
          insight.ratioPercent ?? 0, insight.count ?? 0),
      FinancialInsightType.recurringCommitments =>
        l10n.insightCommitmentsDescription(money(insight.currentMinor)),
      FinancialInsightType.financialProgress =>
        l10n.insightGoalProgressDescription(money(insight.currentMinor)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final title = titleFor(context);
    final description = descriptionFor(context);
    final color = switch (insight.severity) {
      FinancialInsightSentiment.positive => const Color(0xFF7CD992),
      FinancialInsightSentiment.neutral => const Color(0xFFF599DA),
      FinancialInsightSentiment.caution => const Color(0xFFF2C66D),
      FinancialInsightSentiment.negative => const Color(0xFFFF8A8A),
    };
    return Card(
      color: const Color(0xFF292929),
      child: ListTile(
        leading: Icon(Icons.insights_outlined, color: color),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child:
              Text(description, style: const TextStyle(color: Colors.white70)),
        ),
        onTap: () => Navigator.pushNamed(context, RouteName.insightDetail,
            arguments: InsightDetailArgs(insight: insight, currency: currency)),
      ),
    );
  }

  String _categoryName(int? id) {
    if (id == null || id < 0 || id >= exCategoriesData.length) return 'Other';
    final value = exCategoriesData[id];
    final split = value.indexOf(' ');
    return split < 0 ? value : value.substring(split + 1);
  }
}

class InsightDetailArgs {
  const InsightDetailArgs({required this.insight, required this.currency});
  final FinancialInsight insight;
  final String currency;
}

class FinancialInsightDetailPage extends StatelessWidget {
  const FinancialInsightDetailPage({super.key, required this.args});
  final InsightDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final card = _InsightCard(
      insight: args.insight,
      currency: args.currency,
      money: (amount) => NumberFormat.currency(
        locale: Localizations.localeOf(context).toString(),
        name: args.currency,
      ).format((amount ?? 0) / MoneyAmount.factor),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
          backgroundColor: const Color(0xFF101010),
          title: Text(l10n.clingInsights,
              style: const TextStyle(color: Colors.white))),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: const Color(0xFF292929),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.titleFor(context),
                        style: const TextStyle(
                            color: Color(0xFFF599DA),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(card.descriptionFor(context),
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    Text(
                        '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(args.insight.periodStart)} – ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(args.insight.periodEnd)}',
                        style: const TextStyle(color: Colors.white60)),
                    if (args.insight.previousMinor != null) ...[
                      const Divider(color: Colors.white24, height: 28),
                      Text(
                          '${l10n.previousPeriod}: ${card.money(args.insight.previousMinor)}',
                          style: const TextStyle(color: Colors.white70)),
                      Text(
                          '${l10n.currentPeriod}: ${card.money(args.insight.currentMinor)}',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ],
                )),
          )),
    );
  }
}
