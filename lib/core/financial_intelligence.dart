enum ClingCheckAssessment {
  withinBudget,
  caution,
  exceedsSpendable,
  insufficientWallet,
  insufficientInformation,
}

class ClingCheckThresholds {
  const ClingCheckThresholds._();

  static const int cautionSpendablePercent = 25;
  static const int cautionDailyAllowancePercent = 20;
  static const int minimumTrendTransactionsPerPeriod = 3;
  static const int minimumMeaningfulBaselineMinor = 10000;
  static const int significantCategorySharePercent = 15;
}

class ClingCheckProjection {
  const ClingCheckProjection({
    required this.assessment,
    required this.balanceBeforeMinor,
    required this.selectedWalletBeforeMinor,
    required this.selectedWalletAfterMinor,
    required this.spendableBeforeMinor,
    required this.spendableAfterMinor,
    required this.dailyAllowanceBeforeMinor,
    required this.dailyAllowanceAfterMinor,
    required this.spendableConsumedPercent,
    required this.daysRemaining,
    required this.reason,
  });

  final ClingCheckAssessment assessment;
  final int balanceBeforeMinor;
  final int selectedWalletBeforeMinor;
  final int selectedWalletAfterMinor;
  final int? spendableBeforeMinor;
  final int? spendableAfterMinor;
  final int? dailyAllowanceBeforeMinor;
  final int? dailyAllowanceAfterMinor;
  final int? spendableConsumedPercent;
  final int? daysRemaining;
  final ClingCheckReason reason;
}

enum ClingCheckReason {
  withinBudget,
  walletShortfall,
  projectedShortfall,
  flexibilityReduced,
  noPlanningProjection,
  mixedCurrency,
}

ClingCheckProjection assessClingCheck({
  required int purchaseMinor,
  required int selectedWalletBalanceMinor,
  required int availableBalanceMinor,
  required int? spendableBeforeMinor,
  required int? daysRemaining,
  required int? selectedDailyAllowanceMinor,
  required bool currencyMatches,
}) {
  if (purchaseMinor <= 0) throw ArgumentError.value(purchaseMinor);
  final walletAfter = selectedWalletBalanceMinor - purchaseMinor;
  if (!currencyMatches ||
      spendableBeforeMinor == null ||
      daysRemaining == null) {
    return ClingCheckProjection(
      assessment: selectedWalletBalanceMinor < purchaseMinor
          ? ClingCheckAssessment.insufficientWallet
          : ClingCheckAssessment.insufficientInformation,
      balanceBeforeMinor: availableBalanceMinor,
      selectedWalletBeforeMinor: selectedWalletBalanceMinor,
      selectedWalletAfterMinor: walletAfter,
      spendableBeforeMinor: null,
      spendableAfterMinor: null,
      dailyAllowanceBeforeMinor: null,
      dailyAllowanceAfterMinor: null,
      spendableConsumedPercent: null,
      daysRemaining: null,
      reason: selectedWalletBalanceMinor < purchaseMinor
          ? ClingCheckReason.walletShortfall
          : currencyMatches
              ? ClingCheckReason.noPlanningProjection
              : ClingCheckReason.mixedCurrency,
    );
  }
  final spendableAfter = spendableBeforeMinor - purchaseMinor;
  final allowanceBefore = selectedDailyAllowanceMinor ??
      (daysRemaining > 0 && spendableBeforeMinor > 0
          ? spendableBeforeMinor ~/ daysRemaining
          : 0);
  final allowanceAfter = daysRemaining > 0 && spendableAfter > 0
      ? spendableAfter ~/ daysRemaining
      : 0;
  final consumedPercent = spendableBeforeMinor <= 0
      ? null
      : (purchaseMinor * 100) ~/ spendableBeforeMinor;

  final ClingCheckAssessment assessment;
  final ClingCheckReason reason;
  if (selectedWalletBalanceMinor < purchaseMinor) {
    assessment = ClingCheckAssessment.insufficientWallet;
    reason = ClingCheckReason.walletShortfall;
  } else if (spendableAfter < 0) {
    assessment = ClingCheckAssessment.exceedsSpendable;
    reason = ClingCheckReason.projectedShortfall;
  } else if ((consumedPercent ?? 100) >=
          ClingCheckThresholds.cautionSpendablePercent ||
      (allowanceBefore > 0 &&
          (allowanceBefore - allowanceAfter) * 100 >=
              allowanceBefore *
                  ClingCheckThresholds.cautionDailyAllowancePercent)) {
    assessment = ClingCheckAssessment.caution;
    reason = ClingCheckReason.flexibilityReduced;
  } else {
    assessment = ClingCheckAssessment.withinBudget;
    reason = ClingCheckReason.withinBudget;
  }

  return ClingCheckProjection(
    assessment: assessment,
    balanceBeforeMinor: availableBalanceMinor,
    selectedWalletBeforeMinor: selectedWalletBalanceMinor,
    selectedWalletAfterMinor: walletAfter,
    spendableBeforeMinor: spendableBeforeMinor,
    spendableAfterMinor: spendableAfter,
    dailyAllowanceBeforeMinor: allowanceBefore,
    dailyAllowanceAfterMinor: allowanceAfter,
    spendableConsumedPercent: consumedPercent,
    daysRemaining: daysRemaining,
    reason: reason,
  );
}

