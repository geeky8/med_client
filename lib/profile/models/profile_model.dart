import 'package:medrpha_customer/profile/models/drug_license_model.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/models/fssai_model.dart';
import 'package:medrpha_customer/profile/models/gst_model.dart';

class ProfileModel {
  ProfileModel({
    required this.firmInfoModel,
    required this.gstModel,
    required this.drugLicenseModel,
    required this.fssaiModel,
  });

  factory ProfileModel.fromJson({required Map<String, dynamic> json}) {
    final firmInfoModel = FirmInfoModel.fromJson(json: json);
    final gstModel = GSTModel.fromJson(json: json);
    final drugLicenseModel = DrugLicenseModel.fromJson(json: json);
    final fssaiModel = FSSAIModel.fromJson(json: json);

    // print(_fssaiModel.fssaiImg);

    return ProfileModel(
      firmInfoModel: firmInfoModel,
      gstModel: gstModel,
      drugLicenseModel: drugLicenseModel,
      fssaiModel: fssaiModel,
    );
  }

  ProfileModel copyWith({
    FirmInfoModel? firmInfoModel,
    GSTModel? gstModel,
    DrugLicenseModel? drugLicenseModel,
    FSSAIModel? fssaiModel,
  }) {
    return ProfileModel(
      firmInfoModel: firmInfoModel ?? this.firmInfoModel,
      gstModel: gstModel ?? this.gstModel,
      drugLicenseModel: drugLicenseModel ?? this.drugLicenseModel,
      fssaiModel: fssaiModel ?? this.fssaiModel,
    );
  }

  final FirmInfoModel firmInfoModel;
  final GSTModel gstModel;
  final DrugLicenseModel drugLicenseModel;
  final FSSAIModel fssaiModel;
}
