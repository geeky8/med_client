import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

                  //--> Logo
                  MedLogo(height: height),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5),
                  ),

                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5),
                  ),

                  //---> Pin Input
                  PinInput(
                    pinEditingController: _pinController,
                    // enable: true,
                    isObscure: true,
                    action: TextInputAction.next,
                    label: 'Enter Pin',
                    func: () {
                      FocusManager.instance.primaryFocus?.nextFocus();
                    },
                    onSubmit: (value) {
                      pin = value;
                    },
                  ),

                  //---> Confirm Pin
                  PinInput(
                    pinEditingController: _confirmPinController,
                    // enable: false,
                    action: TextInputAction.done,
                    isObscure: false,
                    label: 'Confrim Pin',
                    onSubmit: (value) {
                      confirmPin = value;
                    },
                  ),

                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4),
                  ),

                  //---> Pin confirmation button
                  InkWell(
                    onTap: () async {
                      // print(pin);
                      // print(confirmPin);
                      if (pin == confirmPin) {
                        final dataBox = DataBox();
                        await dataBox.writePin(pin: pin);

                        showDialog(
                            context: context,
                            builder: (_) {
                              return CustomAlertDialog(
                                header: 'Success',
                                image: 'med_logo_text.png',
                                description: 'Pin successfully created',
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
                                buttonText: 'continue',
                              );
                            });
                        // ignore: use_build_context_synchronously

                      } else {
                        final snackBar = SnackBar(
                            content: ConstantWidget.getTextWidget(
                                'Pin does not match, kindly enter the same pin',
                                ConstantData.bgColor,
                                TextAlign.left,
                                FontWeight.w600,
                                font18Px(context: context)));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ConstantWidget.getWidthPercentSize(context, 20)),
                      child: ConstantWidget.getButtonWidget(
                        context,
                        'Confirm',
                        ConstantData.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
