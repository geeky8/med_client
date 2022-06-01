class GSTModel {
  GSTModel({required this.gstNo, required this.toFill});

  GSTModel copyWith({
    String? gstNo,
    bool? toFill,
  }) {
    return GSTModel(
      gstNo: gstNo ?? this.gstNo,
      toFill: toFill ?? this.toFill,
    );
  }

  final String gstNo;
  final bool toFill;
}
