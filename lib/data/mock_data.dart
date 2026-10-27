import '../models/app_user.dart';
import '../models/city.dart';
import '../models/mall.dart';
import '../models/parking_session.dart';

// Initial demo data only. AppState owns all runtime changes.
const mockUsers = [
  AppUser(
    id: 'user-1',
    name: 'Pengguna Demo',
    email: 'demo@spark.local',
    password: 'spark123',
  ),
];

const mockCities = [
  City(id: 'city-bandung', name: 'Bandung'),
  City(id: 'city-jakarta', name: 'Jakarta'),
  City(id: 'city-surabaya', name: 'Surabaya'),
];

const mockMalls = [
  Mall(id: 'mall-pvj', cityId: 'city-bandung', name: 'Paris Van Java'),
  Mall(id: 'mall-tsm', cityId: 'city-bandung', name: 'Trans Studio Mall'),
  Mall(id: 'mall-gi', cityId: 'city-jakarta', name: 'Grand Indonesia'),
  Mall(id: 'mall-cp', cityId: 'city-jakarta', name: 'Central Park'),
  Mall(id: 'mall-tp', cityId: 'city-surabaya', name: 'Tunjungan Plaza'),
  Mall(id: 'mall-pakuwon', cityId: 'city-surabaya', name: 'Pakuwon Mall'),
];

// Example paths are placeholders, not bundled photos or server URLs.
final mockParkingSessions = List<ParkingSession>.unmodifiable([
  ParkingSession(
    id: 'parking-1',
    userId: 'user-1',
    cityId: 'city-bandung',
    mode: 'structured',
    category: 'mall',
    mallId: 'mall-pvj',
    areaCode: 'B1',
    notes: 'Dekat pintu masuk.',
    photoPath: '/mock/photos/parking-1.jpg',
    latitude: -6.8897,
    longitude: 107.5967,
    reminderMinutes: 60,
    createdAt: DateTime.utc(2026, 10, 27, 3),
  ),
  ParkingSession(
    id: 'parking-2',
    userId: 'user-1',
    cityId: 'city-jakarta',
    mode: 'free',
    placeName: 'Dekat taman',
    notes: 'Di bawah pohon.',
    photoPath: '/mock/photos/parking-2.jpg',
    latitude: -6.1754,
    longitude: 106.8272,
    createdAt: DateTime.utc(2026, 10, 27, 4),
  ),
  ParkingSession(
    id: 'parking-3',
    userId: 'user-1',
    cityId: 'city-surabaya',
    mode: 'structured',
    category: 'event',
    placeName: 'Pameran Kampus',
    areaCode: 'R1',
    photoPath: '/mock/photos/parking-3.jpg',
    latitude: -7.2575,
    longitude: 112.7521,
    status: 'completed',
    createdAt: DateTime.utc(2026, 10, 26, 2),
    completedAt: DateTime.utc(2026, 10, 26, 5),
  ),
  ParkingSession(
    id: 'parking-4',
    userId: 'user-1',
    cityId: 'city-bandung',
    mode: 'structured',
    category: 'other',
    placeName: 'Perpustakaan',
    photoPath: '/mock/photos/parking-4.jpg',
    latitude: -6.9175,
    longitude: 107.6191,
    status: 'completed',
    createdAt: DateTime.utc(2026, 10, 25, 2),
    completedAt: DateTime.utc(2026, 10, 25, 4),
  ),
]);
