import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Currency {
  idr(
    Locale("id", "ID"),
    "IDR",
  ),
  usd(
    Locale("en", "US"),
    "USD",
  );

  const Currency(this.value, this.name);

  final Locale value;
  final String name;
}

class NF {
  String currency({
    required num amount,
    required Currency currency,
    int? decimalDigits,
    bool? isWithName,
  }) {
    return NumberFormat.currency(
      locale: currency.value.toLanguageTag(),
      decimalDigits: decimalDigits,
      name: (isWithName ?? true) ? "${currency.name} " : "",
    ).format(amount);
  }
}
