import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spark/data/mock_data.dart';
import 'package:spark/main.dart';
import 'package:spark/pages/add_parking_page.dart';
import 'package:spark/pages/capture_photo_page.dart';
import 'package:spark/pages/confirm_location_page.dart';
import 'package:spark/pages/home_page.dart';
import 'package:spark/pages/login_page.dart';
import 'package:spark/pages/parking_detail_page.dart';
import 'package:spark/pages/parking_history_page.dart';
import 'package:spark/pages/register_page.dart';
import 'package:spark/routes/app_routes.dart';
import 'package:spark/state/app_state.dart';

void main() {
  testWidgets('all eight routes open and detail receives the session ID', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const SparkApp(),
      ),
    );
    expect(find.byType(LoginPage), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    final pages = <String, Type>{
      AppRoutes.register: RegisterPage,
      AppRoutes.home: HomePage,
      AppRoutes.addParking: AddParkingPage,
      AppRoutes.capturePhoto: CapturePhotoPage,
      AppRoutes.confirmLocation: ConfirmLocationPage,
      AppRoutes.parkingHistory: ParkingHistoryPage,
      AppRoutes.parkingDetail: ParkingDetailPage,
    };
    for (final entry in pages.entries) {
      navigator.pushNamed(entry.key, arguments: 'session-test');
      await tester.pumpAndSettle();
      expect(find.byType(entry.value), findsOneWidget);
      if (entry.key == AppRoutes.parkingDetail) {
        expect(
          tester
              .widget<ParkingDetailPage>(find.byType(ParkingDetailPage))
              .parkingSessionId,
          'session-test',
        );
      }
      navigator.pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('login and Home, Detail, History read the same AppState', (
    tester,
  ) async {
    final state = AppState();
    addTearDown(state.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const SparkApp()),
    );
    final user = mockUsers.first;
    await tester.enterText(find.byType(TextField).at(0), user.email);
    await tester.enterText(find.byType(TextField).at(1), user.password);
    await tester.tap(find.widgetWithText(TextButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    final session = state.activeSessions.first;
    await tester.tap(find.text(session.id));
    await tester.pumpAndSettle();
    expect(find.byType(ParkingDetailPage), findsOneWidget);
    expect(find.text('active'), findsOneWidget);
    state.completeParking(session.id);
    await tester.pump();
    expect(find.text('completed'), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text(session.id), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Parking History'));
    await tester.pumpAndSettle();
    expect(find.text(session.id), findsOneWidget);
    await tester.tap(find.text(session.id));
    await tester.pumpAndSettle();
    expect(find.text('completed'), findsOneWidget);
    navigator.pop();
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(state.currentUser, isNull);
    expect(navigator.canPop(), isFalse);
  });
}
