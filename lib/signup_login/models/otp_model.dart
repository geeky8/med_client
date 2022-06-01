/// [OTPModel] to store login/session data
class OTPModel {
  OTPModel({
    required this.sessId,
    required this.adminStatus,
    required this.completedStatus,
  });

  factory OTPModel.fromJson({required Map<String, dynamic> json}) {
    return OTPModel(
      sessId: json['sessID'] as String,
      adminStatus: ((json['adminstatus'] as String) == 'False') ? false : true,
      completedStatus:
          ((json['complete_reg_status'] as String) == 'False') ? false : true,
    );
  }

  OTPModel copyWith({
    String? sessId,
    bool? adminStatus,
    bool? completedStatus,
  }) {
    return OTPModel(
      sessId: sessId ?? this.sessId,
      adminStatus: adminStatus ?? this.adminStatus,
      completedStatus: completedStatus ?? this.completedStatus,
    );
  }

  Map<String, String> toMap() {
    return {
      'adminStatus': adminStatus.toString(),
      'completedStatus': completedStatus.toString(),
    };
  }

  /// To store [sessId] of the user.
  final String sessId;

  /// To store [adminStatus] of the user.
  final bool adminStatus;

  /// To store [completedStatus] of the user
  final bool completedStatus;
}
