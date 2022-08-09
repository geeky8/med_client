class StateModel {
  StateModel({
    required this.stateName,
    required this.stateId,
    required this.countryId,
  });

  factory StateModel.fromJson({required Map<String, dynamic> json}) {
    return StateModel(
      stateName: (json['state_name'] ?? '') as String,
      stateId: (json['stateid'] ?? 0) as int,
      countryId: (json['countid'] ?? 0) as int,
    );
  }

  StateModel copyWith({String? stateName, int? stateId, int? countryId}) {
    return StateModel(
      stateName: stateName ?? this.stateName,
      stateId: stateId ?? this.stateId,
      countryId: countryId ?? this.countryId,
    );
  }

  final String stateName;
  final int stateId;
  final int countryId;
}
