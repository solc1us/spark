class ParkingSession {
  const ParkingSession({
    required this.id,
    required this.userId,
    required this.cityId,
    required this.mode,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.category,
    this.mallId,
    this.placeName,
    this.areaCode,
    this.notes,
    this.reminderMinutes,
    this.status = 'active',
    this.completedAt,
  });

  final String id;
  final String userId;
  final String cityId;
  final String mode;
  final String? category;
  final String? mallId;
  final String? placeName;
  final String? areaCode;
  final String? notes;
  final String photoPath;
  final double latitude;
  final double longitude;
  final int? reminderMinutes;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  ParkingSession copyWith({String? status, DateTime? completedAt}) {
    return ParkingSession(
      id: id,
      userId: userId,
      cityId: cityId,
      mode: mode,
      category: category,
      mallId: mallId,
      placeName: placeName,
      areaCode: areaCode,
      notes: notes,
      photoPath: photoPath,
      latitude: latitude,
      longitude: longitude,
      reminderMinutes: reminderMinutes,
      status: status ?? this.status,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
