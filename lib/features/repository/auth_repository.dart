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
  final SupabaseClient _supabaseClient;
  final SharedPreferences _cache;

  AuthRepository({
    required SupabaseClient supabaseClient,
    required SharedPreferences cache,
  })  : _supabaseClient = supabaseClient,
        _cache = cache;

  static const userCacheKey = '__user_cache_key__';
  static const loginStatusKey = '__login_stat_key__';
  static const registerStatusKey = '__register_stat_key__';

  Stream<User?> get user {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = _supabaseClient.auth.currentUser;

      if (user == null) {
        _cache.remove(userCacheKey);
      }

      return user;
    });
  }

  // void checkIfUserPassVerifOnboard(
  //   AuthState event,
  //   User user,
  //   UserModel userModel,
  // ) async {
  //   if (event.event == AuthChangeEvent.signedIn &&
  //       (user.emailConfirmedAt != null && !userModel.emailVerified)) {
  //     loadingAuth(MainApp.navKeyGlobal.currentContext!);
  //     await _supabaseClient.from("users").upsert(
  //       {
  //         "id": user.id,
  //         'verified_process': true,
  //         'updated_at': DateTime.now().toIso8601String(),
  //       },
  //     );
  //     userModel = UserModel(id: id, emailVerified: emailVerified);
  //     Navigator.pushReplacementNamed(
  //       MainApp.navKeyGlobal.currentContext!,
  //       RouteName.verifOnboard,
  //     );
  //   }

  //   _cache.setString(
  //     userCacheKey,
  //     userModelToMap(userModel),
  //   );
  // }

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
    required String currency,
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
              "currency": currency,
            },
          );
        },
      );
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

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      saveLoginProcess(true);
      final userResultLogin = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      saveLoginProcess(false);
      final userFromQuery = await _supabaseClient
          .from("users")
          .select<Map<String, dynamic>>()
          .eq('id', userResultLogin.user!.id)
          .single();

      UserModel? userModel = UserModel(
        id: userResultLogin.user!.id,
        name: userFromQuery['name'],
        email: email,
        photo: userFromQuery['avatar_url'],
        verifiedProcess: userFromQuery['verified_process'],
      );

      final isVerifiedProcessNotPassed =
          userResultLogin.user!.emailConfirmedAt != null &&
              userFromQuery['verified_process'] == false;

      if (isVerifiedProcessNotPassed) {
        loadingAuth(MainApp.navKeyGlobal.currentContext!);
        await _supabaseClient.from("users").upsert(
          {
            "id": userResultLogin.user!.id,
            'verified_process': true,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );

        userModel = userModel.copyWith(verifiedProcess: true);
      }

      await _cache.setString(
        userCacheKey,
        userModelToMap(userModel),
      );

      if (isVerifiedProcessNotPassed) {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pushNamed(
              MainApp.navKeyGlobal.currentContext!,
              RouteName.verifOnboard,
            );
          },
        );
      }
    } on AuthException catch (e) {
      Logger.Red.log("Status: ${e.statusCode} Message: ${e.message}");
      if (e.statusCode == '400' && e.message == "Email not confirmed") {
        await Future.microtask(() async {
          await dialogEmailNotVerified(LoginPage.navKeyLogin.currentContext!);
        });
      }
      throw LogInWithEmailAndPasswordFailure.fromCode(e.message);
    } on SocketException catch (e) {
      Logger.Red.log(e.message);
      final context = MainApp.navKeyGlobal.currentContext!;
      errorSnackbar(context, "No connections");
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
