import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/categories_with_amount_widget.dart';
import '../widgets/line_column_stats_all_widget.dart';
import '../widgets/pie_chart_stats_all_widget.dart';
import '../widgets/tag_info.dart';

class StatsAll extends StatelessWidget {
  const StatsAll({super.key, required ScrollController scrollController})
      : _scrollController = scrollController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TagInfo(),
        pieChartStatsAllWidget(),
        const SizedBox(
          height: 8,
        ),
        Text(
          '${AppLocalizations.of(context)!.yearlyBreakdown} / ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        lineColumnStatsAllWidget(context),
        const SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(14),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
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
            onChanged: (value) async {
              final height = MediaQuery.of(context).size.height;
              context.read<StatisticsBloc>().add(ChangeAllStatsChoose(value!));
              await Future.delayed(const Duration(milliseconds: 200));
              _scrollController.animateTo(
                (_scrollController.position.maxScrollExtent >= height * 2)
                    ? height
                    : _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              );
            },
            items: AllStatsChoose.values
                .map(
                  (e) => DropdownItem<AllStatsChoose>(
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
              width: 387,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF313131),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 8,
        // ),
        // ...chooseDateRange(context),
        const SizedBox(
          height: 16,
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
                    return categoriesWithAmount(
                      context: context,
                      data: state.mostIncomeList[index],
                      type: ["income", "Source", "TotalIncome"],
                      title: AppLocalizations.of(context)!.mostIncome,
                    );
                  }
                : (_, index) {
                    return categoriesWithAmount(
                      context: context,
                      data: state.mostExpenseList[index],
                      type: ["expense", "Categories", "TotalExpense"],
                      title: AppLocalizations.of(context)!.mostExpense,
                    );
                  };

            final listWidget = MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.separated(
                itemCount: itemCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: itemBuilder,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 4);
                },
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
        const SizedBox(height: 128),
      ],
    );
  }
}
