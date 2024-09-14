import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nil/nil.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../language_currency/lang_export.dart';
import 'dart:math' as math;

import 'custom_button_fab.dart';
import 'enum_flowtype.dart';

Widget customFloatingActionButton(BuildContext context) {
  final buttonData = [
    {
      "route": RouteName.addInEx,
      "args": FlowType.income,
      "name": AppLocalizations.of(context)!.addIncome,
    },
    {
      "route": RouteName.addInEx,
      "args": FlowType.expense,
      "name": AppLocalizations.of(context)!.addExpenses,
    },
    {
      "route": RouteName.addGoal,
      "args": null,
      "name": AppLocalizations.of(context)!.addGoals,
    }
  ];

  return Container(
    margin: EdgeInsets.only(
      bottom: 96.hmea,
    ),
    child: ExpandableFab(
      type: ExpandableFabType.up,
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 0.2,
        builder: (
          BuildContext context,
          void Function()? onPressed,
          Animation<double> progress,
        ) {
          return Container(
            padding: const EdgeInsets.all(18),
            width: 64.wmea,
            height: 64.wmea,
            decoration: BoxDecoration(
              color: const Color(0xFFF599DA),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Assets.lib.resources.images.plus.svg(),
            ),
          );
        },
      ),
      openButtonBuilder: FloatingActionButtonBuilder(
        size: 0.2,
        builder: (
          BuildContext context,
          void Function()? onPressed,
          Animation<double> progress,
        ) {
          return Container(
            padding: const EdgeInsets.all(18),
            width: 64.wmea,
            height: 64.wmea,
            decoration: BoxDecoration(
              color: const Color(0xFFF599DA),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Assets.lib.resources.images.plus.svg(),
          );
        },
      ),
      distance: 50.hmea,
      overlayStyle: const ExpandableFabOverlayStyle(blur: 3),
      children: [
        const Nil(),
        for (Map data in buttonData)
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(
                context,
                data["route"],
                arguments: data["args"],
              );
            },
            child: customButtonFab(data["name"]),
          ),
      ],
    ),
  );
}
