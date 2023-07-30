import 'package:cling/core/bloc_observer.dart';
import 'package:cling/core/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'features/repository/auth_repository.dart';
import 'features/repository/database_repository.dart';
import 'features/ui/auth/bloc/app_bloc.dart';
import 'features/ui/main/bloc/main_bloc.dart';
import 'features/ui/main/home/bloc/home_bloc.dart';
import 'features/ui/main/statistics/bloc/statistics_bloc.dart';
import 'injection.dart';

void main() async {
  Bloc.observer = MyGlobalObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await initSl();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
          lazy: true,
          create: (_) => MainBloc(),
        ),
        BlocProvider(
          lazy: true,
          create: (_) => HomeBloc(
            dbRepo: getIt<DatabaseRepository>(),
          ),
        ),
        BlocProvider(
          lazy: true,
          create: (_) => StatisticsBloc(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            builder: FToastBuilder(),
            navigatorKey: navigatorKeyOpen,
            theme: ThemeData(
              primaryColor: Colors.white,
            ),
            onGenerateRoute: RouteGen.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
