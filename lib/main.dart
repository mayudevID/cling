import 'package:cling/core/bloc_observer.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'features/repository/auth_repository.dart';

import 'features/ui/auth/bloc/app_bloc.dart';
import 'features/ui/language/lang_export.dart';
import 'features/ui/language/language_bloc.dart';
import 'injection.dart';

void main() async {
  Bloc.observer = MyGlobalObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await initSl();

  runApp(const MainApp());
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
          create: (_) => LanguageBloc(
            settingsRepo: getIt<SettingsRepository>(),
          )..add(GetLanguage()),
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
          child: BlocBuilder<LanguageBloc, LanguageState>(
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

  MaterialApp materialApp(LanguageState state) {
    return MaterialApp(
      builder: FToastBuilder(),
      navigatorKey: navKeyGlobal,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      locale: state.selectedLanguage.value,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: RouteGen.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
