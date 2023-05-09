// import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/profile/widgets/widgets.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    Key? key,
  }) : super(key: key);

  final isRemember = false;
  final themeMode = 0;
  final textPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //---> Defining all the Mobx stores
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    double height = ConstantWidget.getScreenPercentSize(context, 23);

    double subHeight = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(subHeight, 20);
    double fontSize = ConstantWidget.getPercentSize(subHeight, 25);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstantData.bgColor,
        bottomNavigationBar: Observer(builder: (_) {
          final state = store.buttonState;
          switch (state) {
            case ButtonState.LOADING:
              return const LinearProgressIndicator();
            case ButtonState.SUCCESS:
              return const SizedBox();
            case ButtonState.ERROR:
              return const SizedBox();
          }
        }),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(
                ConstantWidget.getScreenPercentSize(context, 2.5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //--> Logo
                MedLogo(height: height),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 1.5),
                ),
                //---> Enter phone no
                PhoneInput(
                  subHeight: subHeight,
                  radius: radius,
                  fontSize: fontSize,
                  controller: textPhoneController,
                  hintFontSize: font18Px(context: context),
                ),

                //---> Get OTP Button
                InkWell(
                  onTap: () async {
                    if (textPhoneController.text.trim().isNotEmpty) {
                      await store.getOTP(
                          mobile: textPhoneController.text.trim());
                      final phone = textPhoneController.text.trim();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Provider.value(
                                    value: store,
                                    child: Provider.value(
                                      value: productStore,
                                      child: Provider.value(
                                        value: profileStore,
                                        child: Provider.value(
                                          value: bottomNavigationStore,
                                          child: Provider.value(
                                            value: orderHistoryStore,
                                            child: PhoneVerification(
                                              phone: phone,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )));
                      textPhoneController.clear();
                    } else {
                      Fluttertoast.showToast(msg: 'Enter a valid number');
                    }
                  },
                  child: Container(
                    height: ConstantWidget.getScreenPercentSize(context, 7.5),
                    // width: ConstantWidget.getWidthPercentSize(context, 40),
                    decoration: BoxDecoration(
                      color: ConstantData.primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          ConstantWidget.getPercentSize(height, 20),
                        ),
                      ),
                    ),
                    child: Center(
                      child: ConstantWidget.getDefaultTextWidget(
                        'Get OTP',
                        TextAlign.center,
                        FontWeight.w600,
                        font22Px(context: context),
                        Colors.white,
                      ),
                    ),
                  ),
                ),
                // Column(
                //   children: [
                //     ConstantWidget.getTextWidget(
                //       'Already have an account?\n',
                //       ConstantData.mainTextColor,
                //       TextAlign.center,
                //       FontWeight.w600,
                //       font18Px(context: context),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Navigator.pushReplacement(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => Provider.value(
                //               value: store,
                //               child: Provider.value(
                //                 value: productStore,
                //                 child: Provider.value(
                //                   value: profileStore..init(),
                //                   child: Provider.value(
                //                     value: bottomNavigationStore,
                //                     child: Provider.value(
                //                       value: orderHistoryStore,
                //                       child: LoginScreen(),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //       child: ConstantWidget.getTextWidget(
                //         'Login with pin',
                //         ConstantData.accentColor,
                //         TextAlign.center,
                //         FontWeight.w600,
                //         font22Px(context: context),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  /// To take phone input [TextField]
  const PhoneInput({
    Key? key,
    required this.subHeight,
    required this.radius,
    required this.fontSize,
    required this.controller,
    required this.hintFontSize,
  }) : super(key: key);

  final double subHeight;
  final double radius;
  final double fontSize;
  final TextEditingController controller;
  final double hintFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Container(
          //   height: subHeight,
          //   margin: const EdgeInsets.only(right: 7),
          //   padding: const EdgeInsets.symmetric(horizontal: 5),
          //   decoration: BoxDecoration(
          //     color: ConstantData.cellColor,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(radius),
          //     ),
          //   ),
          //   child: CountryPickerDropDown(
          //     boxDecoration: BoxDecoration(
          //       color: ConstantData.cellColor,
          //     ),
          //     closeIcon: Icon(Icons.close,
          //         size: ConstantWidget.getScreenPercentSize(context, 3),
          //         color: ConstantData.mainTextColor),

          //     onChanged: (value) {
          //       // countryCode = value.dialCode;
          //       // print("changeval===$countryCode");
          //     },
          //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
          //     initialSelection: 'IN',
          //     searchStyle: TextStyle(
          //       color: ConstantData.mainTextColor,
          //       fontFamily: ConstantData.fontFamily,
          //     ),
          //     searchDecoration: InputDecoration(
          //         border: UnderlineInputBorder(
          //           borderSide: BorderSide(color: ConstantData.textColor),
          //         ),
          //         hintStyle: TextStyle(
          //             color: ConstantData.mainTextColor,
          //             fontFamily: ConstantData.fontFamily)),
          //     textStyle: TextStyle(
          //       color: ConstantData.mainTextColor,
          //       fontFamily: ConstantData.fontFamily,
          //       fontWeight: FontWeight.w600,
          //       fontSize: font18Px(context: context),
          //     ),
          //     dialogTextStyle: TextStyle(
          //       color: ConstantData.mainTextColor,
          //       fontFamily: ConstantData.fontFamily,
          //     ),

          //     showFlagDialog: true,
          //     hideSearch: true,
          //     // comparator: (a, b) => b.name!.compareTo(a.name),

          //     onInit: (code) {
          //       // countryCode = code.dialCode;
          //       // print("on init ${code!.name} ${code.dialCode} ${code.name}");
          //     },
          //   ),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     height: subHeight,
          //     padding: const EdgeInsets.only(left: 7),
          //     margin: const EdgeInsets.only(left: 7),
          //     alignment: Alignment.centerLeft,
          //     decoration: BoxDecoration(
          //       color: ConstantData.cellColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(radius),
          //       ),
          //     ),
          //     child: TextFormField(

          //       controller: controller,
          //       onChanged: (value) async {
          //         // print(value.length);
          //         if (value.length >= 10) {
          //           FocusManager.instance.primaryFocus?.unfocus();
          //         }
          //       },
          //       decoration: InputDecoration(
          //         contentPadding: EdgeInsets.only(
          //             left: ConstantWidget.getWidthPercentSize(context, 2)),
          //         border: InputBorder.none,
          //         focusedBorder: InputBorder.none,
          //         enabledBorder: InputBorder.none,
          //         errorBorder: InputBorder.none,
          //         disabledBorder: InputBorder.none,
          //         hintText: 'Number',
          //         hintStyle: TextStyle(
          //           fontFamily: ConstantData.fontFamily,
          //           color: ConstantData.textColor,
          //           fontWeight: FontWeight.w600,
          //           fontSize: hintFontSize,
          //         ),
          //         labelText: 'Enter Phone No.',
          //         // labelStyle: TextStyle(
          //         //   fontFamily: ConstantData.fontFamily,
          //         //   color: ConstantData.textColor,
          //         //   fontWeight: FontWeight.w600,
          //         //   fontSize: hintFontSize,
          //         // ),
          //       ),
          //       style: TextStyle(
          //         fontFamily: ConstantData.fontFamily,
          //         color: ConstantData.textColor,
          //         fontWeight: FontWeight.w600,
          //         fontSize: fontSize,
          //       ),
          //       keyboardType: TextInputType.number,

          //       inputFormatters: <TextInputFormatter>[
          //         FilteringTextInputFormatter.digitsOnly
          //       ], // Only numbers can be entered
          //     ),
          //   ),
          // )
          Expanded(
            flex: 1,
            child: CustomTextField(
              context: context,
              hintName: 'Enter Number',
              labelName: 'Contact Number',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Enter Contact Number";
                  }
                  if (value.isNotEmpty && value.length != 10) {
                    return 'Invalid Number';
                  }
                }
                return null;
              },
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}
