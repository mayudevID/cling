import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/route.dart';
import '../../../../model/goal_model.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_list_bloc.dart';

Widget goalListWidget(BuildContext context, GoalModel goalModel) {
  final percent = 100 * goalModel.collected / goalModel.target;
  final widthResult = goalModel.collected * 292.5 / goalModel.target;
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
        children: [
          Container(
            width: 52,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                goalModel.image,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      goalModel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.8,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlocBuilder<GoalListBloc, GoalListState>(
                        builder: (context, state) {
                          return Text(
                            "${percent.toStringAsFixed(2)}%",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      width: 292.5,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withValues(alpha: 0.76),
                      ),
                    ),
                    BlocBuilder<GoalListBloc, GoalListState>(
                      builder: (context, state) {
                        return Container(
                          width: widthResult,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFF006DE9),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.target}: ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                    NominalMoneyFormatter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                    NominalMoneyFormatter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
