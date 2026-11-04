import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spark/models/parking_draft.dart';
import 'package:spark/pages/add_parking_page.dart';
import 'package:spark/routes/app_routes.dart';
import 'package:spark/state/app_state.dart';

Future<void> useTallScreen(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

void main() {
  testWidgets('mall follows the city and stale selections are cleared', (
    tester,
  ) async {
    await useTallScreen(tester);
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
    await useTallScreen(tester);
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
            AppRoutes.capturePhoto: (_) =>
                const Scaffold(body: Text('Halaman foto')),
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
    testWidgets(
      '$category requires a place name and keeps it when going back',
      (tester) async {
        await useTallScreen(tester);
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

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama tempat'),
          '   ',
        );
        await tester.ensureVisible(find.text('Capture Photo'));
        await tester.tap(find.text('Capture Photo'));
        await tester.pump();
        expect(find.text('Isi nama tempat.'), findsOneWidget);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama tempat'),
          'Pameran Kampus',
        );
        await tester.ensureVisible(find.text('Capture Photo'));
        await tester.tap(find.text('Capture Photo'));
        await tester.pumpAndSettle();
        expect(find.text('Halaman foto'), findsOneWidget);
        expect(state.parkingDraft?.placeName, 'Pameran Kampus');

        tester.state<NavigatorState>(find.byType(Navigator)).pop();
        await tester.pumpAndSettle();
        expect(find.text('Pameran Kampus'), findsOneWidget);
      },
    );
  }

  testWidgets('free mode allows an empty place name', (tester) async {
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free'),
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

    expect(find.text('Opsional'), findsNWidgets(2));
    await tester.ensureVisible(find.text('Capture Photo'));
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
  });

  testWidgets('changing category and mode clears the old place name', (
    tester,
  ) async {
    await useTallScreen(tester);
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

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama tempat'),
      'Tempat lain',
    );
    await tester.tap(find.text('Terstruktur'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bebas').last);
    await tester.pumpAndSettle();
    expect(state.parkingDraft?.placeName, isNull);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama tempat'),
      'Lokasi bebas',
    );
    expect(state.parkingDraft?.placeName, 'Lokasi bebas');
  });

  testWidgets('area can be selected and cleared', (tester) async {
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free'),
    );
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
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free'),
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

    await tester.tap(find.text('Area parkir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lainnya'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Kode area'),
      ' ',
    );
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
    await useTallScreen(tester);
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

  testWidgets('notes are optional and preserved when returning', (
    tester,
  ) async {
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free'),
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

    final notes = find.widgetWithText(TextFormField, 'Catatan (opsional)');
    await tester.ensureVisible(notes);
    await tester.enterText(notes, 'Dekat pilar A');
    expect(state.parkingDraft?.notes, 'Dekat pilar A');

    await tester.ensureVisible(find.text('Capture Photo'));
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(notes);
    expect(find.text('Dekat pilar A'), findsOneWidget);

    await tester.enterText(notes, '');
    await tester.ensureVisible(find.text('Capture Photo'));
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
  });

  testWidgets('reminder must be positive and is preserved when returning', (
    tester,
  ) async {
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free'),
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

    final reminder = find.widgetWithText(
      TextFormField,
      'Pengingat (menit, opsional)',
    );
    for (final value in ['0', '-1', 'abc', '1.5']) {
      await tester.enterText(reminder, value);
      await tester.ensureVisible(find.text('Capture Photo'));
      await tester.tap(find.text('Capture Photo'));
      await tester.pump();
      expect(
        find.text('Isi durasi pengingat dengan menit positif.'),
        findsOneWidget,
      );
      ScaffoldMessenger.of(tester.element(find.byType(AddParkingPage)))
          .removeCurrentSnackBar();
      await tester.pumpAndSettle();
    }

    await tester.enterText(reminder, '60');
    expect(state.parkingDraft?.reminderMinutes, 60);
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.text('60'), findsOneWidget);

    await tester.enterText(reminder, '');
    expect(state.parkingDraft?.reminderMinutes, isNull);
    await tester.tap(find.text('Capture Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Halaman foto'), findsOneWidget);
  });

  testWidgets('reminder is restored from an existing draft', (tester) async {
    await useTallScreen(tester);
    final state = AppState();
    addTearDown(state.dispose);
    state.updateParkingDraft(
      ParkingDraft(cityId: 'city-bandung', mode: 'free', reminderMinutes: 45),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: AddParkingPage()),
      ),
    );
    expect(find.text('45'), findsOneWidget);
  });
}