enum FinancialInsightType {
  spendingTrend,
  categoryAnalysis,
  spendingPace,
  recurringCommitments,
  financialProgress,
}

enum FinancialInsightSentiment { positive, neutral, caution, negative }

class FinancialInsight {
  const FinancialInsight({
    required this.id,
    required this.type,
    required this.periodStart,
    required this.periodEnd,
    required this.generatedAt,
    required this.severity,
    this.categoryId,
    this.currentMinor,
    this.previousMinor,
    this.ratioPercent,
    this.count,
  });

  final String id;
  final FinancialInsightType type;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime generatedAt;
  final FinancialInsightSentiment severity;
  final int? categoryId;
  final int? currentMinor;
  final int? previousMinor;
  final int? ratioPercent;
  final int? count;
}

class InsightCategoryData {
  const InsightCategoryData({
    required this.categoryId,
    required this.name,
    required this.currentMinor,
    required this.previousMinor,
    required this.currentCount,
    required this.previousCount,
  });
  final int? categoryId;
  final String name;
  final int currentMinor;
  final int previousMinor;
  final int currentCount;
  final int previousCount;
}

class FinancialInsightInput {
  const FinancialInsightInput({
    required this.now,
    required this.monthSpendMinor,
    required this.monthTransactionCount,
    required this.previousComparableSpendMinor,
    required this.previousComparableTransactionCount,
    required this.monthBudgetMinor,
    required this.categories,
    required this.commitmentMinor,
    required this.goalProgressMinor,
    required this.currency,
  });
  final DateTime now;
  final int monthSpendMinor;
  final int monthTransactionCount;
  final int previousComparableSpendMinor;
  final int previousComparableTransactionCount;
  final int? monthBudgetMinor;
  final List<InsightCategoryData> categories;
  final int commitmentMinor;
  final int goalProgressMinor;
  final String currency;
}

class FinancialInsightCurrencyException implements Exception {
  const FinancialInsightCurrencyException();
}

