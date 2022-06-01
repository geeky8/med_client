import 'dart:convert';

import 'package:medrpha_customer/profile/models/drug_license_model.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/models/fssai_model.dart';
import 'package:medrpha_customer/profile/models/gst_model.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  /// For Customer Profile
  final _uploadProfileUrl = 'https://api.medrpha.com/api/register/register';

  /// For Customer Drug License Details.
  final _uploadDLUrl = 'https://apitest.medrpha.com/api/register/registerdlno';
  // final _uploadDLImage1 = 'https://medrpha.com/api/register/registerdl1';
  // final _uploadDLImage2 = 'https://medrpha.com/api/register/registerdl2';

  /// For Customer GST Details.
  final _uploadGSTUrl =
      'https://apitest.medrpha.com/api/register/registergstno';

  /// FOr Customer FSSAI Details.
  // final _uploadFSSAIUrl =
  //     'https://apitest.medrpha.com/api/register/registerfssai';
  // final _uploadFSSAImageUrl =
  //     'https://test.medrpha.com/api/register/registerfssaiimg';

  final httpClient = http.Client();

  Future<String> uploadProfile(
      {required String sessId, required FirmInfoModel model}) async {
    final _body = {
      "sessid": sessId,
      "firm_name": model.firmName,
      "txtemail": model.email,
      "countryid": '1',
      "stateid": '1',
      "phoneno": model.phone,
      "cityid": '1',
      "Areaid": '1',
      "address": model.address,
      "PersonName": model.contactName,
      "PersonNumber": model.contactNo,
      "AlternateNumber": model.altContactNo,
    };

    final resp =
        await httpClient.post(Uri.parse(_uploadProfileUrl), body: _body);
    print(resp.body);
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      print(respBody);
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
    final _body = {
      "sessid": sessId,
      "gstno": model.gstNo,
    };

    final resp = await httpClient.post(Uri.parse(_uploadGSTUrl), body: _body);
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
    final _body = {
      "sessid": sessId,
      "txtdlno": model.number,
      "valid": model.name,
      "txtdlname": model.validity,
    };

    final resp = await httpClient.post(Uri.parse(_uploadDLUrl), body: _body);
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

  Future<String> uploadFSSAIDetails(
      {required String sessId, required FSSAIModel model}) async {
    final _body = {
      "sessid": sessId,
      "fssaiNo": model.number,
    };

    final resp = await httpClient.post(Uri.parse(_uploadGSTUrl), body: _body);
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
    final body = {
      "sessid": sessId,
    };
    final headers = {
      'content-type': 'multipart/form-data',
      'Accept': 'application/json',
    };
    final file = await http.MultipartFile.fromPath('file', path);
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(body)
      ..files.add(file)
      ..headers.addAll(headers);
    final respStream = await request.send();
    final resp = await http.Response.fromStream(respStream);
    if (resp.statusCode == 200) {
      return '1';
    } else {
      // final output = await resp.stream.bytesToString();
      return '0';
    }
  }
}
