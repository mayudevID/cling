import 'package:flutter/material.dart';

enum Currency {
  idr(
    Locale("id", "ID"),
    "IDR",
    "IDR - Indonesian Rupiah",
  ),
  usd(
    Locale("en", "US"),
    "USD",
    "USD - United States Dollar",
  ),
  myr(
    Locale("ms", "MY"),
    "MYR",
    "MYR - Malaysian Ringgit",
  ),
  eur(
    Locale("en", "EU"),
    "EUR",
    "EUR - Euro",
  ),
  jpy(
    Locale("ja", "JP"),
    "JPY",
    "JPY - Japanese Yen",
  ),
  gbp(
    Locale("en", "GB"),
    "GBP",
    "GBP - British Pound Sterling",
  ),
  aud(
    Locale("en", "AU"),
    "AUD",
    "AUD - Australian Dollar",
  ),
  cad(
    Locale("en", "CA"),
    "CAD",
    "CAD - Canadian Dollar",
  ),
  chf(
    Locale("de", "CH"),
    "CHF",
    "CHF - Swiss Franc",
  ),
  cny(
    Locale("zh", "CN"),
    "CNY",
    "CNY - Chinese Yuan",
  ),
  inr(
    Locale("en", "IN"),
    "INR",
    "INR - Indian Rupee",
  ),
  brl(
    Locale("pt", "BR"),
    "BRL",
    "BRL - Brazilian Real",
  ),
  krw(
    Locale("ko", "KR"),
    "KRW",
    "KRW - South Korean Won",
  ),
  rub(
    Locale("ru", "RU"),
    "RUB",
    "RUB - Russian Ruble",
  ),
  mxn(
    Locale("es", "MX"),
    "MXN",
    "MXN - Mexican Peso",
  ),
  zar(
    Locale("en", "ZA"),
    "ZAR",
    "ZAR - South African Rand",
  );

  const Currency(this.value, this.name, this.longName);

  final Locale value;
  final String name;
  final String longName;
}
