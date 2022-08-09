class CountryModel {
  CountryModel({
    required this.countryName,
    required this.countryId,
  });

  factory CountryModel.fromJson({required Map<String, dynamic> json}) {
    return CountryModel(
      countryName: (json['country_name'] ?? '') as String,
      countryId: (json['countryid'] ?? 0) as int,
    );
  }

  CountryModel copyWith({String? countryName, int? countryId}) {
    return CountryModel(
      countryName: countryName ?? this.countryName,
      countryId: countryId ?? this.countryId,
    );
  }

  final String countryName;
  final int countryId;
}
