import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

class TextFieldEmailForgot extends StatelessWidget {
  const TextFieldEmailForgot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.wmea,
      height: 54.hmea,
      decoration: ShapeDecoration(
        color: const Color(0xFF313131),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
      ),
    );
  }
}
