// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
// ignore: unused_import
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/screens/otp_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);

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

    double height = ConstantWidget.getScreenPercentSize(context, 18);

    // Defining all the stores
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final productsStore = context.read<ProductsStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: Scaffold(
          backgroundColor: ConstantData.bgColor,
          bottomNavigationBar: Container(
            height: ConstantWidget.getScreenPercentSize(context, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Observer(builder: (_) {
                      final state = store.buttonState;
                      // print('change in buttonState ${store.buttonState}');
                      switch (state) {
                        case ButtonState.LOADING:
                          return SizedBox(
                            height: ConstantWidget.getWidthPercentSize(
                              context,
                              10,
                            ),
                            width: ConstantWidget.getWidthPercentSize(
                              context,
                              10,
                            ),
                            child: const CircularProgressIndicator(),
                          );
                        case ButtonState.SUCCESS:
                          return Expanded(
                            child: ConstantWidget.getBottomButton(
                              context: context,
                              func: () async {
                                store.buttonState = ButtonState.LOADING;
                                await store.login(
                                  value: _pinController.text.trim(),
                                  context: context,
                                  productsStore: productsStore,
                                  loginStore: store,
                                  profileStore: profileStore,
                                  bottomNavigationStore: bottomNavigationStore,
                                  orderHistoryStore: orderHistoryStore,
                                );
                                store.buttonState = ButtonState.SUCCESS;
                              },
                              label: 'Login',
                              color: ConstantData.primaryColor,
                              height: 7,
                            ),
                          );
                        case ButtonState.ERROR:
                          return Expanded(
                            child: ConstantWidget.getBottomButton(
                              context: context,
                              func: () async {
                                await store.login(
                                  value: _pinController.text.trim(),
                                  context: context,
                                  productsStore: productsStore,
                                  loginStore: store,
                                  profileStore: profileStore,
                                  bottomNavigationStore: bottomNavigationStore,
                                  orderHistoryStore: orderHistoryStore,
                                );
                              },
                              label: 'Login',
                              color: ConstantData.primaryColor,
                              height: 7,
                            ),
                          );
                      }
                    }),
                  ],
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),

                //---> Again login with OTP
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: productsStore,
                            child: Provider.value(
                              value: profileStore,
                              child: Provider.value(
                                value: bottomNavigationStore,
                                child: Provider.value(
                                  value: orderHistoryStore,
                                  child: SignUpPage(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ConstantWidget.getTextWidget(
                    'Login with OTP',
                    ConstantData.clrBlack30,
                    TextAlign.center,
                    FontWeight.w500,
                    font18Px(context: context),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              // horizontal: blockSizeHorizontal(context: context) * 4,
              vertical: blockSizeVertical(context: context) * 5,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 5),
                  ),

                  //---> Logo
                  MedLogo(height: height),

                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4.5),
                  ),
                  // const Spacer(),

                  //---> Pin Input field
                  PinInput(
                    pinEditingController: _pinController,
                    // enable: true,
                    isObscure: true,
                    action: TextInputAction.next,
                    label: 'Enter Pin',
                    onSubmit: (value) async {
                      //---> Login func
                      store.buttonState = ButtonState.LOADING;
                      // print('buttonstate ${store.buttonState}');
                      await store.login(
                        value: value,
                        context: context,
                        productsStore: productsStore,
                        loginStore: store,
                        profileStore: profileStore,
                        bottomNavigationStore: bottomNavigationStore,
                        orderHistoryStore: orderHistoryStore,
                      );
                      store.buttonState = ButtonState.SUCCESS;
                      // print('buttonstate ${store.buttonState}');
                    },
                    unfocus: true,
                    func: () async {},
                  ),

                  // SizedBox(
                  //   height: ConstantWidget.getScreenPercentSize(context, 4),
                  // ),
                  // const Spacer(),
                  // Login Button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
