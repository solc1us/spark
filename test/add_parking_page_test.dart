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

  for (final category in ['event', 'other']) {
    testWidgets('$category requires a place name and keeps it when going back', (
      tester,
    ) async {
      final state = AppState();
      addTearDown(state.dispose);
      state.updateParkingDraft(
        ParkingDraft(
          cityId: 'city-bandung',
          mode: 'structured',
          category: category,
        ),
      );
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: state,
          child: MaterialApp(
            home: const AddParkingPage(),
            routes: {
              AppRoutes.capturePhoto: (_) =>
                  const Scaffold(body: Text('Halaman foto')),
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '   ');
      await tester.tap(find.text('Capture Photo'));
      await tester.pump();
      expect(find.text('Isi nama tempat.'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Pameran Kampus');
      await tester.tap(find.text('Capture Photo'));
      await tester.pumpAndSettle();
      expect(find.text('Halaman foto'), findsOneWidget);
      expect(state.parkingDraft?.placeName, 'Pameran Kampus');

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.text('Pameran Kampus'), findsOneWidget);
    });
  }

  testWidgets('free mode allows an empty place name', (tester) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(ParkingDraft(cityId: 'city-bandung', mode: 'free'));
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          home: const AddParkingPage(),
          routes: {
            AppRoutes.capturePhoto: (_) =>
                const Scaffold(body: Text('Halaman foto')),
          },
        ),
      ),
    );

    expect(find.text('Opsional'), findsNWidgets(2));
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
  });

  testWidgets('changing category and mode clears the old place name', (
    tester,
  ) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(
        cityId: 'city-bandung',
        mode: 'structured',
        category: 'event',
        placeName: 'Event lama',
      ),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: AddParkingPage()),
      ),
    );

    await tester.tap(find.text('Event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lainnya').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.placeName, isNull);
    expect(find.text('Event lama'), findsNothing);

    await tester.enterText(find.byType(TextFormField), 'Tempat lain');
    await tester.tap(find.text('Terstruktur'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bebas').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.placeName, isNull);
    await tester.enterText(find.byType(TextFormField), 'Lokasi bebas');
    expect(state.parkingDraft?.placeName, 'Lokasi bebas');
  });

  testWidgets('area can be selected and cleared', (tester) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(ParkingDraft(cityId: 'city-bandung', mode: 'free'));
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: AddParkingPage()),
      ),
    );

    await tester.tap(find.text('Area parkir'));
    await tester.pumpAndSettle();
    for (final code in ['B1', 'B2', 'R1', 'R2']) {
      expect(find.text(code), findsOneWidget);
    }
    await tester.tap(find.text('B1'));
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.areaCode, 'B1');

    await tester.tap(find.text('B1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tanpa area'));
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.areaCode, isNull);
  });

  testWidgets('manual area is required and preserved when returning', (
    tester,
  ) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(ParkingDraft(cityId: 'city-bandung', mode: 'free'));
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          home: const AddParkingPage(),
          routes: {
            AppRoutes.capturePhoto: (_) =>
                const Scaffold(body: Text('Halaman foto')),
          },
        ),
      ),
    );

    await tester.tap(find.text('Area parkir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lainnya'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Kode area'), ' ');
    await tester.ensureVisible(find.text('Capture Photo'));
    await tester.tap(find.text('Capture Photo'));
    await tester.pump();
    expect(find.text('Isi kode area parkir.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Kode area'),
      'P3',
    );
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
    expect(state.parkingDraft?.areaCode, 'P3');

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.text('P3'), findsOneWidget);
  });

  testWidgets('manual area is restored from an existing draft', (tester) async {
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free', areaCode: 'P3'),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: AddParkingPage()),
      ),
    );
    expect(find.text('P3'), findsOneWidget);
    expect(find.text('Kode area'), findsOneWidget);
  });
}
