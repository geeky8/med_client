// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
// ignore: unused_import
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/screens/profile_screen.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/screens/otp_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';
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
    final _profileStore = context.read<ProfileStore>();
    final _bottomNavigationStore = context.read<BottomNavigationStore>();
    final _productStore = context.read<ProductsStore>();
    final _orderHistoryStore = context.read<OrderHistoryStore>();

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

                //---> Logo
                MedLogo(height: height),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 2),
                ),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 2.5),
                ),

                //---> Pin Input field
                PinInput(
                  pinEditingController: _pinController,
                  // enable: true,
                  isObscure: true,
                  action: TextInputAction.next,
                  label: 'Enter Pin',
                  onSubmit: (value) async {
                    //---> Login func
                    final dataBox = DataBox();
                    final pin = await dataBox.readPin();
                    if (pin == '') {
                      final snackBar = ConstantWidget.customSnackBar(
                          text: 'Session expired, Please login again using OTP',
                          context: context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (pin == value) {
                        store.buttonState = ButtonState.LOADING;
                        await store.getUserStatus();

                        //---> Check profile completion status
                        if (store.loginModel.completedStatus) {
                          // if (!mounted) return;
                          final productsStore = context.read<ProductsStore>();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Provider.value(
                                value: store,
                                child: Provider.value(
                                  value: productsStore,
                                  child: Provider.value(
                                    value: _bottomNavigationStore,
                                    child: Provider.value(
                                      value: _profileStore,
                                      child: Provider.value(
                                        value: _orderHistoryStore,
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
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => Provider.value(
                                      value: _profileStore,
                                      child: Provider.value(
                                        value: store,
                                        child: Provider.value(
                                          value: _productStore,
                                          child: Provider.value(
                                            value: _bottomNavigationStore,
                                            child: Provider.value(
                                              value: _orderHistoryStore,
                                              child: ProfilePage(
                                                model:
                                                    _profileStore.profileModel,
                                                phone: phone,
                                                beginToFill: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))));
                        }
                        store.buttonState = ButtonState.SUCCESS;
                      }
                      //---> For incorrect pin
                      else {
                        final snackBar = ConstantWidget.customSnackBar(
                            text: 'Incorrect Pin', context: context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  unfocus: true,
                  func: () async {},
                ),

                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 4),
                ),

                // Login Button
                InkWell(
                  focusColor: Colors.transparent,
                  onTap: () async {
                    //---> Login func
                    final dataBox = DataBox();
                    final pin = await dataBox.readPin();
                    if (pin == '') {
                      final snackBar = ConstantWidget.customSnackBar(
                          text: 'Session expired, Please login again using OTP',
                          context: context);

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (pin == _pinController.text.trim()) {
                        store.buttonState = ButtonState.LOADING;
                        await store.getUserStatus();

                        //--> Check user's profile status
                        if (store.loginModel.completedStatus) {
                          final productsStore = context.read<ProductsStore>();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Provider.value(
                                value: store,
                                child: Provider.value(
                                  value: productsStore,
                                  child: Provider.value(
                                    value: _bottomNavigationStore,
                                    child: Provider.value(
                                      value: _profileStore,
                                      child: const HomeScreen(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          final phone = await DataBox().readPhoneNo();
                          // print(phone);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => Provider.value(
                                      value: _profileStore,
                                      child: Provider.value(
                                        value: store,
                                        child: Provider.value(
                                          value: _productStore,
                                          child: Provider.value(
                                            value: _bottomNavigationStore,
                                            child: ProfilePage(
                                              model: _profileStore.profileModel,
                                              phone: phone,
                                              beginToFill: '',
                                            ),
                                          ),
                                        ),
                                      ))));
                        }
                        store.buttonState = ButtonState.SUCCESS;
                      }
                      //---> Incorrect pin
                      else {
                        final snackBar = ConstantWidget.customSnackBar(
                            text: 'Incorrect Pin', context: context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: blockSizeHorizontal(context: context) * 30),
                    child: Observer(builder: (_) {
                      final state = store.buttonState;

                      switch (state) {
                        case ButtonState.LOADING:
                          return LoadingAnimationWidget.prograssiveDots(
                            color: ConstantData.color1,
                            size: ConstantWidget.getScreenPercentSize(
                                context, 10),
                          );
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
                  ),
                ),

                SizedBox(
                  height: blockSizeVertical(context: context) * 5,
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
                            value: _productStore,
                            child: Provider.value(
                              value: _profileStore,
                              child: Provider.value(
                                value: _bottomNavigationStore,
                                child: Provider.value(
                                  value: _orderHistoryStore,
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
                    FontWeight.w600,
                    font18Px(context: context) * 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
