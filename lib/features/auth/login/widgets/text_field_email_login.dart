import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

class TextFieldEmailLogin extends StatelessWidget {
  const TextFieldEmailLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF313131),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Utils.h(16).h,
        horizontal: Utils.w(16).w,
      ),
      child: TextFormField(
        onChanged: (value) {},
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
}
