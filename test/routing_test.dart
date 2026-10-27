import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  testWidgets('all eight routes open and detail receives the session ID', (
    tester,
  ) async {
    await tester.pumpWidget(const SparkApp());
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
}
