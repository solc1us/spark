import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spark/models/parking_draft.dart';
import 'package:spark/pages/add_parking_page.dart';
import 'package:spark/routes/app_routes.dart';
import 'package:spark/state/app_state.dart';

void main() {
  testWidgets('mall follows the city and stale selections are cleared', (
    tester,
  ) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'structured'),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: AddParkingPage()),
      ),
    );

    await tester.tap(find.text('Kategori tempat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mall').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.category, 'mall');

    await tester.tap(find.text('Mall').last);
    await tester.pumpAndSettle();
    expect(find.text('Paris Van Java'), findsOneWidget);
    expect(find.text('Grand Indonesia'), findsNothing);
    await tester.tap(find.text('Paris Van Java'));
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.mallId, 'mall-pvj');

    await tester.tap(find.text('Bandung'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jakarta').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.mallId, isNull);
    await tester.tap(find.text('Mall').last);
    await tester.pumpAndSettle();
    expect(find.text('Grand Indonesia'), findsOneWidget);
    expect(find.text('Paris Van Java'), findsNothing);
    await tester.tap(find.text('Grand Indonesia'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mall').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Event').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.category, 'event');
    expect(state.parkingDraft?.mallId, isNull);
  });

  testWidgets('structured form validates category and mall before continuing', (
    tester,
  ) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'structured'),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          home: const AddParkingPage(),
          routes: {
            AppRoutes.capturePhoto: (_) => const Scaffold(
              body: Text('Halaman foto'),
            ),
          },
        ),
      ),
    );

    await tester.tap(find.text('Capture Photo'));
    await tester.pump();
    expect(find.text('Pilih kategori tempat.'), findsOneWidget);
    ScaffoldMessenger.of(tester.element(find.byType(AddParkingPage)))
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kategori tempat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mall').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture Photo'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Pilih mall.'), findsOneWidget);

    await tester.tap(find.text('Mall').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paris Van Java'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
    expect(state.parkingDraft?.mallId, 'mall-pvj');
  });
}
