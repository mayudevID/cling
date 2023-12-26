import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
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
          SizedBox(height: 16.hmea),
          nameAndNotification(context),
          SizedBox(height: 24.hmea),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.wmea),
            padding: EdgeInsets.symmetric(
              horizontal: 16.wmea,
              vertical: 16.hmea,
            ),
            decoration: BoxDecoration(
              //color: Colors.white,
              color: const Color(0x3D787880),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalBalance,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
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

                    return WarningAmountIcon(
                      content:
                          AppLocalizations.of(context)!.warningTotalBalance,
                    );
                  },
                ),
                SizedBox(width: 8.wmea),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) {
                    return p.totalBalance != c.totalBalance;
                  },
                  builder: (context, state) {
                    return NominalMoneyFormatter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                      amount: state.totalBalance,
                      decimalDigits: 2,
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
          SizedBox(height: 16.hmea),
          incomeAndExpense(context),
          ...tagNameHome(context, AppLocalizations.of(context)!.goals),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) {
              return prev.listGoals != next.listGoals ||
                  prev.totalGoals != next.totalGoals;
            },
            builder: (context, state) {
              if (state.listGoals.isEmpty) return emptyGoalsWidget(context);

              final isMoreThanFive = state.totalGoals > 5;
              final length = isMoreThanFive ? 6 : state.listGoals.length;

              return SizedBox(
                height: 156.855.hmea,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: length,
                  itemBuilder: (context, idx) {
                    if (idx == 5) {
                      return seeAllWidget(context);
                    }

                    return widgetGoals(
                      context,
                      idx,
                      state.listGoals[idx],
                      length,
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
                  padding: EdgeInsets.symmetric(horizontal: 24.wmea),
                  child: Text(
                    AppLocalizations.of(context)!.noExpenseToday,
                    style: const TextStyle(
                      fontFamily: FontFamily.cabinetGrotesk,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.separated(
                  itemCount: state.listTodayExpenses.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return todayExpensesWidget(state.listTodayExpenses[index]);
                  },
                  separatorBuilder: (_, idx) {
                    return SizedBox(height: 6.hmea);
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 180.hmea,
          ),
        ],
      ),
    );
  }
}
