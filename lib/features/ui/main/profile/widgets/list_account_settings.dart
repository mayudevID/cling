import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/profile_bloc.dart';

List<Widget> listAccountSettings(BuildContext context) {
  return [
    ///* Monthly Budget
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8.wmea,
        ),
        Assets.lib.resources.images.money.svg(),
        SizedBox(
          width: 10.wmea,
        ),
        Text(
          AppLocalizations.of(context)!.monthlyBudget,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (p, c) {
            return p.userModel.monthlyBudget != c.userModel.monthlyBudget;
          },
          builder: (context, state) {
            return NominalMoneyFormatter(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
              amount: state.userModel.monthlyBudget,
              decimalDigits: 2,
              isWithName: true,
            );
          },
        ),
        SizedBox(
          width: 10.wmea,
        ),
        Assets.lib.resources.images.chevronRight16.svg(),
        SizedBox(
          width: 8.wmea,
        ),
      ],
    ),
    SizedBox(
      height: 32.hmea,
    ),

    ///* Monthly Income
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8.wmea,
        ),
        Assets.lib.resources.images.moneyHand.svg(),
        SizedBox(
          width: 10.wmea,
        ),
        Text(
          'Monthly Income',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (p, c) {
            return p.userModel.monthlyIncome != c.userModel.monthlyIncome;
          },
          builder: (context, state) {
            return NominalMoneyFormatter(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
              amount: state.userModel.monthlyIncome,
              decimalDigits: 2,
              isWithName: true,
            );
          },
        ),
        SizedBox(
          width: 10.wmea,
        ),
        Assets.lib.resources.images.chevronRight16.svg(),
        SizedBox(
          width: 8.wmea,
        ),
      ],
    ),
    SizedBox(
      height: 32.hmea,
    ),

    ///* Change Language
    GestureDetector(
      onTap: () {
        showBottomsheetChooseLang(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 8.wmea,
          ),
          Assets.lib.resources.images.globe.svg(),
          SizedBox(
            width: 10.wmea,
          ),
          Text(
            'Change Language',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Assets.lib.resources.images.chevronRight16.svg(),
          SizedBox(
            width: 8.wmea,
          ),
        ],
      ),
    ),
  ];
}
