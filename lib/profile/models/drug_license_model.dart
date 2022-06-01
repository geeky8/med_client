class DrugLicenseModel {
  DrugLicenseModel({
    required this.name,
    required this.number,
    required this.validity,
    required this.license1Bytes,
    required this.license2Bytes,
    required this.toFill,
  });

  DrugLicenseModel copyWith({
    String? name,
    String? number,
    String? validity,
    List<int>? license1Bytes,
    List<int>? license2Bytes,
    bool? toFill,
  }) {
    return DrugLicenseModel(
      name: name ?? this.name,
      number: number ?? this.number,
      validity: validity ?? this.validity,
      license1Bytes: license1Bytes ?? this.license1Bytes,
      license2Bytes: license2Bytes ?? this.license2Bytes,
      toFill: toFill ?? this.toFill,
    );
  }

  final String name;
  final String number;
  final String validity;
  final List<int> license1Bytes;
  final List<int> license2Bytes;
  final bool toFill;
}
