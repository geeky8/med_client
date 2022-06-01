class FSSAIModel {
  FSSAIModel({
    required this.number,
    required this.numberBytes,
    required this.toFill,
  });

  FSSAIModel copyWith({
    String? number,
    List<int>? numberBytes,
    bool? toFill,
  }) {
    return FSSAIModel(
      number: number ?? this.number,
      numberBytes: numberBytes ?? this.numberBytes,
      toFill: toFill ?? this.toFill,
    );
  }

  final String number;
  final List<int> numberBytes;
  final bool toFill;
}
