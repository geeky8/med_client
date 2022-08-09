import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:medrpha_customer/profile/models/area_model.dart';
import 'package:medrpha_customer/profile/models/city_model.dart';
import 'package:medrpha_customer/profile/models/country_model.dart';
import 'package:medrpha_customer/profile/models/drug_license_model.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/models/fssai_model.dart';
import 'package:medrpha_customer/profile/models/gst_model.dart';
import 'package:http/http.dart' as http;
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/models/state_model.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/storage.dart';

class ProfileRepository {
  /// Get Profile
  final _getProfileUrl = 'https://apitest.medrpha.com/api/profile/getprofile';

  /// For Customer Profile
  final _uploadProfileUrl = 'https://apitest.medrpha.com/api/register/register';

  /// For Customer Drug License Details.
  final _uploadDLUrl = 'https://apitest.medrpha.com/api/register/registerdlno';
  // final _uploadDLImage1 = 'https://medrpha.com/api/register/registerdl1';
  // final _uploadDLImage2 = 'https://medrpha.com/api/register/registerdl2';

  /// For Customer GST Details.
  final _uploadGSTUrl =
      'https://apitest.medrpha.com/api/register/registergstno';

  final _countryUrl = 'https://apitest.medrpha.com/api/register/getcountryall';
  final _stateUrl = 'https://apitest.medrpha.com/api/register/getstateall';
  final _cityUrl = 'https://apitest.medrpha.com/api/register/getcityall';

  final _uploadFssaiUrl =
      'https://apitest.medrpha.com/api/register/registerfssai';

  /// FOr Customer FSSAI Details.
  // final _uploadFSSAIUrl =
  //     'https://apitest.medrpha.com/api/register/registerfssai';
  // final _uploadFSSAImageUrl =
  //     'https://test.medrpha.com/api/register/registerfssaiimg';

  final httpClient = http.Client();

  Future<int?> deleteLicenses({required String url}) async {
    final sessId = await DataBox().readSessId();
    final body = {"sessid": sessId};

    final resp = await httpClient.post(Uri.parse(url), body: body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode((resp.body)) as Map<String, dynamic>;
      if (respBody['message'] == 'successful !!') {
        if (kDebugMode) {
          print('deleted');
        }
        return 1;
      }
    }
    return null;
  }

