import 'package:cling/features/ui/language/lang_export.dart';
import '../main.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .invalidEmailFailure,
        );
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .userDisabledFailure,
        );
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .emailAlreadyFailure,
        );
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .operationNotAllowedFailure,
        );
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .weakPasswordFailure,
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return LogInWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .invalidEmailFailure,
        );
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .userDisabledFailure,
        );
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .userNotFoundFailure,
        );
      case 'wrong-password':
        return LogInWithEmailAndPasswordFailure(
          AppLocalizations.of(MainApp.navKeyGlobal.currentContext!)!
              .wrongPasswordFailure,
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

class LogOutFailure implements Exception {}
