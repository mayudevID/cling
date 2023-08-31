import 'package:flutter/material.dart';

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
