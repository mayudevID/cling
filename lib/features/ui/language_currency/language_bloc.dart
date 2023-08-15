import 'package:bloc/bloc.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:equatable/equatable.dart';

import '../../model/language.dart';

part 'language_event.dart';
part 'language_state.dart';

class LangCurrencyBloc extends Bloc<LangCurrencyEvent, LangCurrencyState> {
  LangCurrencyBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(const LangCurrencyState()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<GetLanguage>(_onGetLanguage);
  }

  final SettingsRepository _settingsRepo;

  void _onChangeLanguage(
      ChangeLanguage event, Emitter<LangCurrencyState> emit) async {
    await _settingsRepo.saveLangSettings(
      event.selectedLanguage.value.languageCode,
    );
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  void _onGetLanguage(
      GetLanguage event, Emitter<LangCurrencyState> emit) async {
    final selectedLanguage = _settingsRepo.getCurrentLang();
    emit(state.copyWith(
      selectedLanguage: selectedLanguage != null
          ? Language.values
              .where((item) => item.value.languageCode == selectedLanguage)
              .first
          : Language.english,
    ));
  }
}
