import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/auth/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Widget textFieldEmailLogin(BuildContext context) {
  return Container(
    decoration: ShapeDecoration(
      color: const Color(0xFF313131),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 16.hmea,
      horizontal: 16.wmea,
    ),
    child: TextFormField(
      onChanged: (value) {
        context.read<LoginBloc>().add(ChangeEmail(value));
      },
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration.collapsed(
        hintText: 'Email',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.5.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
