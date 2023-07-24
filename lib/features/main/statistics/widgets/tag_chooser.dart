import 'package:cling/features/main/statistics/bloc/statistics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

class TagChooser extends StatelessWidget {
  TagChooser({super.key});

  final tagFlow = {
    0: "All",
    1: "Income",
    2: "Expense",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        return Row(
          children: tagFlow.entries.map(
            (e) {
              return GestureDetector(
                onTap: () {
                  context.read<StatisticsBloc>().add(
                        TypeCategoriesEvent(type: e.key),
                      );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.wmea,
                    vertical: 8.hmea,
                  ),
                  margin: EdgeInsets.only(right: 12.wmea),
                  decoration: ShapeDecoration(
                    color: (e.key == state.typeCategories)
                        ? const Color(0xFFF599DA)
                        : const Color(0xFF343437),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color: (e.key == state.typeCategories)
                          ? const Color(0xFF101010)
                          : Colors.white,
                      fontSize: 13.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
