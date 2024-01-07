import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/list_account_settings.dart';
import '../widgets/name_and_email.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.wmea),
      child: Column(
        children: [
          SizedBox(height: 31.hmea),
          nameAndEmail(context),
          SizedBox(height: 31.hmea),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.currency,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return Text(
                    state.userModel.currency.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 31.hmea),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.account,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 24.hmea),
          ...listAccountSettings(context),
          SizedBox(height: 31.hmea),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.general,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 24.hmea),
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8.wmea),
                Assets.lib.resources.images.fluentStar24Filled.svg(),
                SizedBox(width: 10.wmea),
                Text(
                  AppLocalizations.of(context)!.rateCling,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Assets.lib.resources.images.chevronRight16.svg(),
                SizedBox(width: 8.wmea),
              ],
            ),
          ),
          SizedBox(height: 31.hmea),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.settings,
                arguments: context,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.settings,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Assets.lib.resources.images.chevronRight16.svg(),
                SizedBox(width: 8.wmea),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
