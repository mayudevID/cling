import 'package:cling/features/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/exception.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final SharedPreferences _cache;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required SharedPreferences cache,
  })  : _firebaseAuth = firebaseAuth,
        _cache = cache;

  static const userCacheKey = '__user_cache_key__';
  static const onboardStatusKey = '__onboard_stat_key__';
  static const loginStatusKey = '__login_stat_key__';
  static const registerStatusKey = '__register_stat_key__';

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser?.toUser;
      if (user != null) {
        _cache.setString(userCacheKey, userModelToMap(user));
      } else {
        _cache.remove(userCacheKey);
      }
      return user;
    });
  }

  UserModel? get currentUser {
    final getData = _cache.getString(userCacheKey);
    if (getData != null) {
      return userModelFromMap(getData);
    }
    return null;
  }

  bool isOnboardPassed() {
    return _cache.getBool(onboardStatusKey) ?? false;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _cache.remove(userCacheKey),
        _cache.remove(registerStatusKey),
        _cache.remove(loginStatusKey),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future<void> saveLoginStatus(bool val) async {
    await _cache.setBool(loginStatusKey, val);
  }

  Future<void> saveRegisterStatus(bool val) async {
    await _cache.setBool(registerStatusKey, val);
  }

  bool get loginStatus {
    return _cache.getBool(loginStatusKey) ?? false;
  }

  bool get registerStatus {
    return _cache.getBool(registerStatusKey) ?? false;
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser!.updateDisplayName(displayName);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}

extension on User {
  UserModel get toUser {
    return UserModel(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
      emailVerified: emailVerified,
    );
  }
}
