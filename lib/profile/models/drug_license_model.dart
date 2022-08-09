class DrugLicenseModel {
  DrugLicenseModel({
    required this.name,
    required this.number,
    required this.validity,
    required this.license1Bytes,
    required this.license2Bytes,
    required this.toFill,
    required this.dlImg1,
    required this.dlImg2,
  });

  factory DrugLicenseModel.fromJson({required Map<String, dynamic> json}) {
    return DrugLicenseModel(
      name: (json['txtdlname'] ?? '') as String,
      number: (json['txtdlno'] ?? '') as String,
      validity: (json['valid'] ?? '') as String,
      dlImg1: (json['dl1'] ?? '') as String,
      dlImg2: (json['dl2'] ?? '') as String,
      toFill: (json['hdnDrugsyesno'] ?? '') == '1' ? false : true,
      license1Bytes: [],
      license2Bytes: [],
    );
  }

  DrugLicenseModel copyWith({
    String? name,
    String? number,
    String? validity,
    List<int>? license1Bytes,
    List<int>? license2Bytes,
    bool? toFill,
    String? dlImg1,
    String? dlImg2,
  }) {
    return DrugLicenseModel(
      name: name ?? this.name,
      number: number ?? this.number,
      validity: validity ?? this.validity,
      license1Bytes: license1Bytes ?? this.license1Bytes,
      license2Bytes: license2Bytes ?? this.license2Bytes,
      toFill: toFill ?? this.toFill,
      dlImg1: dlImg1 ?? this.dlImg1,
      dlImg2: dlImg2 ?? this.dlImg2,
    );
  }

  final String name;
  final String number;
  final String validity;
  final String dlImg1;
  final String dlImg2;
  final List<int> license1Bytes;
  final List<int> license2Bytes;
  final bool toFill;
}
