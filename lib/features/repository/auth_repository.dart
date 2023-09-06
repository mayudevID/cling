import 'dart:io';
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
      Logger.White.log("Check user if already exist...");
      await _supabaseClient
          .from("profiles")
          .select<Map<String, dynamic>>()
          .eq('email', email)
          .single();
      throw SignUpWithEmailAndPasswordFailure.fromCode(
        "email-already-in-use",
      );
    } on PostgrestException catch (e) {
      if (e.code == "PGRST116") {
        Logger.White.log("User empty. Create account...");
        try {
          saveRegisterProcess(true);
          final result = await _supabaseClient.auth.signUp(
            email: email,
            password: password,
            data: {
              'full_name': name,
              'email': email,
              'currency': currency,
            },
          );
          saveRegisterProcess(false);
          Logger.Green.log(
            "User Regist: ${result.user}",
          );
          Logger.Green.log(
            "User Session (must be null): ${result.session}",
          );
        } on AuthException catch (e) {
          Logger.Red.log("Status: ${e.statusCode} Message: ${e.message}");
          throw SignUpWithEmailAndPasswordFailure.fromCode(e.message);
        } on SocketException catch (e) {
          Logger.Red.log(e.message);
          throw SocketException(e.message);
        } on Exception catch (e) {
          Logger.Red.log(e.toString());
          throw SignUpWithEmailAndPasswordFailure(e.toString());
        }
      } else {
        Logger.Red.log(e.toString());
        throw PostgrestException(
          code: e.code,
          message: e.message,
          details: e.details,
          hint: e.hint,
        );
      }
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      saveLoginProcess(true);
      Logger.White.log("Send data email password...");
      final userResultLogin = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      saveLoginProcess(false);
      saveRegisterProcess(false);
      Logger.White.log("Get user data...");
      final userFromQuery = await _supabaseClient
          .from("profiles")
          .select<Map<String, dynamic>>()
          .eq('id', userResultLogin.user!.id)
          .single();

      Logger.White.log("Create data...");
      UserModel userModel = UserModel.fromMap(userFromQuery);

      final isVerifiedProcessNotPassed =
          userResultLogin.user!.emailConfirmedAt != null &&
              userFromQuery['verified_process'] == false;

      if (isVerifiedProcessNotPassed) {
        Logger.Green.log("User not pass verified process. Update data...");
        await _supabaseClient.from("profiles").upsert(
          {
            "id": userResultLogin.user!.id,
            'verified_process': true,
            'updated_at': DateTime.now().toIso8601String(),
          },
        );

        userModel = userModel.copyWith(verifiedProcess: true);
      }

      Logger.White.log("Save user data..");
      await _cache.setString(
        userCacheKey,
        userModelToMap(userModel),
      );

      if (isVerifiedProcessNotPassed) {
        Logger.Green.log(
          "User not pass verified process. Go to verif onboard...",
        );
        Future.delayed(
          const Duration(milliseconds: 1250),
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
      throw SocketException(e.message);
    } on Exception catch (e) {
      Logger.Red.log(e.toString());
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _cache.remove(userCacheKey),
        _cache.remove(registerStatusKey),
        _cache.remove(loginStatusKey),
      ]);
      await _supabaseClient.auth.signOut();
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
    return _cache.getBool(loginStatusKey) ?? true;
  }

  bool get registerProcess {
    return _cache.getBool(registerStatusKey) ?? true;
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

// UserModel? userModel = UserModel(
//   id: userResultLogin.user!.id,
//   name: userFromQuery['full_name'],
//   email: email,
//   lastBackupTime: userFromQuery['last_backup_time'],
//   verifiedProcess: userFromQuery['verified_process'],
//   currency: Currency.values.firstWhere(
//     (item) => item.value.countryCode == userFromQuery['currency'],
//     orElse: () => Currency.idr,
//   ),
//   monthlyBudget: userFromQuery["monthly_budget"].toDouble(),
//   monthlyIncome: userFromQuery["monthly_income"].toDouble(),
// );