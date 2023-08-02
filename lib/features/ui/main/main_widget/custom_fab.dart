import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language/lang_export.dart';
import '../bloc/enum_home_page_state.dart';
import '../bloc/main_bloc.dart';
import '../home/bloc/home_bloc.dart';
import 'dart:math' as math;

Widget customFloatingActionButton(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 96.hmea,
    ),
    child: ExpandableFab(
      child: Assets.lib.resources.images.plus.svg(),
      backgroundColor: const Color(0xFFF599DA),
      foregroundColor: Colors.black,
      type: ExpandableFabType.up,
      closeButtonStyle: ExpandableFabCloseButtonStyle(
        backgroundColor: const Color(0xFFF06AC9),
        foregroundColor: Colors.black,
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Assets.lib.resources.images.plus.svg(),
        ),
      ),
      expandedFabShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      collapsedFabShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      distance: 60,
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 5,
      ),
      expandedFabSize: ExpandableFabSize.regular,
      children: [
        GestureDetector(
          onTap: () {
            context.read<HomeBloc>().add(GetIncomeSource());
            context.read<MainBloc>().add(
                  const HomePageStateChange(
                    homePageState: HomePageState.income,
                  ),
                );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 9.wmea,
              horizontal: 19.5.hmea,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF599DA),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              AppLocalizations.of(context)!.addIncome,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<HomeBloc>().add(GetExpenseCategories());
            context.read<MainBloc>().add(
                  const HomePageStateChange(
                    homePageState: HomePageState.expense,
                  ),
                );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 9.wmea,
              horizontal: 19.5.hmea,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF599DA),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              AppLocalizations.of(context)!.addExpenses,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
