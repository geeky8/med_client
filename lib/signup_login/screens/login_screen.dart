import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/screens/profile_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification.dart';
import 'package:medrpha_customer/signup_login/screens/sign_up_page.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // final textEmailController = TextEditingController();
  // final textPasswordController = TextEditingController();

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return Future.value(true);
  }

  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    // SizeConfig().init(context);
    // ConstantData.setThemePosition();
    double height = ConstantWidget.getScreenPercentSize(context, 18);

    // bool _confirmEnabled = false;

    return WillPopScope(
      onWillPop: _requestPop,
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
                  height: ConstantWidget.getScreenPercentSize(context, 2),
                ),
                // ConstantWidget.getTextWidget(
                //     'Login',
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
                  unfocus: true,
                  func: () async {
                    final _dataBox = DataBox();
                    final _pin = await _dataBox.readPin();
                    if (_pin == '') {
                      final _snackBar = ConstantWidget.customSnackBar(
                          text: 'Session expired, Please login again using OTP',
                          context: context);
                      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                    } else {
                      if (_pin == _pinController.text.trim()) {
                        await store.getUserStatus();
                        // print(store.loginModel.toMap());
                        if (store.loginModel.completedStatus) {
                          final productsStore = context.read<ProductsStore>();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Provider.value(
                                      value: store,
                                      child: Provider.value(
                                          value: productsStore..init(),
                                          child: const HomeScreen()))));
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const ProfilePage()));
                        }
                      } else {
                        final _snackBar = ConstantWidget.customSnackBar(
                            text: 'Incorrect Pin', context: context);
                        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                      }
                    }
                  },
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
                Observer(builder: (_) {
                  return InkWell(
                    onTap: () async {
                      // final focus = FocusScope.of(context);
                      // if (focus.hasPrimaryFocus) {
                      //   focus.unfocus();
                      // }
                      final _dataBox = DataBox();
                      final _pin = await _dataBox.readPin();
                      if (_pin == '') {
                        final _snackBar = ConstantWidget.customSnackBar(
                            text:
                                'Session expired, Please login again using OTP',
                            context: context);
                        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                      } else {
                        if (_pin == _pinController.text.trim()) {
                          store.buttonState = ButtonState.LOADING;
                          await store.getUserStatus();
                          // print(store.loginModel.toMap());
                          if (store.loginModel.completedStatus) {
                            final productsStore = context.read<ProductsStore>();

                            await productsStore.init();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Provider.value(
                                        value: store,
                                        child: Provider.value(
                                            value: productsStore,
                                            child: const HomeScreen()))));
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const ProfilePage()));
                          }
                          store.buttonState = ButtonState.SUCCESS;
                        } else {
                          final _snackBar = ConstantWidget.customSnackBar(
                              text: 'Incorrect Pin', context: context);
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                        }
                      }
                    },
                    child: Observer(builder: (_) {
                      final state = store.buttonState;

                      switch (state) {
                        case ButtonState.LOADING:
                          // return CircularProgressIndicator(
                          //   color: ConstantData.primaryColor,
                          // );
                          return ConstantWidget.linearLoadingIndicator(
                              context, ConstantData.mainTextColor, height);
                        case ButtonState.SUCCESS:
                          return ConstantWidget.getButtonWidget(
                            context,
                            'Login',
                            ConstantData.primaryColor,
                          );
                        case ButtonState.ERROR:
                          return ConstantWidget.getButtonWidget(
                            context,
                            'Login',
                            ConstantData.primaryColor,
                          );
                      }
                    }),
                  );
                }),

                SizedBox(
                  height: blockSizeVertical(context: context) * 5,
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Provider.value(
                                value: store, child: SignUpPage())));
                  },
                  child: ConstantWidget.getTextWidget(
                      'Login with OTP?',
                      ConstantData.mainTextColor,
                      TextAlign.center,
                      FontWeight.w500,
                      font18Px(context: context)),
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
    );
  }
}
