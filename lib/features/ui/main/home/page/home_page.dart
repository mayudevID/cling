import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/home_bloc.dart';
import '../widgets/income_and_expense.dart';
import '../widgets/monthy_budget.dart';
import '../widgets/name_and_notification.dart';
import '../widgets/tag_name_home.dart';
import '../widgets/today_expenses_widget.dart';
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
          monthlyBudget(context),
          ...tagNameHome(
            context,
            AppLocalizations.of(context)!.overview,
            withDate: true,
          ),
          incomeAndExpense(context),
          ...tagNameHome(
            context,
            AppLocalizations.of(context)!.goals,
          ),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) {
              return prev.listGoals != next.listGoals;
            },
            builder: (context, state) {
              if (state.listGoals.isEmpty) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.wmea),
                  decoration: BoxDecoration(
                    color: const Color(0x3D787880),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16.hmea,
                      ),
                      Text(
                        AppLocalizations.of(context)!.goalEmpty,
                        style: TextStyle(
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 16.hmea,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.addGoal,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.lib.resources.images.plus.svg(
                              // ignore: deprecated_member_use_from_same_package
                              color: Colors.white,
                              width: 14.wmea,
                            ),
                            SizedBox(
                              width: 4.wmea,
                            ),
                            Text(
                              AppLocalizations.of(context)!.addGoals,
                              style: TextStyle(
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.hmea,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.listGoals.asMap().entries.map(
                    (e) {
                      return widgetGoals(
                        context,
                        e.key,
                        e.value,
                        state.listGoals.length,
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
          ...tagNameHome(
            context,
            AppLocalizations.of(context)!.todayExpenses,
          ),
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
