import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_detail_bloc.dart';

Widget targetGoalWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    width: double.infinity,
    //height: 117,
    decoration: ShapeDecoration(
      color: const Color(0x3D787880),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.target,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            BlocBuilder<GoalDetailBloc, GoalDetailState>(
              buildWhen: (p, c) {
                return p.goalModel.target != c.goalModel.target;
              },
              builder: (context, state) {
                return NominalMoneyFormatter(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.goalModel.target,
                  isWithName: true,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              width: 358,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withValues(alpha: 0.76),
              ),
            ),
            BlocBuilder<GoalDetailBloc, GoalDetailState>(
              buildWhen: (p, c) {
                return p.goalModel.collected != c.goalModel.collected ||
                    p.goalModel.target != c.goalModel.target;
              },
              builder: (context, state) {
                if (state.goalModel.collected < 1) {
                  return const SizedBox();
                }

                final length =
                    (state.goalModel.collected * 358) / state.goalModel.target;
                return Container(
                  width: length,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFF006DE9),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            BlocBuilder<GoalDetailBloc, GoalDetailState>(
              builder: (context, state) {
                return NominalMoneyFormatter(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.goalModel.collected,
                  isWithName: true,
                );
              },
            ),
            BlocBuilder<GoalDetailBloc, GoalDetailState>(
              buildWhen: (p, c) {
                return p.goalModel.target != c.goalModel.target ||
                    p.goalModel.collected != c.goalModel.collected;
              },
              builder: (context, state) {
                if (state.goalModel.collected < 1) {
                  return const Text(
                    ' / 0%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }

                final amount =
                    (state.goalModel.collected / state.goalModel.target) *
                        100.0;
                return Text(
                  ' / ${amount.round()}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
