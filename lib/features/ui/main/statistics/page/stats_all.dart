import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/widgets/line_column_stats_all_widget.dart';
import 'package:cling/features/ui/main/statistics/widgets/pie_chart_stats_all_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/most_expense.dart';
import '../widgets/most_income.dart';
import '../widgets/tag_info.dart';

class StatsAll extends StatelessWidget {
  const StatsAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TagInfo(),
        pieChartStatsAllWidget(),
        SizedBox(
          height: 8.hmea,
        ),
        Text(
          '${AppLocalizations.of(context)!.yearlyBreakdown} / ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 8.hmea,
        ),
        lineColumnStatsAllWidget(context),
        SizedBox(
          height: 8.hmea,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(14.wmea),
              decoration: BoxDecoration(
                color: const Color(0x3D787880),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<StatisticsBloc, StatisticsState>(
                    buildWhen: (p, c) {
                      return p.allStatsChoose != c.allStatsChoose;
                    },
                    builder: (context, state) {
                      return Text(
                        (state.allStatsChoose.name == "income")
                            ? AppLocalizations.of(context)!.mostIncome
                            : AppLocalizations.of(context)!.mostExpense,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                  Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
                ],
              ),
            ),
            onChanged: (value) {
              context.read<StatisticsBloc>().add(ChangeAllStatsChoose(value!));
            },
            items: AllStatsChoose.values
                .map(
                  (e) => DropdownMenuItem<AllStatsChoose>(
                    value: e,
                    child: Text(
                      (e == AllStatsChoose.income)
                          ? AppLocalizations.of(context)!.mostIncome
                          : AppLocalizations.of(context)!.mostExpense,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                  ),
                )
                .toList(),
            dropdownStyleData: DropdownStyleData(
              width: 387.wmea,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF313131),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16.hmea,
        ),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return (p.mostExpenseList != c.mostExpenseList) ||
                (p.mostIncomeList != c.mostIncomeList);
          },
          builder: (context, state) {
            const widgetNoData = Center(
              child: Text(
                "No data :(",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  color: Colors.white,
                ),
              ),
            );

            final boolean = (state.allStatsChoose == AllStatsChoose.income);

            final itemCount = boolean
                ? state.mostIncomeList.length
                : state.mostExpenseList.length;
            final itemBuilder = boolean
                ? (_, index) {
                    return mostIncome(state.mostIncomeList[index]);
                  }
                : (_, index) {
                    return mostExpense(state.mostExpenseList[index]);
                  };

            final listWidget = MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: itemCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: itemBuilder,
              ),
            );

            return boolean
                ? state.mostIncomeList.isEmpty
                    ? widgetNoData
                    : listWidget
                : state.mostExpenseList.isEmpty
                    ? widgetNoData
                    : listWidget;
          },
        ),
        SizedBox(height: 128.hmea),
      ],
    );
  }
}
