import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../edit_monthly/page/edit_budget_or_income.dart';
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
          SizedBox(width: 8.w),
          Assets.lib.resources.images.money.svg(),
          SizedBox(width: 10.w),
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
                isWithName: true,
              );
            },
          ),
          SizedBox(width: 10.w),
          Assets.lib.resources.images.chevronRight16.svg(),
          SizedBox(width: 8.w),
        ],
      ),
    ),
    SizedBox(height: 32.h),

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
          SizedBox(width: 8.w),
          Assets.lib.resources.images.moneyHand.svg(),
          SizedBox(width: 10.w),
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
                isWithName: true,
              );
            },
          ),
          SizedBox(width: 10.w),
          Assets.lib.resources.images.chevronRight16.svg(),
          SizedBox(width: 8.w),
        ],
      ),
    ),
  ];
}
