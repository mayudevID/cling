import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/home_bloc.dart';

Widget monthlyBudget(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.wmea),
    padding: EdgeInsets.symmetric(
      horizontal: 16.wmea,
      vertical: 16.hmea,
    ),
    width: double.infinity,
    //height: 117.hmea,
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
              AppLocalizations.of(context)!.monthlyBudget,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.userModel.monthlyBudget == 0) {
                  return Text(
                    "Haven't set a monthly budget",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                    ),
                  );
                }

                return NominalMoneyFormatter(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.userModel.monthlyBudget,
                  decimalDigits: 2,
                  isWithName: true,
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16.hmea),
        Stack(
          children: [
            Container(
              width: 358.wmea,
              height: 16.hmea,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.76),
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) {
                return p.userModel.monthlyBudget != c.userModel.monthlyBudget;
              },
              builder: (context, profileState) {
                return BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) {
                    return p.amountExpenseThisMonth != c.amountExpenseThisMonth;
                  },
                  builder: (context, homeState) {
                    if (profileState.userModel.monthlyBudget < 1) {
                      return nil;
                    }

                    final length =
                        (homeState.amountExpenseThisMonth * 358.wmea) /
                            profileState.userModel.monthlyBudget;
                    return Container(
                      width: length,
                      height: 16.hmea,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFF006DE9),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.spent,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return NominalMoneyFormatter(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.amountExpenseThisMonth,
                  decimalDigits: 2,
                  isWithName: true,
                );
              },
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) {
                return p.userModel.monthlyBudget != c.userModel.monthlyBudget;
              },
              builder: (context, profileState) {
                return BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) {
                    return p.amountExpenseThisMonth != c.amountExpenseThisMonth;
                  },
                  builder: (context, homeState) {
                    if (profileState.userModel.monthlyBudget < 1) {
                      return Text(
                        ' / 0%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }

                    final amount = (homeState.amountExpenseThisMonth /
                            profileState.userModel.monthlyBudget) *
                        100.0;
                    return Text(
                      ' / ${amount.round()}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
