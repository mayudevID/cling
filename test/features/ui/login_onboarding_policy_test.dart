import 'package:cling/core/route.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/app_bloc/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Saved session eligibility', () {
    test('only an existing verified session matching the cached UID can resume', () {
      expect(
        AuthRepository.isSavedSessionEligible(
          firebaseUid: 'user-a',
          emailVerified: true,
          cachedUid: 'user-a',
        ),
        isTrue,
      );

      for (final input in [
        (uid: null, verified: true, cached: 'user-a'),
        (uid: '', verified: true, cached: ''),
        (uid: 'user-a', verified: false, cached: 'user-a'),
        (uid: 'user-a', verified: true, cached: 'user-b'),
        (uid: 'user-a', verified: true, cached: null),
      ]) {
        expect(
          AuthRepository.isSavedSessionEligible(
            firebaseUid: input.uid,
            emailVerified: input.verified,
            cachedUid: input.cached,
          ),
          isFalse,
        );
      }
    });
  });

  group('Authenticated navigation', () {
    test('unfinished monthly setup never routes directly to dashboard', () {
      expect(
        AppBloc.routeForAccount(
          isReady: true,
          emailVerified: true,
          loginInProgress: false,
          registrationInProgress: false,
          onboardingCompleted: false,
        ),
        RouteName.verifOnboard,
      );
    });

    test('finished onboarding routes to dashboard', () {
      expect(
        AppBloc.routeForAccount(
          isReady: true,
          emailVerified: true,
          loginInProgress: false,
          registrationInProgress: false,
          onboardingCompleted: true,
        ),
        RouteName.main,
      );
    });

    test('unverified identity and unfinished login cannot enter finance', () {
      for (final blocked in [
        (ready: false, verified: true, loggingIn: false, registering: false),
        (ready: true, verified: false, loggingIn: false, registering: false),
        (ready: true, verified: true, loggingIn: true, registering: false),
        (ready: true, verified: true, loggingIn: false, registering: true),
      ]) {
        expect(
          AppBloc.routeForAccount(
            isReady: blocked.ready,
            emailVerified: blocked.verified,
            loginInProgress: blocked.loggingIn,
            registrationInProgress: blocked.registering,
            onboardingCompleted: true,
          ),
          RouteName.onboard,
        );
      }
    });
  });
}
