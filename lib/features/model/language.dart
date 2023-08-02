import 'dart:ui';

enum Language {
  english(
    Locale('en'),
    '🇺🇸 English',
  ),
  indonesia(
    Locale('id'),
    '🇮🇩 Bahasa Indonesia',
  );

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
