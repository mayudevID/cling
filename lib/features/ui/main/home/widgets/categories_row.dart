import 'package:flutter/material.dart';

import '../../../../../resources/gen/fonts.gen.dart';

List<Widget> rowCategories(String data) {
  return [
    Text(
      data.substring(0, data.indexOf(" ")),
      style: const TextStyle(
        fontSize: 14.5,
        fontFamily: FontFamily.cabinetGrotesk,
      ),
    ),
    const SizedBox(
      width: 10,
    ),
    Text(
      data.substring(data.indexOf(" ") + 1),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10.5,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
    ),
  ];
}
