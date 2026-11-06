import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/models/evaluation.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:flutter_application_1/core/widgets/pickleball_logo.dart';
import 'package:flutter_application_1/app.dart';

void main() {
  group('PickleTrack Unit Tests', () {
    test('Drill accuracy calculation handles normal, edge, and zero attempts safely', () {
      // 14 out of 20 = 70.0%
      expect(Validators.calculateAccuracy(14, 20), 70.0);

      // Division by zero safe guard
      expect(Validators.calculateAccuracy(0, 0), 0.0);

      // Negative attempts safe guard
      expect(Validators.calculateAccuracy(-5, 10), 0.0);

      // Exceeded attempts capped
      expect(Validators.calculateAccuracy(25, 20), 100.0);
    });

    test('Evaluation overall score calculates correctly from valid 1-10 skill ratings', () {
      final ratings = {
        'Serve': 8,
        'Return of Serve': 7,
        'Dinking': 7,
        'Volley': 6,
        'Groundstrokes': 8,
        'Third-Shot Drop': 7,
      };

      final eval = Evaluation(
        id: 'eval_test',
        roomId: 'room_test',
        coachId: 'coach_1',
        playerId: 'player_1',
        evaluationDate: DateTime.now(),
        skillRatings: ratings,
      );

      // (8+7+7+6+8+7) / 6 = 43 / 6 = 7.166... -> 7.2
      expect(eval.overallScore, 7.2);
    });

    test('Validation functions validate email, password, and drill attempts', () {
      expect(Validators.email('test@pickletrack.com'), isNull);
      expect(Validators.email('invalid-email'), isNotNull);

      expect(Validators.password('123456'), isNull);
      expect(Validators.password('123'), isNotNull);

      expect(Validators.drillAttempts(20, 15), isNull);
      expect(Validators.drillAttempts(10, 15), isNotNull);
    });
  });

  group('PickleTrack Unified Architecture Widget Tests', () {
    testWidgets('Starts directly with LoginScreen (no welcome or role selection screen)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authService = AuthService();
      final firestoreService = FirestoreService();

      await tester.pumpWidget(
        PickleTrackApp(
          authService: authService,
          firestoreService: firestoreService,
        ),
      );
      await tester.pumpAndSettle();

      // Starts directly at Login Screen (Mockup Screen 1)
      expect(find.byType(PickleballLogo), findsOneWidget);
      expect(find.text('Email Address or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
      expect(find.text('Juan Dela Cruz'), findsOneWidget);
      expect(find.text('Coach Mark'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Logs in via Quick Demo as Juan Dela Cruz into Unified MainNavigationScreen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authService = AuthService();
      final firestoreService = FirestoreService();

      await tester.pumpWidget(
        PickleTrackApp(
          authService: authService,
          firestoreService: firestoreService,
        ),
      );
      await tester.pumpAndSettle();

      // Ensure button is visible and tap Quick Demo Login for Juan Dela Cruz
      await tester.ensureVisible(find.text('Juan Dela Cruz'));
      await tester.tap(find.text('Juan Dela Cruz'));
      await tester.pumpAndSettle();

      // Verifies Unified Dashboard loads with greeting and tabs (Mockup Screen 3)
      expect(find.textContaining('Good morning, Juan!'), findsOneWidget);
      expect(find.text('KEEP IMPROVING'), findsOneWidget);
      expect(find.text('My Coaching Rooms'), findsOneWidget);
      expect(find.text('Upcoming Session'), findsOneWidget);
      expect(find.text('Recent Activities'), findsOneWidget);

      // Verifies the 5 bottom navigation destinations (Mockup Screen 15)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Rooms'), findsOneWidget);
      expect(find.text('Training'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Navigates across unified tabs: Rooms, Training, Progress, Profile', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authService = AuthService();
      final firestoreService = FirestoreService();

      await tester.pumpWidget(
        PickleTrackApp(
          authService: authService,
          firestoreService: firestoreService,
        ),
      );
      await tester.pumpAndSettle();

      // Log in as Juan
      await tester.ensureVisible(find.text('Juan Dela Cruz'));
      await tester.tap(find.text('Juan Dela Cruz'));
      await tester.pumpAndSettle();

      // Tap Rooms tab (Mockup Screen 4)
      await tester.tap(find.text('Rooms'));
      await tester.pumpAndSettle();
      expect(find.text('My Coaching Rooms'), findsOneWidget);
      expect(find.text('Active (1)'), findsOneWidget);
      expect(find.text('Past (1)'), findsOneWidget);
      expect(find.text('Invite / New Room'), findsOneWidget);

      // Tap Training tab (Mockup Screen 6)
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();
      expect(find.text('Training Program'), findsOneWidget);
      expect(find.text('Assigned Weekly Drills'), findsOneWidget);
      expect(find.text('Drill Library'), findsOneWidget);

      // Tap Progress tab (Mockup Screen 10)
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      expect(find.text('My Progress'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Drill Accuracy'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);

      // Tap Profile tab (Mockup Screen 15)
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Active Rooms'), findsOneWidget);
      expect(find.text('Total Sessions'), findsOneWidget);
      expect(find.text('Coaching History'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('PickleballLogo renders official Logo 1 assets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PickleballLogo(height: 100),
                PickleballLogo(height: 80, isDarkBackground: true),
                PickleballLogo(height: 40, compact: true),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PickleballLogo), findsNWidgets(3));
      expect(find.byType(Image), findsNWidgets(3));
      expect(find.text('PickleTrack'), findsOneWidget); // From compact logo
    });
  });
}
