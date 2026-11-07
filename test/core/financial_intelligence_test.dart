import 'package:cling/core/financial_intelligence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cling Check', () {
    test('example keeps canonical minor-unit arithmetic', () {
      final result = assessClingCheck(
        purchaseMinor: 45000000,
        selectedWalletBalanceMinor: 300000000,
        availableBalanceMinor: 300000000,
        spendableBeforeMinor: 165000000,
        daysRemaining: 11,
        selectedDailyAllowanceMinor: 15000000,
        currencyMatches: true,
      );
      expect(result.assessment, ClingCheckAssessment.caution);
      expect(result.spendableAfterMinor, 120000000);
      expect(result.dailyAllowanceAfterMinor, 10909090);
      expect(result.spendableConsumedPercent, 27);
    });

    test('source wallet shortfall takes precedence over total balance', () {
      final result = assessClingCheck(
        purchaseMinor: 50000,
        selectedWalletBalanceMinor: 30000,
        availableBalanceMinor: 1000000,
        spendableBeforeMinor: 500000,
        daysRemaining: 10,
        selectedDailyAllowanceMinor: 50000,
        currencyMatches: true,
      );
      expect(result.assessment, ClingCheckAssessment.insufficientWallet);
      expect(result.selectedWalletAfterMinor, -20000);
    });

    test('mixed currency and missing payday are insufficient information', () {
      final result = assessClingCheck(
        purchaseMinor: 100,
        selectedWalletBalanceMinor: 1000,
        availableBalanceMinor: 1000,
        spendableBeforeMinor: 800,
        daysRemaining: 4,
        selectedDailyAllowanceMinor: 200,
        currencyMatches: false,
      );
      expect(result.assessment, ClingCheckAssessment.insufficientInformation);
      expect(result.spendableAfterMinor, isNull);
    });
  });

  group('Financial insights', () {
    final now = DateTime(2026, 3, 16);

    test(
        'compares equivalent month-to-date periods and ranks commitments first',
        () {
      final result = generateFinancialInsights(FinancialInsightInput(
        now: now,
        monthSpendMinor: 180000,
        monthTransactionCount: 6,
        previousComparableSpendMinor: 150000,
        previousComparableTransactionCount: 4,
        monthBudgetMinor: 200000,
        categories: const [
          InsightCategoryData(
              categoryId: 4,
              name: 'Food',
              currentMinor: 50000,
              previousMinor: 10000,
              currentCount: 3,
              previousCount: 3),
        ],
        commitmentMinor: 40000,
        goalProgressMinor: 25000,
        currency: 'IDR',
      ));
      expect(result.first.type, FinancialInsightType.recurringCommitments);
      expect(result.map((i) => i.type),
          contains(FinancialInsightType.spendingTrend));
      expect(result.map((i) => i.type),
          contains(FinancialInsightType.categoryAnalysis));
      expect(result.map((i) => i.type),
          contains(FinancialInsightType.spendingPace));
      expect(result.map((i) => i.type),
          contains(FinancialInsightType.financialProgress));
      final trend = result.singleWhere((i) =>
          i.type == FinancialInsightType.spendingTrend && i.categoryId == null);
      expect(trend.ratioPercent, 20);
      expect(trend.id, 'trend:2026-03');
      expect(
          result.where((i) =>
              i.type == FinancialInsightType.spendingTrend &&
              i.categoryId == 4),
          hasLength(1));
    });

    test('suppresses percentage insights with sparse or tiny baselines', () {
      final result = generateFinancialInsights(FinancialInsightInput(
        now: now,
        monthSpendMinor: 100000,
        monthTransactionCount: 2,
        previousComparableSpendMinor: 100,
        previousComparableTransactionCount: 2,
        monthBudgetMinor: null,
        categories: const [],
        commitmentMinor: 0,
        goalProgressMinor: 0,
        currency: 'IDR',
      ));
      expect(result, isEmpty);
    });

    test('zero baseline never fabricates an infinite percentage', () {
      final result = generateFinancialInsights(FinancialInsightInput(
        now: now,
        monthSpendMinor: 100000,
        monthTransactionCount: 4,
        previousComparableSpendMinor: 0,
        previousComparableTransactionCount: 0,
        monthBudgetMinor: null,
        categories: const [],
        commitmentMinor: 0,
        goalProgressMinor: 0,
        currency: 'IDR',
      ));
      expect(result, isEmpty);
    });
  });

  group('Smart savings goal planning', () {
    test(
        'uses ceiling division for monthly required contribution and what-if date',
        () {
      final result = projectGoalPlan(
        targetMinor: 600000000,
        collectedMinor: 200000000,
        today: DateTime(2026, 4, 7),
        targetDate: DateTime(2026, 12, 7),
        frequency: 'monthly',
        discretionaryMinorPerDay: 2000000,
        recentContributionMinor: 90000000,
        recentContributionDays: 90,
        simulatedContributionMinor: 50000000,
      );
      expect(result.remainingMinor, 400000000);
      expect(result.periodsRemaining, 8);
      expect(result.requiredContributionMinor, 50000000);
      expect(result.progressPercent, 33);
      expect(result.estimatedCompletionDate, DateTime(2027, 5, 12));
      expect(result.whatIfCompletionDate, DateTime(2026, 12, 7));
      expect(result.feasibility, GoalFeasibility.onTrack);
    });

    test(
        'legacy deadline absence and missing runway keep affordability unknown',
        () {
      final result = projectGoalPlan(
        targetMinor: 1001,
        collectedMinor: 0,
        today: DateTime(2026, 4, 7),
        targetDate: null,
        frequency: 'weekly',
        discretionaryMinorPerDay: null,
        recentContributionMinor: 0,
        recentContributionDays: 90,
      );
      expect(result.requiredContributionMinor, isNull);
      expect(result.feasibility, GoalFeasibility.unknown);
    });

    test('completed goals and expired deadlines are explicit', () {
      final completed = projectGoalPlan(
        targetMinor: 100,
        collectedMinor: 100,
        today: DateTime(2026, 4, 7),
        targetDate: null,
        frequency: 'monthly',
        discretionaryMinorPerDay: null,
        recentContributionMinor: 0,
        recentContributionDays: 90,
      );
      expect(completed.feasibility, GoalFeasibility.completed);
      expect(completed.progressPercent, 100);
      final behind = projectGoalPlan(
        targetMinor: 100,
        collectedMinor: 0,
        today: DateTime(2026, 4, 7),
        targetDate: DateTime(2026, 4, 6),
        frequency: 'monthly',
        discretionaryMinorPerDay: 20,
        recentContributionMinor: 0,
        recentContributionDays: 90,
      );
      expect(behind.feasibility, GoalFeasibility.behindTarget);
    });
  });
}