List<FinancialInsight> generateFinancialInsights(FinancialInsightInput input) {
  final now = input.now;
  final monthStart = DateTime(now.year, now.month);
  final end = DateTime(now.year, now.month, now.day);
  final insights = <FinancialInsight>[];
  if (input.monthSpendMinor != input.previousComparableSpendMinor &&
      input.monthTransactionCount >=
          ClingCheckThresholds.minimumTrendTransactionsPerPeriod &&
      input.previousComparableTransactionCount >=
          ClingCheckThresholds.minimumTrendTransactionsPerPeriod &&
      input.previousComparableSpendMinor >=
          ClingCheckThresholds.minimumMeaningfulBaselineMinor) {
    final diff = input.monthSpendMinor - input.previousComparableSpendMinor;
    final percent = (diff.abs() * 100) ~/ input.previousComparableSpendMinor;
    insights.add(
      FinancialInsight(
        id: 'trend:${now.year}-${now.month.toString().padLeft(2, '0')}',
        type: FinancialInsightType.spendingTrend,
        periodStart: monthStart,
        periodEnd: end,
        generatedAt: now,
        severity: diff > 0
            ? FinancialInsightSentiment.caution
            : FinancialInsightSentiment.positive,
        currentMinor: input.monthSpendMinor,
        previousMinor: input.previousComparableSpendMinor,
        ratioPercent: percent,
        count: diff > 0 ? 1 : -1,
      ),
    );
  }
  final categoryTrends = input.categories
      .where(
        (item) =>
            item.currentCount >=
                ClingCheckThresholds.minimumTrendTransactionsPerPeriod &&
            item.previousCount >=
                ClingCheckThresholds.minimumTrendTransactionsPerPeriod &&
            item.previousMinor >=
                ClingCheckThresholds.minimumMeaningfulBaselineMinor &&
            item.currentMinor != item.previousMinor,
      )
      .toList()
    ..sort((a, b) {
      final aChange =
          ((a.currentMinor - a.previousMinor).abs() * 100) ~/ a.previousMinor;
      final bChange =
          ((b.currentMinor - b.previousMinor).abs() * 100) ~/ b.previousMinor;
      return bChange.compareTo(aChange);
    });
  if (categoryTrends.isNotEmpty) {
    final category = categoryTrends.first;
    final difference = category.currentMinor - category.previousMinor;
    insights.add(
      FinancialInsight(
        id: 'trend:${now.year}-${now.month.toString().padLeft(2, '0')}:category:${category.categoryId ?? 'unknown'}',
        type: FinancialInsightType.spendingTrend,
        periodStart: monthStart,
        periodEnd: end,
        generatedAt: now,
        severity: difference > 0
            ? FinancialInsightSentiment.caution
            : FinancialInsightSentiment.positive,
        categoryId: category.categoryId,
        currentMinor: category.currentMinor,
        previousMinor: category.previousMinor,
        ratioPercent: (difference.abs() * 100) ~/ category.previousMinor,
        count: difference > 0 ? 1 : -1,
      ),
    );
  }
  final categoryCandidates = input.categories
      .where(
        (item) =>
            input.monthSpendMinor > 0 &&
            item.currentCount >= 2 &&
            item.currentMinor * 100 >=
                input.monthSpendMinor *
                    ClingCheckThresholds.significantCategorySharePercent,
      )
      .toList()
    ..sort((a, b) => b.currentMinor.compareTo(a.currentMinor));
  if (categoryCandidates.isNotEmpty) {
    final category = categoryCandidates.first;
    insights.add(
      FinancialInsight(
        id: 'category:${now.year}-${now.month}:${category.categoryId ?? 'unknown'}',
        type: FinancialInsightType.categoryAnalysis,
        periodStart: monthStart,
        periodEnd: end,
        generatedAt: now,
        severity: FinancialInsightSentiment.neutral,
        categoryId: category.categoryId,
        currentMinor: category.currentMinor,
        ratioPercent: (category.currentMinor * 100) ~/ input.monthSpendMinor,
        count: category.currentCount,
      ),
    );
  }
  final daysElapsed = now.day;
  if (input.monthBudgetMinor != null &&
      input.monthBudgetMinor! > 0 &&
      input.monthTransactionCount >=
          ClingCheckThresholds.minimumTrendTransactionsPerPeriod) {
    final spentPercent =
        (input.monthSpendMinor * 100) ~/ input.monthBudgetMinor!;
    final elapsedPercent =
        (daysElapsed * 100) ~/ DateTime(now.year, now.month + 1, 0).day;
    if (spentPercent >= 50 && spentPercent > elapsedPercent + 10) {
      insights.add(
        FinancialInsight(
          id: 'pace:${now.year}-${now.month}',
          type: FinancialInsightType.spendingPace,
          periodStart: monthStart,
          periodEnd: end,
          generatedAt: now,
          severity: FinancialInsightSentiment.caution,
          currentMinor: input.monthSpendMinor,
          previousMinor: input.monthBudgetMinor,
          ratioPercent: spentPercent,
          count: elapsedPercent,
        ),
      );
    }
  }
  if (input.commitmentMinor > 0) {
    insights.add(
      FinancialInsight(
        id: 'commitments:${now.year}-${now.month}-${now.day}',
        type: FinancialInsightType.recurringCommitments,
        periodStart: end,
        periodEnd: end,
        generatedAt: now,
        severity: FinancialInsightSentiment.caution,
        currentMinor: input.commitmentMinor,
      ),
    );
  }
  if (input.goalProgressMinor > 0) {
    insights.add(
      FinancialInsight(
        id: 'goal-progress:${now.year}-${now.month}',
        type: FinancialInsightType.financialProgress,
        periodStart: monthStart,
        periodEnd: end,
        generatedAt: now,
        severity: FinancialInsightSentiment.positive,
        currentMinor: input.goalProgressMinor,
      ),
    );
  }
  const priority = {
    FinancialInsightType.recurringCommitments: 0,
    FinancialInsightType.spendingPace: 1,
    FinancialInsightType.spendingTrend: 2,
    FinancialInsightType.categoryAnalysis: 3,
    FinancialInsightType.financialProgress: 4,
  };
  insights.sort((a, b) {
    final rank = priority[a.type]!.compareTo(priority[b.type]!);
    return rank == 0 ? a.id.compareTo(b.id) : rank;
  });
  return insights;
}

int ceilDivide(int numerator, int denominator) {
  if (numerator < 0 || denominator <= 0) {
    throw ArgumentError('Expected nonnegative numerator and positive divisor.');
  }
  return numerator == 0 ? 0 : 1 + ((numerator - 1) ~/ denominator);
}

