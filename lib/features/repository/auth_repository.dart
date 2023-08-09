import 'package:cling/core/logger.dart';
import 'package:cling/features/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../ui/auth/login/page/login_page.dart';
import '../ui/auth/login/widgets/dialog_email_not_verified.dart';

class AuthRepository {
  //final FirebaseAuth _firebaseAuth;
  final SupabaseClient _supabaseClient;
  final SharedPreferences _cache;

  AuthRepository({
    //required FirebaseAuth firebaseAuth,
    required SupabaseClient supabaseClient,
    required SharedPreferences cache,
  })  : //_firebaseAuth = firebaseAuth,
        _supabaseClient = supabaseClient,
        _cache = cache;

  static const userCacheKey = '__user_cache_key__';
  static const loginStatusKey = '__login_stat_key__';
  static const registerStatusKey = '__register_stat_key__';

  Stream<UserModel?> get user {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((event) async {
      final user = _supabaseClient.auth.currentUser;
      UserModel? userModel;
      if (user != null) {
        if (!registerProcess) {
          final userFromQuery = await _supabaseClient
              .from("users")
              .select<Map<String, dynamic>>()
              .eq('id', user.id);
          userModel = UserModel(
            id: userFromQuery['id'],
            name: userFromQuery['name'],
            email: user.email,
            photo: userFromQuery['avatar_url'],
            emailVerified: userFromQuery['verified_process'],
          );
          _cache.setString(userCacheKey, userModelToMap(userModel));
        }
      } else {
        _cache.remove(userCacheKey);
      }

      return userModel;
    });
    // return _firebaseAuth.authStateChanges().map((firebaseUser) {
    //   final user = firebaseUser?.toUser;
    //   if (user != null) {
    //     _cache.setString(userCacheKey, userModelToMap(user));
    //   } else {
    //     _cache.remove(userCacheKey);
    //   }
    //   return user;
    // });
  }

  UserModel? get currentUserModel {
    final getData = _cache.getString(userCacheKey);
    if (getData != null) {
      return userModelFromMap(getData);
    }
    return null;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      Logger.Green.log("USER REGIST: ${result.user}");
      Logger.Green.log("USER SESSION: ${result.session}");
      await _supabaseClient.from("users").upsert(
        {
          "id": result.user!.id,
          "name": name,
          "verified_process": false,
        },
      );
      // await _firebaseAuth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
    } on AuthException catch (e) {
      Logger.Red.log("Status: ${e.statusCode} Message: ${e.message}");
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.message);
    } on PostgrestException catch (e) {
      Logger.Red.log("Status: ${e.code} Message: ${e.message}");
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.message);
    } on Exception catch (e) {
      Logger.Red.log(e.toString());
      throw SignUpWithEmailAndPasswordFailure(e.toString());
    }
  }

  // Future<void> sendEmailVerification() async {
  //   try {
  //     await _firebaseAuth.currentUser!.sendEmailVerification();
  //   } on FirebaseException catch (e) {
  //     throw Exception(e.message);
  //   }
  // }

  Future<Session?> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return result.session;
      // await _firebaseAuth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
    } on AuthException catch (e) {
      Logger.Red.log("Status: ${e.statusCode} Message: ${e.message}");
      if (e.statusCode == '400' && e.message == "Email not confirmed") {
        await Future.microtask(() async {
          await dialogEmailNotVerified(LoginPage.navKeyLogin.currentContext!);
        });
      }
      throw LogInWithEmailAndPasswordFailure.fromCode(e.message);
    } on Exception catch (e) {
      Logger.Red.log(e.toString());
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _supabaseClient.auth.signOut(),
        //_firebaseAuth.signOut(),
        _cache.remove(userCacheKey),
        _cache.remove(registerStatusKey),
        _cache.remove(loginStatusKey),
      ]);
    } catch (e) {
      Logger.Red.log(e.toString());
      throw LogOutFailure();
    }
  }

  Future<void> saveLoginProcess(bool val) async {
    await _cache.setBool(loginStatusKey, val);
  }

  Future<void> saveRegisterProcess(bool val) async {
    await _cache.setBool(registerStatusKey, val);
  }

  bool get loginProcess {
    return _cache.getBool(loginStatusKey) ?? false;
  }

  bool get registerProcess {
    return _cache.getBool(registerStatusKey) ?? false;
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      //await _firebaseAuth.currentUser!.updateDisplayName(displayName);
    } on PostgrestException catch (e) {
      throw PostgrestException(message: e.message);
    }
  }
}

// extension on User {
//   UserModel get toUser {
//     return UserModel(
//       id: uid,
//       email: email,
//       name: displayName,
//       photo: photoURL,
//       emailVerified: emailVerified,
//     );
//   }
// }
