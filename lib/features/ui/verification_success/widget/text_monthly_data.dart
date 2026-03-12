import 'package:flutter/material.dart';

import '../../../../../resources/gen/fonts.gen.dart';

class TextMonthlyData extends StatelessWidget {
  const TextMonthlyData({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.5,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
