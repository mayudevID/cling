// ignore_for_file: constant_identifier_names

import 'dart:developer' as dev;

enum Logger {
  Black("30"),
  Red("31"),
  Green("32"),
  Yellow("33"),
  Blue("34"),
  Magenta("35"),
  Cyan("36"),
  White("37");

  const Logger(this.code);

  final String code;

  void log(dynamic text) {
    dev.log('\x1B[${code}m$text\x1B[0m');
  }
}
