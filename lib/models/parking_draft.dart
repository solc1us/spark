class ParkingDraft {
  ParkingDraft({
    this.cityId,
    this.mode,
    this.category,
    this.mallId,
    this.placeName,
    this.areaCode,
    this.notes,
    this.photoPath,
    this.latitude,
    this.longitude,
    this.reminderMinutes,
  });

  String? cityId;
  String? mode;
  String? category;
  String? mallId;
  String? placeName;
  String? areaCode;
  String? notes;
  String? photoPath;
  double? latitude;
  double? longitude;
  int? reminderMinutes;
}
