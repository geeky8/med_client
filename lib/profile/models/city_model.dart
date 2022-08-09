class CityModel {
  CityModel({
    required this.cityName,
    required this.cityId,
    required this.stateId,
  });

  factory CityModel.fromJson({required Map<String, dynamic> json}) {
    return CityModel(
      cityName: (json['city_name'] ?? '') as String,
      cityId: (json['cityid'] ?? 0) as int,
      stateId: (json['statid'] ?? 0) as int,
    );
  }

  CityModel copyWith({String? cityName, int? cityId, int? stateId}) {
    return CityModel(
      cityName: cityName ?? this.cityName,
      cityId: cityId ?? this.cityId,
      stateId: stateId ?? this.stateId,
    );
  }

  final String cityName;
  final int cityId;
  final int stateId;
}
