import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils.dart';

class ButtonOnboard extends StatelessWidget {
  const ButtonOnboard({super.key, required this.type, required this.onTap});
  final String type;
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
            type == 'New' ? const Color(0xFFF599DA) : const Color(0xFF101010),
          ),
          overlayColor: type == 'New'
              ? MaterialStateProperty.all(
                  const Color(0xFFF06AC9),
                )
              : null,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          type == 'New' ? 'I\'m new here' : 'Already have an account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: type == 'New'
                ? const Color(0xFF101010)
                : const Color(0xFFF599DA),
            fontSize: 13.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
