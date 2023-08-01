import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language/lang_export.dart';
import '../../home/bloc/home_bloc.dart';

import '../../home/widgets/today_expenses_widget.dart';
import 'cashflow_widget.dart';

class CashflowPage extends StatelessWidget {
  CashflowPage({super.key});

  final dataDummy = {
    "Freelance": 300000,
    "Part time": 1800000,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.hmea,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.wmea),
            child: Text(
              AppLocalizations.of(context)!.cashflow,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.wmea),
            child: Text(
              AppLocalizations.of(context)!.income,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 16.hmea,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < dataDummy.length; i++)
                  cashflowWidget(
                    dataDummy.entries.toList()[i],
                    i,
                  )
              ],
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.wmea),
            child: Text(
              AppLocalizations.of(context)!.todayExpenses,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 16.hmea,
          ),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) {
              return prev.listTodayExpenses != next.listTodayExpenses;
            },
            builder: (context, state) {
              if (state.listTodayExpenses.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.wmea),
                  child: Text(
                    "${AppLocalizations.of(context)!.noExpenseToday} :D",
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
