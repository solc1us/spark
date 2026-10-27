import 'package:flutter_test/flutter_test.dart';
import 'package:spark/data/mock_data.dart';

void main() {
  test(
    'mock data has consistent IDs, city/mall relations and session status',
    () {
      expect(mockUsers.map((user) => user.id).toSet().length, mockUsers.length);
      expect(mockCities.length, greaterThanOrEqualTo(3));
      expect(
        mockCities.map((city) => city.id).toSet().length,
        mockCities.length,
      );
      expect(mockMalls.map((mall) => mall.id).toSet().length, mockMalls.length);
      for (final city in mockCities) {
        expect(
          mockMalls.where((mall) => mall.cityId == city.id).length,
          greaterThanOrEqualTo(2),
        );
      }
      for (final mall in mockMalls) {
        expect(mockCities.any((city) => city.id == mall.cityId), isTrue);
      }
      expect(
        mockParkingSessions.map((session) => session.id).toSet().length,
        mockParkingSessions.length,
      );
      expect(mockParkingSessions.any((s) => s.status == 'active'), isTrue);
      expect(mockParkingSessions.any((s) => s.status == 'completed'), isTrue);
      for (final session in mockParkingSessions) {
        expect(mockUsers.any((user) => user.id == session.userId), isTrue);
        expect(mockCities.any((city) => city.id == session.cityId), isTrue);
        if (session.mallId != null) {
          final mall = mockMalls.firstWhere(
            (mall) => mall.id == session.mallId,
          );
          expect(mall.cityId, session.cityId);
        }
        expect(session.completedAt != null, session.status == 'completed');
      }
    },
  );
}
