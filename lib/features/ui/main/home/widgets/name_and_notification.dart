import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';

Widget nameAndNotification() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.wmea),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (p, c) {
              return p.userModel.name != c.userModel.name;
            },
            builder: (context, state) {
              return Text(
                'Good day, ${state.userModel.name.split(" ")[0]}!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ),
        SizedBox(width: 24.wmea),
        Assets.lib.resources.images.bell.svg()
      ],
    ),
  );
}
