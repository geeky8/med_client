import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  // final textEmailController = TextEditingController();
  // final textPasswordController = TextEditingController();

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return Future.value(true);
  }

  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    // SizeConfig().init(context);
    // ConstantData.setThemePosition();
    double height = ConstantWidget.getScreenPercentSize(context, 18);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
              child: ListView(
                children: [
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),
                  // Center(
                  //   child: Image.asset(
                  //     ConstantData.assetsPath + "molecular-medicine.png",
                  //     height: height,
                  //   ),
                  // ),
                  MedLogo(height: height),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5),
                  ),
                  // ConstantWidget.getTextWidget(
                  //     'Set Pin',
                  //     ConstantData.mainTextColor,
                  //     TextAlign.center,
                  //     FontWeight.bold,
                  //     ConstantWidget.getScreenPercentSize(context, 4.2)),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5),
                  ),
                  PinInput(
                    pinEditingController: _pinController,
                    // enable: true,
                    isObscure: true,
                    action: TextInputAction.next,
                    label: 'Enter Pin',
                    func: () {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  PinInput(
                    pinEditingController: _confirmPinController,
                    // enable: false,
                    action: TextInputAction.done,
                    isObscure: false,
                    label: 'Confrim Pin',
                  ),
                  // ConstantWidget.getDefaultTextFiledWidget(
                  //     context, 'Email', textEmailController),
                  // ConstantWidget.getPasswordTextFiled(
                  //     context, 'password', textPasswordController),
                  // Row(
                  //   children: [
                  //     InkWell(
                  //       child: Icon(
                  //         isRemember
                  //             ? Icons.check_box
                  //             : Icons.check_box_outline_blank,
                  //         color: ConstantData.mainTextColor,
                  //         size: ConstantWidget.getScreenPercentSize(context, 3),
                  //       ),
                  //       onTap: () {
                  //         // if (isRemember) {
                  //         //   isRemember = false;
                  //         // } else {
                  //         //   isRemember = true;
                  //         // }
                  //         // setState(() {});
                  //       },
                  //     ),
                  //     SizedBox(
                  //       width:
                  //           ConstantWidget.getScreenPercentSize(context, 0.5),
                  //     ),
                  //     ConstantWidget.getTextWidget(
                  //         'rememberMe',
                  //         ConstantData.mainTextColor,
                  //         TextAlign.left,
                  //         FontWeight.w400,
                  //         ConstantWidget.getScreenPercentSize(context, 1.8)),
                  //     Expanded(
                  //       child: InkWell(
                  //         child: ConstantWidget.getTextWidget(
                  //           'forgotPassword',
                  //           ConstantData.mainTextColor,
                  //           TextAlign.end,
                  //           FontWeight.w400,
                  //           ConstantWidget.getScreenPercentSize(context, 1.8),
                  //         ),
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //       builder: (context) => ForgotPassword(),
                  //           //     ));
                  //         },
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_pinController.text.trim() ==
                          _confirmPinController.text.trim()) {
                        final _dataBox = DataBox();
                        await _dataBox.writePin(
                            pin: _pinController.text.trim());
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => Provider.value(
                                value: store,
                                child: Provider.value(
                                    value: productStore,
                                    child: LoginScreen()))));
                      } else {
                        final snackBar = SnackBar(
                            content: ConstantWidget.getTextWidget(
                                'Confirm pin does not match the pin entered',
                                ConstantData.bgColor,
                                TextAlign.left,
                                FontWeight.w500,
                                font18Px(context: context)));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: ConstantWidget.getButtonWidget(
                      context,
                      'Confirm',
                      ConstantData.primaryColor,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical:
                  //           ConstantWidget.getScreenPercentSize(context, .5)),
                  //   child: Center(
                  //     child: ConstantWidget.getTextWidget(
                  //         'or',
                  //         ConstantData.textColor,
                  //         TextAlign.center,
                  //         FontWeight.w300,
                  //         ConstantWidget.getScreenPercentSize(context, 1.8)),
                  //   ),
                  // ),
                  // ConstantWidget.getButtonWidget(
                  //     context, 'signUp', ConstantData.primaryColor, () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => SignUpPage(),
                  //       ));
                  // }),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
