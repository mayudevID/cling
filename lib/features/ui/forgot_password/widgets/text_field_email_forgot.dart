import 'package:flutter/material.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';

class TextFieldEmailForgot extends StatelessWidget {
  const TextFieldEmailForgot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 54,
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration.collapsed(
            hintText: AppLocalizations.of(context)!.email,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 10.5,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
