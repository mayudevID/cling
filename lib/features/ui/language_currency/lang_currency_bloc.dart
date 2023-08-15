import 'package:bloc/bloc.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:equatable/equatable.dart';

import '../../model/currency.dart';
import '../../model/language.dart';

part 'lang_currency_event.dart';
part 'lang_currency_state.dart';

class LangCurrencyBloc extends Bloc<LangCurrencyEvent, LangCurrencyState> {
  LangCurrencyBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(const LangCurrencyState()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeCurrency>(_onChangeCurrency);
    on<GetLanguage>(_onGetLanguage);
    on<GetCurrency>(_onGetCurrency);
  }

  final SettingsRepository _settingsRepo;

  void _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LangCurrencyState> emit,
  ) async {
    await _settingsRepo.saveLangSettings(
      event.selectedLanguage.value.languageCode,
    );
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  void _onChangeCurrency(
    ChangeCurrency event,
    Emitter<LangCurrencyState> emit,
  ) async {
    await _settingsRepo.saveCurrencySettings(
      event.selectedCurrency.value.countryCode!,
    );
    emit(state.copyWith(selectedCurrency: event.selectedCurrency));
  }

  void _onGetLanguage(
    GetLanguage event,
    Emitter<LangCurrencyState> emit,
  ) async {
    final selectedLanguage = _settingsRepo.getCurrentLang();
    emit(state.copyWith(
      selectedLanguage: selectedLanguage != null
          ? Language.values
              .where((item) => item.value.languageCode == selectedLanguage)
              .first
          : Language.english,
    ));
  }

  void _onGetCurrency(
    GetCurrency event,
    Emitter<LangCurrencyState> emit,
  ) async {
    final selectedCurrency = _settingsRepo.getCurrentCurrency();
    emit(state.copyWith(
      selectedCurrency: selectedCurrency != null
          ? Currency.values
              .where((item) => item.value.countryCode == selectedCurrency)
              .first
          : Currency.idr,
    ));
  }
}
