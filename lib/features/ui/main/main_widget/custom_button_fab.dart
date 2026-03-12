import 'package:flutter/material.dart';

import '../../../../resources/gen/fonts.gen.dart';

Widget customButtonFab(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 9,
      horizontal: 19.5,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFF599DA),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 13.5,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
