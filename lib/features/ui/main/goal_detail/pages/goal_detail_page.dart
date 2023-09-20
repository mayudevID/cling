import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../bloc/goal_detail_bloc.dart';
import '../widgets/edit_goal_logo_picker.dart';

class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({super.key, required this.goalModel});
  final GoalModel goalModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalDetailBloc()..add(InitGoal(goalModel)),
      child: const GoalDetailPageContent(),
    );
  }
}

class GoalDetailPageContent extends StatelessWidget {
  const GoalDetailPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.hmea),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Assets.lib.resources.images.fluentChevronLeft24Filled
                      .svg(),
                ),
                SizedBox(
                  width: 8.wmea,
                ),
                BlocBuilder<GoalDetailBloc, GoalDetailState>(
                  builder: (context, state) {
                    return Text(
                      state.goalModel.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 32.hmea,
          ),
          editGoalLogoPicker(context),
        ],
      ),
    );
  }
}
