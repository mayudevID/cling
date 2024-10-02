import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../app_bloc/app_bloc.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/home_bloc.dart';

Widget nameAndNotification(BuildContext context) {
  final dateFormat = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();

  return Padding(
    padding: EdgeInsets.only(left: 24.w, right: 17.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AppBloc, AppState>(
                buildWhen: (p, c) {
                  return p.user?.displayName != c.user?.displayName;
                },
                builder: (context, state) {
                  return Text(
                    '${AppLocalizations.of(context)!.goodDay}, ${state.user?.displayName?.split(" ")[0]}!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              Text(
                DateFormat.yMMMMEEEEd(dateFormat).format(DateTime.now()),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.notification);
          },
          child: SizedBox(
            height: 30.h,
            width: 28.w,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Assets.lib.resources.images.bell.svg(
                    width: 21.91.w,
                    height: 24.h,
                  ),
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) {
                    return previous.totalNotif != current.totalNotif;
                  },
                  builder: (context, state) {
                    if (state.totalNotif == 0) return const SizedBox();

                    return Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            state.totalNotif.toString(),
                            style: TextStyle(
                              fontFamily: FontFamily.cabinetGrotesk,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
