import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/route.dart';
import '../../../../model/goal_model.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_list_bloc.dart';

Widget goalListWidget(BuildContext context, GoalModel goalModel) {
  final percent = 100 * goalModel.collected / goalModel.target;
  final widthResult = goalModel.collected * 292.5.wmea / goalModel.target;
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.goalsDetail,
        arguments: goalModel.id,
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52.wmea,
            height: 86.hmea,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                goalModel.image,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          SizedBox(width: 8.wmea),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      goalModel.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.8.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.wmea,
                        vertical: 2.hmea,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlocBuilder<GoalListBloc, GoalListState>(
                        builder: (context, state) {
                          return Text(
                            "${percent.toStringAsFixed(2)}%",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.wmea),
                Stack(
                  children: [
                    Container(
                      width: 292.5.wmea,
                      height: 8.hmea,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withOpacity(0.76),
                      ),
                    ),
                    BlocBuilder<GoalListBloc, GoalListState>(
                      builder: (context, state) {
                        return Container(
                          width: widthResult,
                          height: 8.hmea,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFF006DE9),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 2.wmea),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.target}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                    NominalMoneyFormatter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                      amount: goalModel.target,
                      isWithName: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.collected}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                    NominalMoneyFormatter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                      amount: goalModel.collected,
                      isWithName: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
