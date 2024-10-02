import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../bloc/goal_detail_bloc.dart';
import 'dialog_pick_edit_goal_logo.dart';

Widget logoGoalWidgetOnEditGoal(BuildContext context) {
  return SizedBox(
    width: 140.w,
    height: 140.w,
    child: Stack(
      children: [
        Container(
          width: 128.w,
          height: 128.w,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          decoration: ShapeDecoration(
            color: Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: BlocBuilder<GoalDetailBloc, GoalDetailState>(
              buildWhen: (previous, current) {
                return previous.tempLogoGoal != current.tempLogoGoal;
              },
              builder: (context, state) {
                if (state.tempLogoGoal.trim().isNotEmpty ||
                    state.tempLogoGoal != "") {
                  return Text(
                    state.tempLogoGoal,
                    style: TextStyle(
                      fontSize: 43.sp,
                    ),
                  );
                }

                return Assets.lib.resources.images.fluentEmoji16Filled.svg();
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              dialogPickEditGoalLogo(context);
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF454545),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Assets.lib.resources.images.editPencil.svg(),
            ),
          ),
        ),
      ],
    ),
  );
}
