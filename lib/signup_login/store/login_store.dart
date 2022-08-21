// ignore_for_file: use_build_context_synchronously, unnecessary_import, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/screens/profile_screen.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/models/otp_model.dart';
import 'package:medrpha_customer/signup_login/repository/login_repository.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

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
    final sessId = await DataBox().readSessId();
    final adminStatus = await DataBox().readAdminStatus();
    final completedStatus = await DataBox().readCompletionStatus();
    final payLater = await DataBox().readPayLate();

    loginModel = OTPModel(
      sessId: sessId,
      adminStatus: adminStatus,
      completedStatus: completedStatus,
      payLater: payLater,
    );
  }

  @action
  Future<void> login({
    required String value,
    required BuildContext context,
    required ProductsStore productsStore,
    required LoginStore loginStore,
    required ProfileStore profileStore,
    required BottomNavigationStore bottomNavigationStore,
    required OrderHistoryStore orderHistoryStore,
  }) async {
    // buttonState = ButtonState.LOADING;
    final pin = await DataBox().readPin();
    SnackBar snackBar;
    if (pin == '') {
      snackBar = ConstantWidget.customSnackBar(
        text: 'Session expired, Please login again using OTP',
        context: context,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (pin == value) {
        // await Future.delayed(
        //   const Duration(seconds: 3),
        //   () async {
        await getUserStatus();
        //   },
        // );
        // buttonState = ButtonState.SUCCESS;

        //---> Check profile completion status
        if (loginModel.completedStatus) {
          // if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Provider.value(
                value: loginStore,
                child: Provider.value(
                  value: productsStore,
                  child: Provider.value(
                    value: bottomNavigationStore,
                    child: Provider.value(
                      value: profileStore,
                      child: Provider.value(
                        value: orderHistoryStore,
                        child: const HomeScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          final phone = await DataBox().readPhoneNo();
          // print(phone);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Provider.value(
                value: profileStore,
                child: Provider.value(
                  value: loginStore,
                  child: Provider.value(
                    value: productsStore,
                    child: Provider.value(
                      value: bottomNavigationStore,
                      child: Provider.value(
                        value: orderHistoryStore,
                        child: ProfilePage(
                          model: profileStore.profileModel,
                          phone: phone,
                          beginToFill: '',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
      //---> For incorrect pin
      else {
        snackBar = ConstantWidget.customSnackBar(
          text: 'Incorrect Pin',
          context: context,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
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
    SnackBar snackBar;
    if (resp != 'error') {
      snackBar =
          ConstantWidget.customSnackBar(text: 'OTP sent', context: context);
      buttonState = ButtonState.SUCCESS;
    } else {
      snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to send OTP', context: context);
      buttonState = ButtonState.ERROR;
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
