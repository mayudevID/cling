import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../injection.dart';
import '../resources/gen/fonts.gen.dart';

class PinkButton extends StatelessWidget {
  const PinkButton({super.key, required this.onTap, required this.name});
  final Function() onTap;
  final String name;

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
          name,
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

class BlackButton extends StatelessWidget {
  const BlackButton({super.key, required this.name, required this.onTap});
  final String name;
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
            const Color(0xFF101010),
          ),
          overlayColor: null,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFF599DA),
            fontSize: 13.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

void loadingAuth(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(32),
          child: Lottie.asset(
            "lib/resources/anim/loading_carga.json",
            animate: true,
            repeat: true,
            width: 48.wmea,
            height: 48.wmea,
            frameRate: FrameRate.max,
          ),
        ),
      ),
    ),
  );
}

void errorSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade400,
        content: Text(
          msg,
          style: TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w600,
            fontSize: 11.5.sp,
          ),
        ),
      ),
    );
}

void errorToast(String msg) {
  getIt<FToast>()
    ..removeCustomToast()
    ..showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 3500),
      child: Container(
        margin: EdgeInsets.only(bottom: 111.hmea),
        padding: EdgeInsets.all(10.wmea),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xff313131),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.lib.resources.images.dismiss.svg(),
            SizedBox(
              width: 8.wmea,
            ),
            Text(
              msg,
              style: TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontSize: 10.5.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
}
