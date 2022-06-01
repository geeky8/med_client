import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/repository/profile_repository.dart';
import 'package:medrpha_customer/test_screen.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final _repository = ProfileRepository();

  @observable
  int page = 0;

  @observable
  ButtonState saveState = ButtonState.SUCCESS;

  @observable
  ProfileModel profileModel = ProfileModel(
    firmInfoModel: ConstantData().initFirmInfoModel,
    gstModel: ConstantData().initGstModel,
    drugLicenseModel: ConstantData().initDrugLicenseModel,
    fssaiModel: ConstantData().initFssaiModel,
  );

  Future<XFile?> takeCertificate({required ImageSource source}) async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: source);
    return image;
  }

  @action
  Future<void> saveCertificate({
    required String path,
    required List<int> bytes,
    required String url,
  }) async {
    final _sessId = await DataBox().readSessId();
    final s = await _repository.uploadPhoto(
        sessId: _sessId, bytes: bytes, path: path, url: url);
    // print(s);
  }

  @action
  Future<void> updateProfile({required BuildContext context}) async {
    final _sessId = await DataBox().readSessId();
    final gstToFIll = profileModel.gstModel.toFill;
    final dlToFill = profileModel.drugLicenseModel.toFill;
    final fssaiToFill = profileModel.fssaiModel.toFill;

    saveState = ButtonState.LOADING;

    /// Uploading [FirmInfoModel] data
    final _firmInfoModel = profileModel.firmInfoModel;
    final _respFirmInfo = await _repository.uploadProfile(
      sessId: _sessId,
      model: _firmInfoModel,
    );

    /// Uploading [GSTModel] data
    if (gstToFIll) {
      final _gstModel = profileModel.gstModel;
      final _respGST = await _repository.uploadGSTDetails(
        sessId: _sessId,
        model: _gstModel,
      );
      saveState = ButtonState.ERROR;
    }

    /// Uploading [DrugLicenseModel] data.
    if (dlToFill) {
      final _drugLicenseModel = profileModel.drugLicenseModel;
      final _respDrugLicense = await _repository.uploadDrugLicenseDetails(
        sessId: _sessId,
        model: _drugLicenseModel,
      );
      saveState = ButtonState.ERROR;
    }

    /// Uploading [FSSAIModel] data.
    if (fssaiToFill) {
      final _fssaiModel = profileModel.fssaiModel;
      final _respFSSAI = await _repository.uploadFSSAIDetails(
        sessId: _sessId,
        model: _fssaiModel,
      );
      saveState = ButtonState.ERROR;
    }

    if (_respFirmInfo == '0' || saveState == ButtonState.ERROR) {
      saveState = ButtonState.ERROR;
      final _snackBar = ConstantWidget.customSnackBar(
          text: 'Error, Please try again', context: context);
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    } else {
      saveState = ButtonState.SUCCESS;
      final _snackBar = ConstantWidget.customSnackBar(
          text: 'Success, profile updated', context: context);
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const TestScreen()));
    }
  }

  // @action
  // void increment() {
  //   page += 1;
  // }

  // @action
  // void decrement() {
  //   page -= 1;
  // }
}
