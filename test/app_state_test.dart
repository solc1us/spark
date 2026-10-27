import 'package:flutter_test/flutter_test.dart';
import 'package:spark/data/mock_data.dart';
import 'package:spark/models/parking_draft.dart';
import 'package:spark/state/app_state.dart';

void main() {
  test('local accounts and sessions stay isolated and reset with AppState', () {
    final state = AppState();
    addTearDown(state.dispose);
    final user = mockUsers.first;
    var changes = 0;
    state.addListener(() => changes++);

    expect(state.currentUser, isNull);
    expect(state.activeSessions, isEmpty);
    expect(state.getParkingById(mockParkingSessions.first.id), isNull);
    expect(state.login(user.email, 'wrong-password'), isFalse);
    expect(changes, 0);
    expect(state.login(' ${user.email.toUpperCase()} ', user.password), isTrue);
    expect(changes, 1);
    expect(state.activeSessions, isNotEmpty);
    final originalId = state.activeSessions.first.id;
    expect(state.register('Duplicate', user.email, 'demo'), isFalse);
    expect(state.register('Mahasiswa', 'student@spark.local', 'demo'), isTrue);
    final newUserId = state.currentUser!.id;
    expect(newUserId, isNot(user.id));
    expect(state.activeSessions, isEmpty);
    expect(state.parkingHistory, isEmpty);
    expect(state.getParkingById(originalId), isNull);
    expect(() => state.completeParking(originalId), throwsStateError);
    state.startParkingDraft();
    state.logout();
    expect(state.currentUser, isNull);
    expect(state.parkingDraft, isNull);
    expect(state.login('student@spark.local', 'demo'), isTrue);
    expect(state.currentUser!.id, newUserId);

    final freshState = AppState();
    addTearDown(freshState.dispose);
    expect(freshState.login('student@spark.local', 'demo'), isFalse);
  });

  test(
    'draft creates unique sessions and completion changes only that session',
    () {
      final state = AppState();
      addTearDown(state.dispose);
      final user = mockUsers.first;
      state.login(user.email, user.password);
      final original = state.activeSessions.first;
      final historyCount = state.parkingHistory.length;
      final activeCount = state.activeSessions.length;
      var changes = 0;
      state.addListener(() => changes++);

      state.startParkingDraft();
      final draft = state.parkingDraft!;
      draft.cityId = original.cityId;
      draft.mode = original.mode;
      draft.category = original.category;
      draft.mallId = original.mallId;
      draft.photoPath = original.photoPath;
      draft.latitude = original.latitude;
      draft.longitude = original.longitude;
      state.updateParkingDraft(draft);
      expect(state.parkingDraft, same(draft));
      expect(state.activeSessions.length, activeCount);
      state.addParking(draft);
      expect(changes, 3);
      expect(state.parkingDraft, isNull);
      expect(state.activeSessions.length, activeCount + 1);
      final added = state.activeSessions.last;
      expect(mockParkingSessions.any((s) => s.id == added.id), isFalse);
      expect(added.createdAt.isUtc, isTrue);

      state.completeParking(added.id);
      final completed = state.getParkingById(added.id)!;
      expect(completed.status, 'completed');
      expect(completed.completedAt, isNotNull);
      expect(state.activeSessions.length, activeCount);
      expect(state.parkingHistory.length, historyCount + 1);
      expect(state.getParkingById(original.id), same(original));
      final completedAt = completed.completedAt;
      state.completeParking(added.id);
      expect(state.getParkingById(added.id)!.completedAt, completedAt);
      expect(changes, 4);

      draft.mode = 'free';
      state.addParking(draft);
      expect(state.activeSessions.last.id, isNot(added.id));
      expect(state.activeSessions.last.category, isNull);
      expect(state.activeSessions.last.mallId, isNull);
      expect(() => state.activeSessions.clear(), throwsUnsupportedError);
      expect(mockParkingSessions.length, activeCount + historyCount);
      expect(mockParkingSessions.first.status, original.status);
    },
  );

  test('invalid drafts do not add sessions or discard the shared draft', () {
    final state = AppState();
    addTearDown(state.dispose);
    expect(() => state.addParking(ParkingDraft()), throwsStateError);
    final user = mockUsers.first;
    state.login(user.email, user.password);
    state.startParkingDraft();
    final draft = state.parkingDraft!;
    final count = state.activeSessions.length;
    expect(() => state.addParking(draft), throwsArgumentError);
    final original = state.activeSessions.first;
    draft.cityId = original.cityId;
    draft.mode = 'structured';
    draft.category = 'mall';
    draft.mallId = mockMalls.firstWhere((m) => m.cityId != draft.cityId).id;
    draft.photoPath = original.photoPath;
    draft.latitude = original.latitude;
    draft.longitude = original.longitude;
    expect(() => state.addParking(draft), throwsArgumentError);
    draft.mallId = original.mallId;
    draft.latitude = double.nan;
    expect(() => state.addParking(draft), throwsArgumentError);
    expect(state.activeSessions.length, count);
    expect(state.parkingDraft, same(draft));
    expect(state.getMallsByCity('unknown-city'), isEmpty);
  });
}
