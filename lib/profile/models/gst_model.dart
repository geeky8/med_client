class GSTModel {
  GSTModel({required this.gstNo, required this.toFill});

  factory GSTModel.fromJson({required Map<String, dynamic> json}) {
    return GSTModel(
        gstNo: (json['gstno'] ?? '') as String,
        toFill: (json['gstnoyesno'] ?? '') == '1' ? false : true);
  }

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
