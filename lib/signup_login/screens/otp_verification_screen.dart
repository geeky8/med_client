// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/create_pin_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class OTPSuccessFailure extends StatelessWidget {
  const OTPSuccessFailure({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    // final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          height: ConstantWidget.getScreenPercentSize(context, 10),
          child: ConstantWidget.getBottomButton(
            context: context,
            func: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      header: 'Set a Pin\nfor your account',
                      description:
                          'Set a 4-Digit Pin to access your Account while you login ',
                      func: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Provider.value(
                              value: store,
                              child: Provider.value(
                                value: productStore,
                                child: Provider.value(
                                  value: profileStore,
                                  child: Provider.value(
                                    value: orderHistoryStore,
                                    child: Provider.value(
                                      value: bottomNavigationStore,
                                      child: SignInPage(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      buttonText: 'Set Pin',
                    );
                  });
            },
            label: 'Proceed',
            color: ConstantData.primaryColor,
            height: 7,
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                  ConstantData.assetsPath + 'img_allow_notification.png'),
              // const Spacer(),
              SizedBox(
                height: blockSizeVertical(context: context) * 4,
              ),
              ConstantWidget.getCustomText(
                'Phone Number Verified',
                ConstantData.mainTextColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font22Px(context: context) * 1.1,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 5,
                  vertical: blockSizeVertical(context: context) * 2,
                ),
                child: ConstantWidget.getCustomText(
                  'Congratulations, your phone number has been verified. You can start using the app',
                  ConstantData.clrBorder,
                  3,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
