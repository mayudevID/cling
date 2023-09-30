import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../app_bloc/app_bloc.dart';

Widget nameAndEmail(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.wmea),
    decoration: ShapeDecoration(
      color: const Color(0x3D787880),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Row(
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
                    state.user!.displayName!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Row(
                children: [
                  BlocBuilder<AppBloc, AppState>(
                    buildWhen: (p, c) {
                      return p.user?.email != c.user?.email;
                    },
                    builder: (context, state) {
                      return Text(
                        state.user!.email!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 8.wmea,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 3.hmea,
                      horizontal: 6.wmea,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) {
                        return previous.user?.emailVerified !=
                            current.user?.emailVerified;
                      },
                      builder: (context, state) {
                        return Text(
                          (state.user!.emailVerified)
                              ? "Verified"
                              : "Not Verified",
                          style: TextStyle(
                            color: (state.user!.emailVerified)
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.5.sp,
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.editProfile);
          },
          child: Assets.lib.resources.images.editBig.svg(),
        ),
      ],
    ),
  );
}
