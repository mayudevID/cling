import '../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class TagNameLogin extends StatelessWidget {
  const TagNameLogin({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