enum GoalFeasibility {
  completed,
  onTrack,
  needsAdjustment,
  behindTarget,
  unknown
}

class GoalPlanProjection {
  const GoalPlanProjection({
    required this.remainingMinor,
    required this.daysRemaining,
    required this.periodsRemaining,
    required this.requiredContributionMinor,
    required this.progressPercent,
    required this.estimatedCompletionDate,
    required this.whatIfCompletionDate,
    required this.feasibility,
    required this.recommendedBudgetMinor,
  });
  final int remainingMinor;
  final int? daysRemaining;
  final int? periodsRemaining;
  final int? requiredContributionMinor;
  final int progressPercent;
  final DateTime? estimatedCompletionDate;
  final DateTime? whatIfCompletionDate;
  final GoalFeasibility feasibility;
  final int? recommendedBudgetMinor;
}

GoalPlanProjection projectGoalPlan({
  required int targetMinor,
  required int collectedMinor,
  required DateTime today,
  required DateTime? targetDate,
  required String frequency,
  required int? discretionaryMinorPerDay,
  required int recentContributionMinor,
  required int recentContributionDays,
  int simulatedContributionMinor = 0,
}) {
  if (targetMinor <= 0 ||
      collectedMinor < 0 ||
      collectedMinor > targetMinor ||
      !{'weekly', 'monthly'}.contains(frequency) ||
      simulatedContributionMinor < 0) {
    throw ArgumentError('Invalid goal amounts.');
  }
  final remaining = targetMinor - collectedMinor;
  final progress = (collectedMinor * 100) ~/ targetMinor;
  if (remaining == 0) {
    return GoalPlanProjection(
      remainingMinor: 0,
      daysRemaining: 0,
      periodsRemaining: 0,
      requiredContributionMinor: 0,
      progressPercent: 100,
      estimatedCompletionDate: today,
      whatIfCompletionDate: today,
      feasibility: GoalFeasibility.completed,
      recommendedBudgetMinor: discretionaryMinorPerDay == null
          ? null
          : discretionaryMinorPerDay *
              (frequency == 'weekly'
                  ? 7
                  : DateTime(today.year, today.month + 1, 0).day),
    );
  }
  final days = targetDate == null
      ? null
      : DateTime(targetDate.year, targetDate.month, targetDate.day)
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
  final periods = days == null
      ? null
      : days <= 0
          ? 0
          : frequency == 'weekly'
              ? ceilDivide(days, 7)
              : mathMaxInt(
                  1,
                  (targetDate!.year - today.year) * 12 +
                      targetDate.month -
                      today.month,
                );
  final required =
      periods == null || periods <= 0 ? null : ceilDivide(remaining, periods);
  final budget = discretionaryMinorPerDay == null
      ? null
      : discretionaryMinorPerDay *
          (frequency == 'weekly'
              ? 7
              : DateTime(today.year, today.month + 1, 0).day);
  DateTime? completion;
  if (recentContributionMinor > 0 && recentContributionDays > 0) {
    final daysToComplete = ceilDivide(
      remaining * recentContributionDays,
      recentContributionMinor,
    );
    completion = DateTime(today.year, today.month, today.day)
        .add(Duration(days: daysToComplete));
  }
  DateTime? whatIfCompletion;
  if (simulatedContributionMinor > 0) {
    final periods = ceilDivide(remaining, simulatedContributionMinor);
    if (frequency == 'weekly') {
      whatIfCompletion = DateTime(today.year, today.month, today.day)
          .add(Duration(days: periods * 7));
    } else {
      final monthIndex = today.year * 12 + today.month - 1 + periods;
      final year = monthIndex ~/ 12;
      final month = monthIndex % 12 + 1;
      final lastDay = DateTime(year, month + 1, 0).day;
      whatIfCompletion =
          DateTime(year, month, today.day.clamp(1, lastDay).toInt());
    }
  }
  final feasibility = required == null
      ? (days != null && days <= 0
          ? GoalFeasibility.behindTarget
          : GoalFeasibility.unknown)
      : budget == null
          ? GoalFeasibility.unknown
          : required <= budget
              ? GoalFeasibility.onTrack
              : GoalFeasibility.needsAdjustment;
  return GoalPlanProjection(
    remainingMinor: remaining,
    daysRemaining: days,
    periodsRemaining: periods,
    requiredContributionMinor: required,
    progressPercent: progress,
    estimatedCompletionDate: completion,
    whatIfCompletionDate: whatIfCompletion,
    feasibility: feasibility,
    recommendedBudgetMinor: budget,
  );
}

int mathMaxInt(int a, int b) => a > b ? a : b;
