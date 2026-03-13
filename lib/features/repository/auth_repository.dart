import '../../core/logger.dart';
import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/exception.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required SharedPreferences cache,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _cache = cache;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _cache;

  static const userCacheKey = '__user_cache_key__';
  static const loginStatusKey = '__login_stat_key__';
  static const registerStatusKey = '__register_stat_key__';

  Stream<User?> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      final user = firebaseUser;
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

  User? get currentUserFirebase {
    return _firebaseAuth.currentUser;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String currency,
  }) async {
    await saveRegisterProcess(true);
    Logger.White.log("User empty. Create account...");
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await saveRegisterProcess(false);
    Logger.Green.log("User regist: ${userCredential.user!.uid}");
    Logger.White.log("Saving user data..");
    await userCredential.user!.updateDisplayName(name);
    await _firestore.collection("users").doc(userCredential.user!.uid).set(
      {
        "uid": userCredential.user!.uid,
        "currency": currency,
        "created_at": DateTime.now().toIso8601String(),
        "last_backup_time": null,
        "recurring_day": 0,
        "verified_process": false,
        "monthly_budget": 0,
        "monthly_income": 0,
        "updated_at": DateTime.now().toIso8601String(),
      },
    );
    Logger.White.log("Send email verification..");
    await userCredential.user!.sendEmailVerification();
  }

  Future<bool> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await saveLoginProcess(true);
    Logger.White.log("User login...");
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!userCredential.user!.emailVerified) {
      throw EmailNotVerifiedException();
    }

    await saveLoginProcess(false);
    await saveRegisterProcess(false);
    Logger.Green.log("User logged...");
    Logger.White.log("Get user data...");
    final userDoc = await _firestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();
    var userModel = UserModel.fromMap(userDoc.data()!);

    final isVerifiedProcessNotPassed =
        userCredential.user!.emailVerified && !userModel.verifiedProcess;

    if (isVerifiedProcessNotPassed) {
      Logger.Green.log("User not pass verified process. Update data...");

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .update({
        "verified_process": true,
      });

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
    }

    return isVerifiedProcessNotPassed;
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _cache.remove(userCacheKey),
        _cache.remove(registerStatusKey),
        _cache.remove(loginStatusKey),
      ]);
      await _firebaseAuth.signOut();
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

  Future<void> sendResetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
