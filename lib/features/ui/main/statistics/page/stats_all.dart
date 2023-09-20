import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/widgets/line_column_widget.dart';
import 'package:cling/features/ui/main/statistics/widgets/pie_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/page/home_page.dart';
import '../widgets/most_expense.dart';
import '../widgets/tag_info.dart';

class StatsAll extends StatelessWidget {
  const StatsAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "${monthIntToString(context: context, time: DateTime.now())} ${DateTime.now().year}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 8.hmea,
        ),
        const TagInfo(),
        pieChartWidget(),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          AppLocalizations.of(context)!.yearlyBreakdown,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        lineColumnWidget(context),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          AppLocalizations.of(context)!.mostExpense,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 16.hmea,
        ),
        // MediaQuery.removePadding(
        //   context: context,
        //   removeTop: true,
        //   child: ListView.builder(
        //     itemCount: dataDummyExpenses.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       return mostExpense(
        //         dataDummyExpenses[index],
        //       );
        //     },
        //   ),
        // ),
        SizedBox(
          height: 90.hmea,
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
