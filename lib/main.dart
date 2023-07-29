import 'package:cling/core/bloc_observer.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/bloc/main_bloc.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'features/ui/auth/bloc/app_bloc.dart';
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
            theme: ThemeData(primaryColor: Colors.white),
            onGenerateRoute: RouteGen.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
