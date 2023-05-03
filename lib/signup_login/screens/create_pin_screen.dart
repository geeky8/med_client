// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return Future.value(true);
  }

  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String pin = '';
  String confirmPin = '';

  @override
  Widget build(BuildContext context) {
    //--> Defining all required Mobx stores
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    double height = ConstantWidget.getScreenPercentSize(context, 18);

    final focus = FocusNode();

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          bottomNavigationBar: InkWell(
            onTap: () async {},
            child: ConstantWidget.getBottomButton(
              context: context,
              func: () async {
                if (pin != "" && confirmPin != "" && pin == confirmPin) {
                  final dataBox = DataBox();
                  await dataBox.writePin(pin: pin);

                  showDialog(
                      context: context,
                      builder: (_) {
                        return CustomAlertDialog(
                          header: 'Pin successfully\ncreated',
                          description:
                              'You have successfully set your 4-digit unique pin use it to login',
                          func: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => Provider.value(
                                  value: store..init(),
                                  child: Provider.value(
                                    value: productStore..init(),
                                    child: Provider.value(
                                      value: profileStore..init(),
                                      child: Provider.value(
                                        value: bottomNavigationStore,
                                        child: Provider.value(
                                          value: orderHistoryStore
                                            ..getOrdersList(),
                                          child: LoginScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          buttonText: 'Proceed',
                        );
                      });
                  // ignore: use_build_context_synchronously
                } else {
                  Fluttertoast.showToast(msg: 'Pin do not match, try again');
                }
              },
              label: 'Confirm',
              color: ConstantData.primaryColor,
              height: 7,
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
              child: ListView(
                children: [
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),

                  //--> Logo
                  MedLogo(height: height),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),
                  ConstantWidget.getCustomText(
                    'Set Authentication Pin',
                    ConstantData.mainTextColor,
                    1,
                    TextAlign.center,
                    FontWeight.w600,
                    font25Px(context: context),
                  ),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 3),
                  ),
                  ConstantWidget.getCustomText(
                    'Set a unique 4-digit pin to add extra security to your account.',
                    ConstantData.clrBorder,
                    2,
                    TextAlign.center,
                    FontWeight.w600,
                    font18Px(context: context) * 1.12,
                  ),

                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 5),
                  ),

                  //---> Pin Input
                  ConstantWidget.getCustomText(
                    'Enter Pin',
                    ConstantData.mainTextColor,
                    1,
                    TextAlign.center,
                    FontWeight.w600,
                    font22Px(context: context),
                  ),
                  PinInput(
                    pinEditingController: _pinController,
                    // enable: true,
                    isObscure: false,
                    action: TextInputAction.send,
                    // func: () {
                    //   FocusManager.instance.primaryFocus!.nextFocus();
                    // },
                    onSubmit: (value) {
                      FocusScope.of(context).requestFocus(focus);
                      pin = value;
                    },
                    pinShape: PinCodeFieldShape.circle,
                  ),

                  //---> Confirm Pin
                  ConstantWidget.getCustomText(
                    'Confirm the entered Pin',
                    ConstantData.mainTextColor,
                    1,
                    TextAlign.center,
                    FontWeight.w600,
                    font22Px(context: context),
                  ),

                  PinInput(
                    pinEditingController: _confirmPinController,
                    // enable: false,

                    action: TextInputAction.done,
                    focusNode: focus,
                    isObscure: true,
                    pinShape: PinCodeFieldShape.circle,
                    onSubmit: (value) {
                      confirmPin = value;
                    },
                  ),

                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4),
                  ),

                  //---> Pin confirmation button
                ],
              ),
            ),
          ),
        ));
  }
}
