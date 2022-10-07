import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medrpha_customer/signup_login/models/otp_model.dart';

class LoginRepository {
  //TODO: Change APIS from Prod to Test.

  /// [getOTPUrl] URL for fetching OTP.
  // final getOTPUrl = 'https://api.medrpha.com/api/Default/sendotp';
  final getOTPUrl = 'https://apitest.medrpha.com/api/Default/sendotp';

  /// [checkOTPUrl] URL for checking OTP.
  // final checkOTPUrl = 'https://api.medrpha.com/api/Default/otpverify';
  final checkOTPUrl = 'https://apitest.medrpha.com/api/Default/otpverify';

  // final checkStatus = 'https://api.medrpha.com/api/Default/userstatus';
  final checkStatus = 'https://apitest.medrpha.com/api/Default/userstatus';

  /// [httpClient] to use HTTP methods
  final httpClient = http.Client();

  /// function to trigger OTP [getOTP]
  Future<String> getOTP({required String mobile}) async {
    final body = {
      'contact': mobile,
    };

    final resp = await httpClient.post(
      Uri.parse(getOTPUrl),
      body: body,
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      // print(respBody);
      return respBody['status'] as String;
    } else {
      // print('error');
      return 'error';
    }
  }

  /// Get current user status
  Future<OTPModel> getUserStatus({required OTPModel model}) async {
    final body = {"sessid": model.sessId};
    final resp = await httpClient.post(Uri.parse(checkStatus), body: body);
    if (kDebugMode) {
      print(model.sessId);
    }
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      // print(respBody);
      final status = respBody['status'];
      // print(respBody);
      if (status == '1') {
        final data = respBody['data'] as Map<String, dynamic>;
        // print(((data['complete_reg_status'] as String) == 'False'));
        // print('adminStatus : ${(data['adminstatus'] as String)}');
        final otpModel = model.copyWith(
          // sessId: model.sessId,
          adminStatus:
              ((data['adminstatus'] as String) == 'False') ? false : true,
          completedStatus: ((data['complete_reg_status'] as String) == 'False')
              ? false
              : true,
          payLater: ((data['paylater'] as String) == '1') ? true : false,
        );
        // print(otpModel.completedStatus);
        return otpModel;
      } else {
        return model;
      }
    } else {
      return model;
    }
  }

  /// Function to verify the OTP and store the info in [OTPModel]
  Future<OTPModel> checkOTP(
      {required String phone, required String otp}) async {
    // print(otp);
    // print(phone);
    final body = {
      'contact': phone,
      'otp': otp,
    };

    final resp = await httpClient.post(Uri.parse(checkOTPUrl), body: body);
    // print(resp.body.toString());
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      final status = respBody['status'] as String;
      if (status == '1') {
        final data = respBody['data'] as Map<String, dynamic>;
        // print(data.toString());
        final model = OTPModel.fromJson(json: data);
        return model;
      } else {
        return OTPModel(
          sessId: '',
          adminStatus: false,
          completedStatus: false,
          payLater: false,
        );
      }
    } else {
      return OTPModel(
        sessId: '',
        adminStatus: false,
        completedStatus: false,
        payLater: false,
      );
    }
  }
}

/// Admin Login

// {
//     "status": "1",
//     "message": "Successfull !!",
//     "data": {
//         "sessID": "7a527cf1acee9cd6",
//         "complete_reg_status": "False",
//         "adminstatus": "False",
//         "paylater": "0"
//     }
// }

/// Test Login

// {
//     "status": "1",
//     "message": "Successfull !!",
//     "data": {
//         "sessID": "34c4efad30e6e2d4",
//         "complete_reg_status": "True",
//         "adminstatus": "True",
//         "paylater": "0"
//     }
// }
