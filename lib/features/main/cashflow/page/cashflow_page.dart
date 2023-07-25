import 'package:cling/core/utils.dart';
import 'package:cling/features/main/cashflow/page/cashflow_widget.dart';

import 'package:cling/features/main/home/widgets/today_expenses_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../../resources/gen/fonts.gen.dart';
import '../../home/page/home_page.dart';

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
              'Cashflow',
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
              'Income',
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
              'Today Expenses',
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
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemCount: dataDummyExpenses.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return todayExpensesWidget(
                  dataDummyExpenses[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 90.hmea,
          ),
        ],
      ),
    );
  }
}
