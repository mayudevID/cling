import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        children: [
          const SizedBox(width: 8),
          Assets.lib.resources.images.money.svg(),
          const SizedBox(width: 10),
          Text(
            AppLocalizations.of(context)!.monthlyBudget,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
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
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
                amount: state.userModel.monthlyBudget,
                isWithName: true,
              );
            },
          ),
          const SizedBox(width: 10),
          Assets.lib.resources.images.chevronRight16.svg(),
          const SizedBox(width: 8),
        ],
      ),
    ),
    const SizedBox(height: 32),

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
        children: [
          const SizedBox(width: 8),
          Assets.lib.resources.images.moneyHand.svg(),
          const SizedBox(width: 10),
          Text(
            AppLocalizations.of(context)!.monthlyIncome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
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
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
                amount: state.userModel.monthlyIncome,
                isWithName: true,
              );
            },
          ),
          const SizedBox(width: 10),
          Assets.lib.resources.images.chevronRight16.svg(),
          const SizedBox(width: 8),
        ],
      ),
    ),
  ];
}
