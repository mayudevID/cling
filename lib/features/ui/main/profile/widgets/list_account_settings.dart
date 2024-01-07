import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/edit_monthly/page/edit_budget_or_income.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/profile_bloc.dart';

List<Widget> listAccountSettings(BuildContext context) {
  return [
    ///* Monthly Budget
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.editMonBudgetOrIncome,
          arguments: EditMonthlyMode.budget,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8.wmea),
          Assets.lib.resources.images.money.svg(),
          SizedBox(width: 10.wmea),
          Text(
            AppLocalizations.of(context)!.monthlyBudget,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
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
                  fontSize: 9.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
                amount: state.userModel.monthlyBudget,
                decimalDigits: 2,
                isWithName: true,
              );
            },
          ),
          SizedBox(width: 10.wmea),
          Assets.lib.resources.images.chevronRight16.svg(),
          SizedBox(width: 8.wmea),
        ],
      ),
    ),
    SizedBox(height: 32.hmea),

    ///* Monthly Income
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.editMonBudgetOrIncome,
          arguments: EditMonthlyMode.income,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8.wmea),
          Assets.lib.resources.images.moneyHand.svg(),
          SizedBox(width: 10.wmea),
          Text(
            AppLocalizations.of(context)!.monthlyIncome,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
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
                  fontSize: 9.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
                amount: state.userModel.monthlyIncome,
                decimalDigits: 2,
                isWithName: true,
              );
            },
          ),
          SizedBox(width: 10.wmea),
          Assets.lib.resources.images.chevronRight16.svg(),
          SizedBox(width: 8.wmea),
        ],
      ),
    ),
  ];
}
