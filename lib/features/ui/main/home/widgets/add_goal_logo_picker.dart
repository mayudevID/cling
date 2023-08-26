import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/gen/assets.gen.dart';

Widget addGoalLogoPicker() {
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
            color: const Color(0xFF313131),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Assets.lib.resources.images.fluentEmoji16Filled.svg(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {},
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
