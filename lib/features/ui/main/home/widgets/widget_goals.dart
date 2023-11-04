import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Widget widgetGoals(
  BuildContext context,
  int index,
  GoalModel goalModel,
  int length,
) {
  final percent = ((goalModel.collected * 100) / goalModel.target).round();

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.goalsDetail,
        arguments: goalModel,
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        left: (index == 0) ? 24.wmea : 12.wmea,
        right: (index == length - 1) ? 20.wmea : 0,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 16.wmea,
        horizontal: 16.wmea,
      ),
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(
              8.wmea,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              goalModel.image,
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
          SizedBox(
            height: 12.hmea,
          ),
          Text(
            goalModel.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 4.hmea,
          ),
          Stack(
            children: [
              Container(
                width: 133.wmea,
                height: 8.hmea,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(0.76),
                ),
              ),
              Container(
                width: ((133.wmea * percent) / 100.0),
                height: 8.hmea,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF006DE9),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.hmea,
          ),
          Row(
            children: [
              NominalMoneyFormatter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
                amount: goalModel.target,
                decimalDigits: 2,
                isWithName: true,
              ),
              Text(
                " / $percent%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
