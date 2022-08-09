import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/signup_login/models/otp_model.dart';
import 'package:medrpha_customer/signup_login/repository/login_repository.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final _repository = LoginRepository();
  // final _storage = LocalStorage();

  final _dataBox = DataBox();

  /// Getting session ID of the current User.
  @observable
  OTPModel loginModel = OTPModel(
    sessId: '',
    adminStatus: false,
    completedStatus: false,
    payLater: false,
  );

  /// [ButtonState] for change in state of the button on click
  @observable
  ButtonState buttonState = ButtonState.SUCCESS;

  @action
  Future<void> init() async {
    final _sessId = await DataBox().readSessId();
    final _adminStatus = await DataBox().readAdminStatus();
    final _completedStatus = await DataBox().readCompletionStatus();
    final _payLater = await DataBox().readPayLate();

    loginModel = OTPModel(
      sessId: _sessId,
      adminStatus: _adminStatus,
      completedStatus: _completedStatus,
      payLater: _payLater,
    );
  }

  Future<void> getUserStatus() async {
    // buttonState = ButtonState.LOADING;
    final model = await _repository.getUserStatus(model: loginModel);
    // print(model.completedStatus);
    // print(model.adminStatus);
    loginModel = model;
    // print('PayLater: ${model.payLater}');
    await DataBox().writeSessId(sessId: loginModel.sessId);
    await DataBox().writeAdminStatus(status: loginModel.adminStatus);
    await DataBox().writeCompletionStatus(status: loginModel.completedStatus);
    await DataBox().writePayLater(paylater: loginModel.payLater);
    // buttonState = ButtonState.SUCCESS;
  }

  ///
  Future<void> getOTP({
    required String mobile,
    required BuildContext context,
  }) async {
    buttonState = ButtonState.LOADING;
    final resp = await _repository.getOTP(
      mobile: mobile,
    );
    // print('parth');
    SnackBar _snackBar;
    if (resp != 'error') {
      _snackBar =
          ConstantWidget.customSnackBar(text: 'OTP sent', context: context);
      buttonState = ButtonState.SUCCESS;
    } else {
      _snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to send OTP', context: context);
      buttonState = ButtonState.ERROR;
    }
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  Future<int> verifyOTP({required String mobile, required String otp}) async {
    buttonState = ButtonState.LOADING;
    final model = await _repository.checkOTP(phone: mobile, otp: otp);
    // print(model.sessId);
    if (model.sessId != '') {
      /// update the session Id
      await _dataBox.writeSessId(sessId: model.sessId);

      /// Update the admin status
      if (model.adminStatus) {
        await _dataBox.writeAdminStatus(status: true);
      } else {
        await _dataBox.writeAdminStatus(status: false);
      }

      /// Update the Completion Status
      if (model.completedStatus) {
        await _dataBox.writeCompletionStatus(status: true);
      } else {
        await _dataBox.writeCompletionStatus(status: false);
      }
      loginModel = loginModel.copyWith(sessId: model.sessId);
      await _dataBox.writePhoneNo(phone: mobile);
      buttonState = ButtonState.SUCCESS;
      return 1;
    } else {
      buttonState = ButtonState.ERROR;
      return 0;
    }
  }
}
