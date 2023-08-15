part of 'language_bloc.dart';

class LangCurrencyState extends Equatable {
  const LangCurrencyState({
    Language? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? Language.english;

  final Language selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];

  LangCurrencyState copyWith({Language? selectedLanguage}) {
    return LangCurrencyState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
