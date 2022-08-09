class FSSAIModel {
  FSSAIModel({
    required this.number,
    required this.numberBytes,
    required this.fssaiImg,
    required this.toFill,
  });

  factory FSSAIModel.fromJson({required Map<String, dynamic> json}) {
    // print(json['pic3']);
    return FSSAIModel(
      number: (json['fssaiNo'] ?? '') as String,
      fssaiImg: (json['pic3'] ?? '') as String,
      toFill: (json['hdnFSSAI'] ?? '') == '1' ? false : true,
      numberBytes: [],
    );
  }

  FSSAIModel copyWith({
    String? number,
    List<int>? numberBytes,
    bool? toFill,
    String? fssaiImg,
  }) {
    return FSSAIModel(
      number: number ?? this.number,
      numberBytes: numberBytes ?? this.numberBytes,
      toFill: toFill ?? this.toFill,
      fssaiImg: fssaiImg ?? this.fssaiImg,
    );
  }

  final String number;
  final List<int> numberBytes;
  final String fssaiImg;
  final bool toFill;
}
