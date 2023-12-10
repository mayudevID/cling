import 'package:cling/core/bloc_observer.dart';
import 'package:cling/core/notification.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:sizer/sizer.dart';
import 'core/route.dart';
import 'features/repository/auth_repository.dart';

import 'features/ui/app_bloc/app_bloc.dart';
import 'features/ui/language_currency/lang_export.dart';
import 'features/ui/language_currency/lang_currency_bloc.dart';
import 'injection.dart';

void main() async {
  Bloc.observer = MyGlobalObserver();
  WidgetsFlutterBinding.ensureInitialized();

  NotificationClass.init();
  await initSl();

  if (kDebugMode) {
    await getIt<FirebaseCrashlytics>().setCrashlyticsCollectionEnabled(false);
  } else {
    await getIt<FirebaseCrashlytics>().setCrashlyticsCollectionEnabled(true);
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await getIt<FirebaseCrashlytics>().recordFlutterError(errorDetails);
      originalOnError!(errorDetails);
    };
  }

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static var navKeyGlobal = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(
            authRepo: getIt<AuthRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => LangCurrencyBloc(
            settingsRepo: getIt<SettingsRepository>(),
          )
            ..add(GetLanguage())
            ..add(GetCurrency()),
        ),
      ],
      child: initApp(),
    );
  }

  Widget initApp() {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
            buildWhen: (prev, curr) {
              return prev.selectedLanguage != curr.selectedLanguage;
            },
            builder: (context, state) {
              return materialApp(state);
            },
          ),
        );
      },
    );
  }

  MaterialApp materialApp(LangCurrencyState state) {
    return MaterialApp(
      builder: FToastBuilder(),
      navigatorKey: navKeyGlobal,
      theme: ThemeData(primaryColor: Colors.white),
      locale: state.selectedLanguage.value,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      onGenerateRoute: RouteGen.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
