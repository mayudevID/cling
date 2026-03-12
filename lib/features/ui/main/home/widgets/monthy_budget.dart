import '../../../../../core/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../bloc/home_bloc.dart';
import 'warning_amount_icon.dart';

Widget monthlyBudget(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    width: double.infinity,
    //height: 117,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) {
                return p.userModel.monthlyBudget != c.userModel.monthlyBudget;
              },
              builder: (context, state) {
                if (state.userModel.monthlyBudget == 0) {
                  return const Text(
                    ("---"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: FontFamily.cabinetGrotesk,
                    ),
                  );
                }

                return NominalMoneyFormatter(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.userModel.monthlyBudget,
                  isWithName: true,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              width: 358,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withValues(alpha: 0.76),
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
                      return const SizedBox();
                    }

                    final length = (homeState.amountExpenseThisMonth * 358) /
                        profileState.userModel.monthlyBudget;
                    return Container(
                      width: length,
                      height: 16,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return NominalMoneyFormatter(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: state.amountExpenseThisMonth,
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
                      return const Text(
                        ' / 0%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 10),
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
                    final amount = (homeState.amountExpenseThisMonth /
                            profileState.userModel.monthlyBudget) *
                        100.0;

                    if (amount <= 100) return const SizedBox();

                    return warningAmountIcon(
                      content:
                          AppLocalizations.of(context)!.warningMonthlyBudget,
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
