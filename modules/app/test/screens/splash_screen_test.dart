import 'package:app/presentation/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networking/services/auth_services.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoutes {
  static const onboardScreen = '/onboard';
  static const mainScreen = '/main';
}

class MockAuthService extends Mock implements AuthService {
  MockAuthService() {
    when(() => authStateChanges)
        .thenAnswer((_) => Stream<MockUser?>.value(null));
    when(() => authStateChanges)
        .thenAnswer((_) => Stream<MockUser?>.value(MockUser()));
  }
}

class MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(PageRouteBuilder<dynamic>(
      pageBuilder: (_, __, ___) => Container(),
    ));
  });

  late MockNavigatorObserver mockObserver;
  late MockAuthService mockAuthService;

  setUp(() {
    mockObserver = MockNavigatorObserver();
    mockAuthService = MockAuthService();
  });
  group("Splash Screen", () {
    testWidgets('SplashScreen navigation test not sign in',
        (WidgetTester tester) async {
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream<MockUser?>.value(null));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 847),
          child: MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/': (_) => SplashScreen(
                    authService: mockAuthService,
                  ),
              MockRoutes.onboardScreen: (_) => Container(),
              MockRoutes.mainScreen: (_) => Container(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute<void>(
                builder: (_) => Container(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('SplashScreen navigation test signin',
        (WidgetTester tester) async {
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream<MockUser?>.value(MockUser()));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 847),
          child: MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/': (_) => SplashScreen(
                    authService: mockAuthService,
                  ),
              MockRoutes.onboardScreen: (_) => Container(),
              MockRoutes.mainScreen: (_) => Container(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute<void>(
                builder: (_) => Container(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
