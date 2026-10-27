import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/app_user.dart';
import '../models/city.dart';
import '../models/mall.dart';
import '../models/parking_draft.dart';
import '../models/parking_session.dart';

class AppState extends ChangeNotifier {
  final List<AppUser> _users = List.of(mockUsers);
  final List<ParkingSession> _sessions = List.of(mockParkingSessions);
  AppUser? _currentUser;
  ParkingDraft? _parkingDraft;
  int _nextUserId = 1;
  int _nextParkingId = 1;

  AppUser? get currentUser => _currentUser;
  ParkingDraft? get parkingDraft => _parkingDraft;
  List<City> get cities => mockCities;

  List<Mall> getMallsByCity(String cityId) =>
      List.unmodifiable(mockMalls.where((mall) => mall.cityId == cityId));

  List<ParkingSession> get activeSessions => List.unmodifiable(
    _sessions.where(
      (session) =>
          session.userId == _currentUser?.id && session.status == 'active',
    ),
  );

  List<ParkingSession> get parkingHistory => List.unmodifiable(
    _sessions.where(
      (session) =>
          session.userId == _currentUser?.id && session.status == 'completed',
    ),
  );

  ParkingSession? getParkingById(String id) {
    for (final session in _sessions) {
      if (session.id == id && session.userId == _currentUser?.id) {
        return session;
      }
    }
    return null;
  }

  bool login(String email, String password) {
    for (final user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase() &&
          user.password == password) {
        _currentUser = user;
        _parkingDraft = null;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  bool register(String name, String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty ||
        !normalizedEmail.contains('@') ||
        password.trim().isEmpty ||
        _users.any((user) => user.email.toLowerCase() == normalizedEmail)) {
      return false;
    }
    var id = 'user-${_nextUserId++}';
    while (_users.any((user) => user.id == id)) {
      id = 'user-${_nextUserId++}';
    }
    final user = AppUser(
      id: id,
      name: name.trim(),
      email: normalizedEmail,
      password: password,
    );
    _users.add(user);
    _currentUser = user;
    _parkingDraft = null;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _parkingDraft = null;
    notifyListeners();
  }

  void startParkingDraft() {
    _parkingDraft = ParkingDraft();
    notifyListeners();
  }

  void updateParkingDraft(ParkingDraft draft) {
    _parkingDraft = draft;
    notifyListeners();
  }

  void clearParkingDraft() {
    _parkingDraft = null;
    notifyListeners();
  }

  void addParking(ParkingDraft draft) {
    final user = _currentUser;
    if (user == null) throw StateError('Login terlebih dahulu.');

    final cityId = draft.cityId;
    final mode = draft.mode;
    final photoPath = draft.photoPath?.trim();
    final latitude = draft.latitude;
    final longitude = draft.longitude;
    if (cityId == null || !cities.any((city) => city.id == cityId)) {
      throw ArgumentError('Pilih kota yang tersedia.');
    }
    if (mode != 'structured' && mode != 'free') {
      throw ArgumentError('Pilih metode pencatatan.');
    }
    if (mode == 'structured') {
      if (!['mall', 'event', 'other'].contains(draft.category)) {
        throw ArgumentError('Pilih kategori tempat.');
      }
      if (draft.category == 'mall') {
        if (!getMallsByCity(cityId).any((mall) => mall.id == draft.mallId)) {
          throw ArgumentError('Pilih mall sesuai kota.');
        }
      } else if (draft.placeName == null || draft.placeName!.trim().isEmpty) {
        throw ArgumentError('Isi nama tempat.');
      }
    }
    if (photoPath == null || photoPath.isEmpty) {
      throw ArgumentError('Foto parkir wajib diisi.');
    }
    if (latitude == null ||
        longitude == null ||
        !latitude.isFinite ||
        !longitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw ArgumentError('Koordinat tidak valid.');
    }
    if (draft.reminderMinutes != null && draft.reminderMinutes! <= 0) {
      throw ArgumentError('Durasi pengingat harus positif.');
    }

    var id = 'parking-${_nextParkingId++}';
    while (_sessions.any((session) => session.id == id)) {
      id = 'parking-${_nextParkingId++}';
    }
    _sessions.add(
      ParkingSession(
        id: id,
        userId: user.id,
        cityId: cityId,
        mode: mode!,
        category: mode == 'structured' ? draft.category : null,
        mallId: mode == 'structured' && draft.category == 'mall'
            ? draft.mallId
            : null,
        placeName: draft.placeName?.trim(),
        areaCode: draft.areaCode?.trim(),
        notes: draft.notes?.trim(),
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
        reminderMinutes: draft.reminderMinutes,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    _parkingDraft = null;
    notifyListeners();
  }

  void completeParking(String id) {
    final session = getParkingById(id);
    if (session == null) throw StateError('Sesi parkir tidak ditemukan.');
    if (session.status == 'completed') return;

    final index = _sessions.indexOf(session);
    _sessions[index] = session.copyWith(
      status: 'completed',
      completedAt: DateTime.now().toUtc(),
    );
    notifyListeners();
  }
}
