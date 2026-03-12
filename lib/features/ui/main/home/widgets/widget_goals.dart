import 'package:flutter/material.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/goal_model.dart';

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
        arguments: goalModel.id!,
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        left: (index == 0) ? 24 : 12,
        right: (index == length - 1) ? 24 : 0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(goalModel.image, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 12),
          Text(
            goalModel.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                width: 133,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withValues(alpha: 0.76),
                ),
              ),
              Container(
                width: ((133 * percent) / 100.0),
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF006DE9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              NominalMoneyFormatter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
                amount: goalModel.target,
                isWithName: true,
              ),
              Text(
                " / $percent%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
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
