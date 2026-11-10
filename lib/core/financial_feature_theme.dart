import 'package:flutter/material.dart';

import '../resources/gen/fonts.gen.dart';

/// Presentation theme for the financial feature pages added after the core UI.
/// It keeps Material controls aligned with Cling's existing dark, pink, rounded
/// visual language without changing the theme of the rest of the application.
class FinancialFeatureTheme extends StatelessWidget {
  const FinancialFeatureTheme({super.key, required this.child});

  final Widget child;

  static const background = Color(0xFF101010);
  static const surface = Color(0xFF292929);
  static const field = Color(0xFF313131);
  static const accent = Color(0xFFF599DA);
  static const muted = Color(0xFFBDBDBD);

  static ThemeData of(BuildContext context) {
    final base = Theme.of(context);
    final colors = base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: accent,
      secondary: accent,
      surface: background,
      error: const Color(0xFFFF8A8A),
    );
    const radius = BorderRadius.all(Radius.circular(12));
    const buttonTextStyle = TextStyle(
      fontFamily: FontFamily.cabinetGrotesk,
      fontWeight: FontWeight.w700,
    );
    return base.copyWith(
      colorScheme: colors,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      textTheme: base.textTheme.apply(
        fontFamily: FontFamily.cabinetGrotesk,
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: field,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.white12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Color(0xFFFF8A8A)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Color(0xFFFF8A8A), width: 1.5),
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: surface,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: const Color(0xFF252525),
        shape: const RoundedRectangleBorder(borderRadius: radius),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: FontFamily.cabinetGrotesk,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: background,
          backgroundColor: accent,
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: accent),
          shape: const RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonTextStyle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(48, 48),
          textStyle: buttonTextStyle,
        ),
      ),
      dividerTheme: base.dividerTheme.copyWith(color: Colors.white12),
    );
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: of(context),
        child: child,
      );
}
