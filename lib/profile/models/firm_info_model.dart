class FirmInfoModel {
  FirmInfoModel({
    required this.firmName,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.pin,
    required this.address,
    required this.contactName,
    required this.contactNo,
    required this.altContactNo,
    required this.state,
  });

  FirmInfoModel copyWith({
    String? firmName,
    String? email,
    String? phone,
    String? country,
    String? city,
    String? pin,
    String? address,
    String? contactName,
    String? contactNo,
    String? altContactNo,
    String? state,
  }) {
    return FirmInfoModel(
      firmName: firmName ?? this.firmName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.phone,
      city: city ?? this.city,
      pin: pin ?? this.pin,
      address: address ?? this.address,
      contactName: contactName ?? this.contactName,
      contactNo: contactNo ?? this.contactNo,
      altContactNo: altContactNo ?? this.altContactNo,
      state: state ?? this.state,
    );
  }

  final String firmName;
  final String email;
  final String phone;
  final String country;
  final String state;
  final String city;
  final String pin;
  final String address;
  final String contactName;
  final String contactNo;
  final String altContactNo;
}
