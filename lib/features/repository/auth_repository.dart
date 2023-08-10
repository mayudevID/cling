import 'dart:io';

import 'package:cling/core/common_widget.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/user_model.dart';

import 'package:cling/main.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../core/route.dart';
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

  Stream<User?> get user {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = _supabaseClient.auth.currentUser;

      if (user != null) {
        Future.microtask(() async {
          try {
            final userFromQuery = await _supabaseClient
                .from("users")
                .select<Map<String, dynamic>>()
                .eq('id', user.id)
                .single();
            UserModel? userModel = UserModel(
              id: userFromQuery['id'],
              name: userFromQuery['name'],
              email: user.email,
              photo: userFromQuery['avatar_url'],
              emailVerified: userFromQuery['verified_process'],
            );
            _cache.setString(
              userCacheKey,
              userModelToMap(userModel),
            );
            checkIfUserPassVerifOnboard(event, user, userModel);
          } on SocketException catch (e) {
            Logger.Red.log(e.message);
            final context = MainApp.navKeyGlobal.currentContext!;
            errorSnackbar(context, "No connections");
          }
        });
      } else {
        _cache.remove(userCacheKey);
      }

      return user;
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

  void checkIfUserPassVerifOnboard(
    AuthState event,
    User user,
    UserModel userModel,
  ) async {
    if (event.event == AuthChangeEvent.signedIn &&
        (user.emailConfirmedAt != null && !userModel.emailVerified)) {
      loadingAuth(MainApp.navKeyGlobal.currentContext!);
      await _supabaseClient.from("users").upsert(
        {
          "id": user.id,
          'verified_process': true,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      Navigator.pushReplacementNamed(
        MainApp.navKeyGlobal.currentContext!,
        RouteName.verifOnboard,
      );
    }
  }

  UserModel? get currentUserModel {
    final getData = _cache.getString(userCacheKey);
    if (getData != null) {
      return userModelFromMap(getData);
    }
    return null;
  }

  User? get currentUserSupabase {
    return _supabaseClient.auth.currentUser;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      saveRegisterProcess(true);
      await _supabaseClient.auth
          .signUp(
        email: email,
        password: password,
      )
          .then(
        (result) async {
          saveRegisterProcess(false);
          Logger.Green.log("User Regist: ${result.user}");
          Logger.Green.log("User Session (must be null): ${result.session}");
          //* New Row App
          await _supabaseClient.from("users").upsert(
            {
              "id": result.user!.id,
              "name": name,
            },
          );
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

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      saveLoginProcess(true);
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      saveLoginProcess(false);
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

  //* Update User Profile

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
