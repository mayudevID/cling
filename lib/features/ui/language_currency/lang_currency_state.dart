part of 'lang_currency_bloc.dart';

class LangCurrencyState extends Equatable {
  const LangCurrencyState({
    Language? selectedLanguage,
    Currency? selectedCurrency,
  })  : selectedLanguage = selectedLanguage ?? Language.english,
        selectedCurrency = selectedCurrency ?? Currency.idr;

  final Language selectedLanguage;
  final Currency selectedCurrency;

  @override
  List<Object> get props => [selectedLanguage, selectedCurrency];

  LangCurrencyState copyWith({
    Language? selectedLanguage,
    Currency? selectedCurrency,
  }) {
    return LangCurrencyState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
    );
  }
}
