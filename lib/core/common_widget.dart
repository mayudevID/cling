import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../resources/gen/fonts.gen.dart';

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
