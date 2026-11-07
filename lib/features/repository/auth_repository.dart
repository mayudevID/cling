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
  static String _pendingCurrencyKey(String uid) => '__signup_currency_$uid';

  static bool isTemporaryServiceFailure(FirebaseException error) => const {
        'unavailable',
        'deadline-exceeded',
        'network-request-failed',
      }.contains(error.code);

  /// Create or repair a missing profile without changing already stored
  /// fields, even if account creation was interrupted after Firebase Auth.
  Future<UserModel> ensureProfile(User user, {String? currency}) async {
    final uid = user.uid;
    final savedCurrency =
        currency ?? _cache.getString(_pendingCurrencyKey(uid)) ?? 'ID';
    final createdAt = user.metadata.creationTime?.toIso8601String() ??
        DateTime.now().toUtc().toIso8601String();
    final defaults = <String, dynamic>{
      'uid': uid,
      'currency': savedCurrency,
      'created_at': createdAt,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'last_backup_time': null,
      'recurring_day': 0,
      'verified_process': false,
      'monthly_budget': 0,
      'monthly_income': 0,
    };

    final ref = _firestore.collection('users').doc(uid);
    final data = await _firestore.runTransaction<Map<String, dynamic>>(
      (transaction) async {
        final current = await transaction.get(ref);
        final existing = current.data() ?? <String, dynamic>{};
        if (existing['uid'] != null && existing['uid'] != uid) {
          throw StateError('Profile belongs to another Firebase UID');
        }
        final missing = <String, dynamic>{};
        for (final entry in defaults.entries) {
          if (!existing.containsKey(entry.key)) {
            missing[entry.key] = entry.value;
          }
        }
        if (missing.isNotEmpty) {
          transaction.set(ref, missing, SetOptions(merge: true));
        }
        return <String, dynamic>{...defaults, ...existing};
      },
    );
    await _cache.remove(_pendingCurrencyKey(uid));
    return UserModel.fromMap(data);
  }

  UserModel? cachedProfileForUser(String uid) {
    try {
      final cached = currentUserModel;
      return cached?.uid == uid ? cached : null;
    } catch (_) {
      return null;
    }
  }

  /// Reuse an existing Firebase Auth session only when it belongs to the
  /// cached local profile. This is session continuation, not password login.
  static bool isSavedSessionEligible({
    required String? firebaseUid,
    required bool emailVerified,
    required String? cachedUid,
  }) {
    return firebaseUid != null &&
        firebaseUid.isNotEmpty &&
        emailVerified &&
        cachedUid == firebaseUid;
  }

  bool get canResumeSavedSession {
    final user = _firebaseAuth.currentUser;
    return isSavedSessionEligible(
      firebaseUid: user?.uid,
      emailVerified: user?.emailVerified == true,
      cachedUid: user == null ? null : cachedProfileForUser(user.uid)?.uid,
    );
  }

  // Cache deletion is performed by awaited logout operations. A listener
  // must not asynchronously clear a newly signed-in account's cached UID.
  Stream<User?> get user => _firebaseAuth.userChanges();

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
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await _cache.setString(_pendingCurrencyKey(user.uid), currency);
    // Verification can proceed even when Firestore is temporarily offline.
    await user.sendEmailVerification();
    await user.updateDisplayName(name);
    await ensureProfile(user, currency: currency);
    await saveRegisterProcess(false);
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await saveLoginProcess(true);
    final credentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credentials.user!;
    if (!user.emailVerified) {
      throw EmailNotVerifiedException();
    }

    UserModel userModel;
    try {
      // Creates a missing document after partially completed registration.
      userModel = await ensureProfile(user);
    } on FirebaseException catch (error) {
      final cached = cachedProfileForUser(user.uid);
      if (!isTemporaryServiceFailure(error) || cached == null) rethrow;
      // The cache is a read-only offline fallback for this exact Firebase UID.
      // Recurring income must not run until server settings are reconciled.
      userModel = cached;
    }

    // Do not mark onboarding as complete during login. The final onboarding
    // submission commits verified_process only after monthly settings persist.
    await _cache.setString(userCacheKey, userModelToMap(userModel));
    await saveLoginProcess(false);
    await saveRegisterProcess(false);
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
