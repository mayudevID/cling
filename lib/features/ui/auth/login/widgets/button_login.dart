import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390.wmea,
      height: 57.hmea,
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
          "Login",
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
