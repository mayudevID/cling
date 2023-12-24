import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../bloc/goal_detail_bloc.dart';
import 'dialog_pick_edit_goal_logo.dart';

Widget logoGoalWidgetOnEditGoal(BuildContext context) {
  return SizedBox(
    width: 140.wmea,
    height: 140.wmea,
    child: Stack(
      children: [
        Container(
          width: 128.wmea,
          height: 128.wmea,
          padding: EdgeInsets.symmetric(
            horizontal: 16.wmea,
            vertical: 16.hmea,
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
              width: 36.wmea,
              height: 36.wmea,
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
