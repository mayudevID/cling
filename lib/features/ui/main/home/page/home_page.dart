import '../../../../../core/common_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/home_bloc.dart';
import '../widgets/empty_goal_widget.dart';
import '../widgets/income_and_expense.dart';
import '../widgets/monthy_budget.dart';
import '../widgets/name_and_notification.dart';
import '../widgets/see_all_widget.dart';
import '../widgets/tag_name_home.dart';
import '../widgets/today_expenses_widget.dart';
import '../widgets/warning_amount_icon.dart';
import '../widgets/widget_goals.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          nameAndNotification(context),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0x3D787880),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.totalBalance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) {
                    return p.totalBalance != c.totalBalance;
                  },
                  builder: (context, state) {
                    if (state.totalBalance >= 0) return const SizedBox();

                    return warningAmountIcon(
                      content:
                          AppLocalizations.of(context)!.warningTotalBalance,
                    );
                  },
                ),
                const SizedBox(width: 8),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) {
                    return p.totalBalance != c.totalBalance;
                  },
                  builder: (context, state) {
                    return NominalMoneyFormatter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                      amount: state.totalBalance,
                      isWithName: true,
                    );
                  },
                ),
              ],
            ),
          ),
          ...tagNameHome(
            context,
            AppLocalizations.of(context)!.overview,
            withDate: true,
          ),
          monthlyBudget(context),
          const SizedBox(height: 16),
          incomeAndExpense(context),
          ...tagNameHome(context, AppLocalizations.of(context)!.goals),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (p, c) => p.listGoals != c.listGoals,
            builder: (context, state) {
              if (state.listGoals.isEmpty) return emptyGoalsWidget(context);

              final lengthD = state.totalGoals > 5 ? 6 : state.listGoals.length;

              return SizedBox(
                height: 128,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: lengthD,
                  itemBuilder: (context, idx) {
                    if (idx == 5) return seeAllWidget(context);

                    return widgetGoals(
                      context,
                      idx,
                      state.listGoals[idx],
                      lengthD,
                    );
                  },
                ),
              );
            },
          ),
          ...tagNameHome(context, AppLocalizations.of(context)!.todayExpenses),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) {
              return prev.listTodayExpenses != next.listTodayExpenses;
            },
            builder: (context, state) {
              if (state.listTodayExpenses.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    AppLocalizations.of(context)!.noExpenseToday,
                    style: const TextStyle(
                      fontFamily: FontFamily.cabinetGrotesk,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.listTodayExpenses.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return todayExpensesWidget(
                    context,
                    state.listTodayExpenses[index],
                  );
                },
                separatorBuilder: (_, idx) => const SizedBox(height: 6),
              );
            },
          ),
          const SizedBox(height: 185),
        ],
      ),
    );
  }
}
