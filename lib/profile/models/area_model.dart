class AreaModel {
  AreaModel({
    required this.areaName,
    required this.areaId,
    required this.cityId,
  });

  factory AreaModel.fromJson({required Map<String, dynamic> json}) {
    return AreaModel(
      areaName: (json['area_name'] ?? '') as String,
      areaId: (json['areaid'] ?? 0) as int,
      cityId: (json['cityid'] ?? 0) as int,
    );
  }

  AreaModel copyWith({String? areaName, int? areaId, int? cityId}) {
    return AreaModel(
      areaName: areaName ?? this.areaName,
      areaId: areaId ?? this.areaId,
      cityId: cityId ?? this.cityId,
    );
  }

  final String areaName;
  final int areaId;
  final int cityId;
}
