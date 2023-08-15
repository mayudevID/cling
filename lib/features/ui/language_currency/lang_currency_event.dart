part of 'lang_currency_bloc.dart';

abstract class LangCurrencyEvent extends Equatable {
  const LangCurrencyEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LangCurrencyEvent {
  const ChangeLanguage({required this.selectedLanguage});
  final Language selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];
}

class ChangeCurrency extends LangCurrencyEvent {
  const ChangeCurrency({required this.selectedCurrency});
  final Currency selectedCurrency;

  @override
  List<Object> get props => [selectedCurrency];
}

class GetLanguage extends LangCurrencyEvent {}

class GetCurrency extends LangCurrencyEvent {}
