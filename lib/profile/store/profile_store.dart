// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/profile/models/area_model.dart';
import 'package:medrpha_customer/profile/models/city_model.dart';
import 'package:medrpha_customer/profile/models/country_model.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/models/state_model.dart';
import 'package:medrpha_customer/profile/repository/profile_repository.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';
import 'dart:collection';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final _repository = ProfileRepository();

  @observable
  int page = 0;

  @observable
  ButtonState saveState = ButtonState.SUCCESS;

  @observable
  StoreState certi1 = StoreState.SUCCESS;

  @observable
  StoreState certi2 = StoreState.SUCCESS;

  @observable
  ObservableList<CountryModel> countryList =
      ObservableList<CountryModel>.of([]);

  @observable
  ObservableList<StateModel> stateList = ObservableList<StateModel>.of([]);

  @observable
  ObservableList<CityModel> cityList = ObservableList<CityModel>.of([]);

  @observable
  ObservableList<AreaModel> areaList = ObservableList<AreaModel>.of([]);

  @observable
  ProfileModel profileModel = ProfileModel(
    firmInfoModel: ConstantData().initFirmInfoModel,
    gstModel: ConstantData().initGstModel,
    drugLicenseModel: ConstantData().initDrugLicenseModel,
    fssaiModel: ConstantData().initFssaiModel,
  );

  @action
  Future<void> init() async {
    await _getDropDownLists();
    await getProfile();
  }

  @action
  Future<void> getProfile() async {
    final model = await _repository.getProfile();
    profileModel = model;
    final dataBox = DataBox();
    dataBox.writeFirmName(name: profileModel.firmInfoModel.firmName);
  }

  Future<void> _getDropDownLists() async {
    final countries = await _repository.getCountries();
    if (countries.isNotEmpty) {
      countryList
        ..clear()
        ..addAll(countries);
    }
    // print(_countries);

    final states = await _repository.getState();
    if (states.isNotEmpty) {
      stateList
        ..clear()
        ..addAll(states);
    }

    final cites = await _repository.getCity();
    if (cites.isNotEmpty) {
      cityList
        ..clear()
        ..addAll(cites);
    }

    final areas = await _repository.getArea();
    if (areas.isNotEmpty) {
      areaList
        ..clear()
        ..addAll(areas);
    }
  }

  @observable
  StoreState areaFetching = StoreState.SUCCESS;

  @observable
  StoreState cityFetching = StoreState.SUCCESS;

  @action
  Future<void> getAreaCitySpecific({String? id}) async {
    areaFetching = StoreState.LOADING;

    final list = await _repository.getArea(id: id);
    if (areaList.isNotEmpty) {
      areaList
        ..clear()
        ..addAll(list);
    }
    areaFetching = StoreState.SUCCESS;
  }

  @action
  Future<void> getStateCitySpecific({String? id}) async {
    cityFetching = StoreState.LOADING;

    final list = await _repository.getCity(stateId: id);
    if (areaList.isNotEmpty) {
      cityList
        ..clear()
        ..addAll(list);
    }
    cityFetching = StoreState.SUCCESS;
  }

  String getCountry({required int countryId}) {
    final index =
        countryList.indexWhere((element) => element.countryId == countryId);
    if (index != -1) {
      return countryList[index].countryName;
    }
    return '';
  }

  String getState({required int stateId}) {
    final index = stateList.indexWhere((element) => element.stateId == stateId);
    if (index != -1) {
      return stateList[index].stateName;
    }
    return '';
  }

  String getCityName({required int cityId}) {
    final index = cityList.indexWhere((element) => element.cityId == cityId);
    if (index != -1) {
      return cityList[index].cityName;
    }
    return '';
  }

  String getArea({required int areaId}) {
    final index = areaList.indexWhere((element) => element.areaId == areaId);
    if (index != -1) {
      return areaList[index].areaName;
    }
    return '';
  }

  Future<XFile?> takeCertificate({required ImageSource source}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    return image;
  }

  @action
  void updateLists({required int code, required int nameCode}) {
    switch (code) {
      case 0:
        final list = <StateModel>[];
        for (final model in stateList) {
          if (model.countryId == nameCode) {
            list.add(model);
          }
        }
        stateList
          ..clear()
          ..addAll(list);
        break;
      case 1:
        final list = <CityModel>[];
        for (final model in cityList) {
          if (model.stateId == nameCode) {
            list.add(model);
          }
        }
        cityList
          ..clear()
          ..addAll(list);
        break;
      case 2:
        final list = <AreaModel>[];
        for (final model in areaList) {
          if (model.cityId == nameCode) {
            list.add(model);
          }
        }
        areaList
          ..clear()
          ..addAll(list);
        break;
    }
  }

  @observable
  StoreState certificateUploadingState = StoreState.SUCCESS;

  @action
  Future<void> saveCertificate({
    required String path,
    required List<int> bytes,
    required String url,
    // required BuildContext context,
  }) async {
    // certificateUploadingState = StoreState.LOADING;

    final sessId = await DataBox().readSessId();

    /// Updating the licenses
    final s = await _repository.uploadPhoto(
      sessId: sessId,
      bytes: bytes,
      path: path,
      url: url,
    );

    /// Fetching updated data
    final model = await _repository.getProfile();

    /// Updating DL and FSAAI
    profileModel = profileModel.copyWith(
      drugLicenseModel: profileModel.drugLicenseModel.copyWith(
        dlImg1: model.drugLicenseModel.dlImg1,
        dlImg2: model.drugLicenseModel.dlImg2,
      ),
      fssaiModel:
          profileModel.fssaiModel.copyWith(fssaiImg: model.fssaiModel.fssaiImg),
    );

    /// Responses
    if (s == '1') {
      Fluttertoast.showToast(msg: 'License Uploaded Successfully');
    } else {
      Fluttertoast.showToast(msg: 'Failed to upload License');
    }
  }

  @action
  Future<void> updateProfile({
    required BuildContext context,
    bool? beginToFill,
    required LoginStore loginStore,
  }) async {
    /// Fetch the required session id from local storage
    final sessId = await DataBox().readSessId();

    /// To check whether GST details are filled or not
    final gstToFIll = profileModel.gstModel.toFill;

    /// To check whether FSSAI details are filled or not
    final fssaiToFill = profileModel.fssaiModel.toFill;

    saveState = ButtonState.LOADING;

    /// Uploading Firm data
    final firmInfoModel = profileModel.firmInfoModel;
    final respFirmInfo = await _repository.uploadProfile(
      sessId: sessId,
      model: firmInfoModel,
    );

    /// Uploading Drug License data.
    final drugLicenseModel = profileModel.drugLicenseModel;
    final respDrugLicense = await _repository.uploadDrugLicenseDetails(
      sessId: sessId,
      model: drugLicenseModel,
    );

    /// Uploading GST data
    String respGST = '';
    if (gstToFIll && profileModel.gstModel.gstNo.isNotEmpty) {
      final gstModel = profileModel.gstModel;
      respGST = await _repository.uploadGSTDetails(
        sessId: sessId,
        model: gstModel,
      );
      // saveState = ButtonState.ERROR;
    } else {
      //TODO: Update the URL's
      const url = 'https://api.medrpha.com/api/register/registergstnodelete';
      // const url =
      // 'https://apitest.medrpha.com/api/register/registergstnodelete';

      debugPrint('---- delteting GST');

      final resp = await _repository.deleteLicenses(
        url: url,
      );
      // if (!resp == null) {
      //   Fluttertoast.showToast(msg: 'Failed to delete GST');
      // }
    }

    /// Uploading FSSAI data.
    String respFSSAI = '';
    if (fssaiToFill) {
      final fssaiModel = profileModel.fssaiModel;
      respFSSAI = await _repository.uploadFSSAIDetails(
        sessId: sessId,
        model: fssaiModel,
      );
    } else {
      //TODO: Update the URL's
      const url = 'https://api.medrpha.com/api/register/registerfssaidelete';
      // const url =
      //     'https://apitest.medrpha.com/api/register/registerfssaidelete';
      debugPrint('---- delteting FSSAI');

      final resp = await _repository.deleteLicenses(
        url: url,
      );
      // if (resp == null) {
      //   Fluttertoast.showToast(msg: 'Failed to delete FSSAI');
      // }
    }

    if (respFirmInfo == '0') {
      Fluttertoast.showToast(msg: 'Failed to upload FIRM DETAILS');
    }
    if (respDrugLicense == '0') {
      Fluttertoast.showToast(msg: 'Failed to upload DRUG LICENSE DETAILS');
    }
    if (respGST != '0' && gstToFIll) {
      Fluttertoast.showToast(msg: 'Failed to upload GST DETAILS');
    }
    if (respFSSAI != '0' && fssaiToFill) {
      Fluttertoast.showToast(msg: 'Failed to upload FSSAI DETAILS');
    }
    if (respFirmInfo != '0' &&
        respDrugLicense != '0' &&
        respGST != '0' &&
        respFSSAI != '0') {
      page = 0;
      await loginStore.getUserStatus();
      Fluttertoast.showToast(msg: 'Profile Detials Updated Successfully');
      // Navigator.pop(context);
    }
    saveState = ButtonState.SUCCESS;
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
