import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/detail_category_model.dart';
import '../bloc/statistics_bloc.dart';

Widget categoriesWithAmount({
  required BuildContext context,
  required Map<String, Object?> data,
  required List<String> type,
  required String title,
}) {
  final categoryStr = data[type[1]].toString();
  final categoryIcon = categoryStr.substring(0, categoryStr.indexOf(" "));
  final categoryClass = categoryStr.substring(categoryStr.indexOf(" ") + 1);
  final totalAmount = double.parse(data[type[2]].toString());

  return GestureDetector(
    onTap: () {
      final statsBloc = context.read<StatisticsBloc>().state;
      final detailCategoryModel = DetailCategoryModel(
        type: type[0],
        categoryStr: categoryStr,
        title: title,
        rangeDate: statsBloc.rangeDate,
        dateRangePickerView: statsBloc.dateRangePickerView,
        startDate: statsBloc.startDate,
        endDate: statsBloc.endDate,
      );
      Navigator.pushNamed(
        context,
        RouteName.statsDetailPerCategories,
        arguments: detailCategoryModel,
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                " $categoryIcon",
                style: const TextStyle(fontSize: 9),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            categoryClass,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          NominalMoneyFormatter(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
            amount: totalAmount,
            isWithName: true,
          ),
        ],
      ),
    ),
  );
}
