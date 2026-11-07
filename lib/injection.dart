import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/model/user_model.dart';

import 'features/repository/auth_repository.dart';
import 'features/repository/database_repository.dart';
import 'features/repository/settings_repository.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

Future<void> initSl() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instanceFor(app: app);
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  final firebaseCrashlytics = FirebaseCrashlytics.instance;
  getIt.registerLazySingleton<FirebaseCrashlytics>(() => firebaseCrashlytics);

  final firestore = FirebaseFirestore.instance;
  getIt.registerLazySingleton<FirebaseFirestore>(() => firestore);

  final firebaseStorage = FirebaseStorage.instance;
  getIt.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);

  final cache = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => cache);

  final authRepo = AuthRepository(
    firebaseAuth: getIt<FirebaseAuth>(),
    firestore: getIt<FirebaseFirestore>(),
    cache: getIt<SharedPreferences>(),
  );
  getIt.registerLazySingleton<AuthRepository>(() => authRepo);

  final cachedJson = cache.getString(AuthRepository.userCacheKey);
  final cachedUser = cachedJson == null ? null : userModelFromMap(cachedJson);
  final activeUid = firebaseAuth.currentUser?.uid;
  final ownerUid =
      activeUid != null && activeUid == cachedUser?.uid ? activeUid : null;
  final dbRepository = DatabaseRepository(userId: ownerUid);
  // Legacy data may only be claimed by the currently authenticated cached
  // owner; do not assign a previous account's file to a new sign-in.
  await dbRepository.migrateLegacyForAuthenticatedUser();
  await dbRepository.open();
  getIt.registerSingleton<DatabaseRepository>(dbRepository);

  final fToast = FToast();
  getIt.registerLazySingleton<FToast>(() => fToast);

  final settingsRepo = SettingsRepository(
    firebaseAuth: getIt<FirebaseAuth>(),
    firestore: getIt<FirebaseFirestore>(),
    firebaseStorage: getIt<FirebaseStorage>(),
    cache: getIt<SharedPreferences>(),
    databaseRepository: getIt<DatabaseRepository>(),
  );
  getIt.registerLazySingleton<SettingsRepository>(() => settingsRepo);
}
