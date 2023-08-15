part of 'language_bloc.dart';

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

class GetLanguage extends LangCurrencyEvent {}
