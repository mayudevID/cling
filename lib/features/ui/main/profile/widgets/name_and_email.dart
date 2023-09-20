import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../bloc/profile_bloc.dart';

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
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (p, c) {
                  return p.userModel.name != c.userModel.name;
                },
                builder: (context, state) {
                  return Text(
                    state.userModel.name,
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
                  BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (p, c) {
                      return p.userModel.email != c.userModel.email;
                    },
                    builder: (context, state) {
                      return Text(
                        state.userModel.email,
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
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (previous, current) {
                        return previous.isVerified != current.isVerified;
                      },
                      builder: (context, state) {
                        return Text(
                          (state.isVerified) ? "Verified" : "Not Verified",
                          style: TextStyle(
                            color: (state.isVerified)
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
