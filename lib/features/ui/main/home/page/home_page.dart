import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../language/lang_export.dart';
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
          SizedBox(
            height: 16.hmea,
          ),
          nameAndNotification(),
          SizedBox(
            height: 24.hmea,
          ),
          monthlyBudget(context),
          ...tagNameHome(AppLocalizations.of(context)!.overview),
          incomeAndExpense(context),
          ...tagNameHome(AppLocalizations.of(context)!.goals),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dataDummy.asMap().entries.map((e) {
                return widgetGoals(e, dataDummy.length);
              }).toList(),
            ),
          ),
          ...tagNameHome(AppLocalizations.of(context)!.todayExpenses),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) {
              return prev.listTodayExpenses != next.listTodayExpenses;
            },
            builder: (context, state) {
              if (state.listTodayExpenses.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.wmea),
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
                child: ListView.builder(
                  itemCount: state.listTodayExpenses.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return todayExpensesWidget(
                      state.listTodayExpenses[index],
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 90.hmea,
          ),
        ],
      ),
    );
  }
}

List<Map> dataDummy = [
  {
    "image": Assets.lib.resources.images.phone.svg(),
    "name": "New Phone",
    "target": 9000000.0,
    "collected": 6840000,
  },
  {
    "image": Assets.lib.resources.images.headphone.svg(),
    "name": "Headphone",
    "target": 345000.0,
    "collected": 55200,
  },
  {
    "image": Assets.lib.resources.images.phone.svg(),
    "name": "Trip to Japan",
    "target": 13452000.0,
    "collected": 7507200,
  },
];

List<Map> dataDummyExpenses = [
  {
    "image": Assets.lib.resources.images.flatTicket.svg(),
    "name": "Movie Tiket",
    "expense": 120000
  },
  {
    "image": Assets.lib.resources.images.headphone.svg(),
    "name": "Lunch",
    "expense": 60000
  },
  {
    "image": Assets.lib.resources.images.alienMonster.svg(),
    "name": "Games",
    "expense": 80000
  },
  {
    "image": Assets.lib.resources.images.automobile.svg(),
    "name": "Uber",
    "expense": 1540000
  },
];