  Future<List<CountryModel>> getCountries() async {
    final sessId = await DataBox().readSessId();

    final body = {"sessid": sessId};

    final countryList = <CountryModel>[];

    final resp = await httpClient.post(Uri.parse(_countryUrl), body: body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          final model = CountryModel.fromJson(json: i as Map<String, dynamic>);
          list.add(model);
        }
      }
    }
    countryList.add(CountryModel(countryName: 'India', countryId: 1));
    return countryList;
  }

  Future<List<StateModel>> getState() async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
    };

    final stateList = <StateModel>[];

    final resp = await httpClient.post(Uri.parse(_stateUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          final model = StateModel.fromJson(json: i as Map<String, dynamic>);
          stateList.add(model);
        }
      }
    }
    return stateList;
  }

  Future<List<CityModel>> getCity() async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
    };

    final cityList = <CityModel>[];

    final resp = await httpClient.post(Uri.parse(_cityUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          final model = CityModel.fromJson(json: i as Map<String, dynamic>);
          cityList.add(model);
        }
      }
    }
    return cityList;
  }

  Future<List<AreaModel>> getArea({String? id}) async {
    final sessId = await DataBox().readSessId();
    String areaUrl = 'https://apitest.medrpha.com/api/register/getpincodeall';
    Map<String, dynamic> body = {
      "sessid": sessId,
    };

    if (id != null) {
      areaUrl = 'https://apitest.medrpha.com/api/register/getpincode';
      body = {"sessid": sessId, 'cityid': id};
    }

    final areaList = <AreaModel>[];

    final resp = await httpClient.post(Uri.parse(areaUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (kDebugMode) {
        print('---------${resp.body}');
      }
      if (respBody['status'] == '1') {
        final respList = respBody['data'] as List<dynamic>;
        for (final i in respList) {
          final model = AreaModel.fromJson(json: i as Map<String, dynamic>);
          areaList.add(model);
        }
      }
    }
    return areaList;
  }

  Future<String> uploadProfile(
      {required String sessId, required FirmInfoModel model}) async {
    final body = {
      "sessid": sessId,
      "firm_name": model.firmName,
      "txtemail": model.email,
      "countryid": model.country,
      "stateid": model.state,
      "phoneno": model.phone,
      "cityid": model.city,
      "Areaid": model.pin,
      "address": model.address,
      "PersonName": model.contactName,
      "PersonNumber": model.contactNo,
      "AlternateNumber": model.altContactNo,
    };

    final resp =
        await httpClient.post(Uri.parse(_uploadProfileUrl), body: body);
    if (kDebugMode) {
      print(resp.body);
    }
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (kDebugMode) {
        print(respBody);
      }
      if (respBody['status'] == '0' || respBody['status'] == null) {
        return '0';
      } else {
        return '1';
      }
    } else {
      return '0';
    }
  }

  Future<String> uploadGSTDetails(
      {required String sessId, required GSTModel model}) async {
    final body = {
      "sessid": sessId,
      "gstno": model.gstNo,
    };

    final resp = await httpClient.post(Uri.parse(_uploadGSTUrl), body: body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '0' || respBody['status'] == null) {
        return '0';
      } else {
        return '1';
      }
    } else {
      return '0';
    }
  }

  Future<String> uploadDrugLicenseDetails(
      {required String sessId, required DrugLicenseModel model}) async {
    final body = {
      "sessid": sessId,
      "txtdlno": model.number,
      "valid": model.validity,
      "txtdlname": model.name,
    };

    final resp = await httpClient.post(Uri.parse(_uploadDLUrl), body: body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (kDebugMode) {
        print(respBody);
      }
      if (respBody['status'] == '0' || respBody['status'] == null) {
        return '0';
      } else {
        return '1';
      }
    } else {
      return '0';
    }
  }

  Future<String> uploadFSSAIDetails(
      {required String sessId, required FSSAIModel model}) async {
    final body = {
      "sessid": sessId,
      "fssaiNo": model.number,
    };

    final resp = await httpClient.post(Uri.parse(_uploadFssaiUrl), body: body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '0' || respBody['status'] == null) {
        return '0';
      } else {
        return '1';
      }
    } else {
      return '0';
    }
  }

  Future<String> uploadPhoto({
    required String sessId,
    required List<int> bytes,
    required String path,
    required String url,
  }) async {
    final body = {"sessid": sessId};
    // final headers = {
    //   'content-type': 'multipart/form-data',
    //   'Accept': 'application/json',
    // };
    final file = await http.MultipartFile.fromPath('image', path);
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(body)
      ..files.add(file);
    // ..headers.addAll(headers);
    final respStream = await request.send();
    // print(object)
    final resp = await http.Response.fromStream(respStream);
    if (resp.statusCode == 200) {
      // print(resp.body);
      return '1';
    } else {
      // final output = await resp.stream.bytesToString();
      return '0';
    }
  }

  Future<ProfileModel> getProfile() async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
    };

    ProfileModel profileModel = ProfileModel(
      firmInfoModel: ConstantData().initFirmInfoModel,
      gstModel: ConstantData().initGstModel,
      drugLicenseModel: ConstantData().initDrugLicenseModel,
      fssaiModel: ConstantData().initFssaiModel,
    );

    final resp = await httpClient.post(Uri.parse(_getProfileUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        if (kDebugMode) {
          print(resp.body);
        }
        final json = respBody['data'] as Map<String, dynamic>;
        profileModel = ProfileModel.fromJson(json: json);
      }
    }
    return profileModel;
  }
}
