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

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser?.toUser;
      if (user != null) {
        _cache.setString(userCacheKey, userModelToMap(user));
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
      ]);
      await _cache.remove(userCacheKey);
    } catch (_) {
      throw LogOutFailure();
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
    );
  }
}
