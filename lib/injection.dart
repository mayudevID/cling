import 'package:cling/features/repository/database_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/repository/auth_repository.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;
GlobalKey<NavigatorState> navigatorKeyOpen = GlobalKey<NavigatorState>();

Future<void> initSl() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instanceFor(app: app);
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  final cache = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => cache);

  final authRepo = AuthRepository(
    firebaseAuth: getIt<FirebaseAuth>(),
    cache: getIt<SharedPreferences>(),
  );
  getIt.registerLazySingleton<AuthRepository>(() => authRepo);

  final dbRepository = DatabaseRepository();
  getIt.registerSingleton<DatabaseRepository>(dbRepository);

  final fToast = FToast();
  getIt.registerLazySingleton<FToast>(() => fToast);
}
