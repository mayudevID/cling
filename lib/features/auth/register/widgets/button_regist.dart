import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

class ButtonRegist extends StatelessWidget {
  const ButtonRegist({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.w(390).w,
      height: Utils.h(57).h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFFF599DA),
          ),
          overlayColor: MaterialStateProperty.all(
            const Color(0xFFF06AC9),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          "Create New Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 13.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
