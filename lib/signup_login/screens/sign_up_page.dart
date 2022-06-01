import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification.dart';
import 'package:medrpha_customer/signup_login/screens/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    Key? key,
    // required this.isRemember,
    // required this.themeMode,
  }) : super(key: key);

  final isRemember = false;
  final themeMode = 0;
  final textPhoneController = TextEditingController();

  // TextEditingController textNameController = new TextEditingController();
  // TextEditingController textPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    // SizeConfig().init(context);
    // ConstantData.setThemePosition();
    double height = ConstantWidget.getScreenPercentSize(context, 23);

    double subHeight = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(subHeight, 20);
    double fontSize = ConstantWidget.getPercentSize(subHeight, 25);

    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.all(ConstantWidget.getScreenPercentSize(context, 2.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(
              //   height: ConstantWidget.getScreenPercentSize(context, 2),
              // ),
              // Center(
              //   child: Image.asset(
              //     ConstantData.assetsPath + "med_logo_text_img.png",
              //     height: height,
              //   ),
              // ),
              MedLogo(height: height),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 1.5),
              ),
              // ConstantWidget.getTextWidget(
              //   'signUp',
              //   ConstantData.mainTextColor,
              //   TextAlign.center,
              //   FontWeight.bold,
              //   ConstantWidget.getScreenPercentSize(context, 4.2),
              // ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2.5),
              ),
              // ConstantWidget.getDefaultTextFiledWidget(
              //     context, S.of(context)!.yourName, textNameController),
              // ConstantWidget.getDefaultTextFiledWidget(
              //     context, S.of(context)!.yourEmail, textEmailController),
              PhoneInput(
                subHeight: subHeight,
                radius: radius,
                fontSize: fontSize,
                controller: textPhoneController,
              ),
              // ConstantWidget.getPasswordTextFiled(
              //     context, S.of(context)!.password, textPasswordController),
              // Observer(builder: (_) {
              //   final state = store.buttonState;

              //   switch (state) {
              //     case ButtonState.LOADING:
              //       return const CircularProgressIndicator(color: Colors.blue);
              //     case ButtonState.SUCCESS:
              //       return ConstantWidget.getButtonWidget(
              //           context, 'Get OTP', ConstantData.primaryColor,
              //           () async {
              //         print(1);
              //         await store.getOTP(
              //           mobile: textPhoneController.text.trim(),
              //         );
              //         print('success');
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => Provider.value(
              //                   value: store,
              //                   child: PhoneVerification(
              //                     phone: textPhoneController.text.trim(),
              //                   )),
              //             ));
              //       });
              //     case ButtonState.ERROR:
              //       ScaffoldMessenger.of(context)
              //           .showSnackBar(SnackBar(content: Text('ERROR!')));
              //       return ConstantWidget.getButtonWidget(
              //           context, 'Get OTP', ConstantData.primaryColor, () {
              //         // Navigator.push(
              //         //     context,
              //         //     MaterialPageRoute(
              //         //       builder: (context) => PhoneVerification(),
              //         //     ));
              //       });
              //   }
              // }),
              Container(
                height: ConstantWidget.getScreenPercentSize(context, 7.5),
                margin: EdgeInsets.symmetric(
                    vertical:
                        ConstantWidget.getScreenPercentSize(context, 1.2)),
                decoration: BoxDecoration(
                  color: ConstantData.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      ConstantWidget.getPercentSize(height, 20),
                    ),
                  ),
                ),
                child: Center(child: Observer(builder: (_) {
                  final state = store.buttonState;

                  switch (state) {
                    case ButtonState.LOADING:
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    case ButtonState.SUCCESS:
                      return GestureDetector(
                        onTap: () async {
                          await store.getOTP(
                              mobile: textPhoneController.text.trim());
                          final phone = textPhoneController.text.trim();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Provider.value(
                                        value: store,
                                        child: Provider.value(
                                          value: productStore,
                                          child: PhoneVerification(
                                            phone: phone,
                                          ),
                                        ),
                                      )));
                          textPhoneController.clear();
                        },
                        child: ConstantWidget.getDefaultTextWidget(
                            'Get OTP',
                            TextAlign.center,
                            FontWeight.w500,
                            ConstantWidget.getPercentSize(height, 10),
                            Colors.white),
                      );
                    case ButtonState.ERROR:
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return CustomDialogBox(
                      //         title: "ERROR!",
                      //         descriptions:
                      //             "Error while creating the account please try again!",
                      //         text: "Continue",
                      //         func: () {
                      //           // Navigator.push(
                      //           //     context,
                      //           //     MaterialPageRoute(
                      //           //       builder: (context) =>
                      //           //           WidgetNotificationConfirmation(),
                      //           //     ));
                      //         },
                      //       );
                      //     });
                      return ConstantWidget.getDefaultTextWidget(
                          'verification',
                          TextAlign.center,
                          FontWeight.w500,
                          ConstantWidget.getPercentSize(height, 30),
                          (ConstantData.cellColor == ConstantData.primaryColor)
                              ? Colors.white
                              : ConstantData.mainTextColor);
                  }
                })),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstantWidget.getTextWidget(
                      'You have an already account?',
                      ConstantData.mainTextColor,
                      TextAlign.left,
                      FontWeight.w500,
                      ConstantWidget.getScreenPercentSize(context, 1.8)),
                  SizedBox(
                    width: ConstantWidget.getScreenPercentSize(context, 0.5),
                  ),
                  InkWell(
                    child: ConstantWidget.getTextWidget(
                        'signIn',
                        ConstantData.primaryColor,
                        TextAlign.start,
                        FontWeight.bold,
                        ConstantWidget.getScreenPercentSize(context, 2)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    Key? key,
    required this.subHeight,
    required this.radius,
    required this.fontSize,
    required this.controller,
  }) : super(key: key);

  final double subHeight;
  final double radius;
  final double fontSize;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: subHeight,
            margin: const EdgeInsets.only(right: 7),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: ConstantData.cellColor,
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
            child: CountryCodePicker(
              boxDecoration: BoxDecoration(
                color: ConstantData.cellColor,
              ),
              closeIcon: Icon(Icons.close,
                  size: ConstantWidget.getScreenPercentSize(context, 3),
                  color: ConstantData.mainTextColor),

              onChanged: (value) {
                // countryCode = value.dialCode;
                // print("changeval===$countryCode");
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'IN',
              searchStyle: TextStyle(
                  color: ConstantData.mainTextColor,
                  fontFamily: ConstantData.fontFamily),
              searchDecoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: ConstantData.textColor),
                  ),
                  hintStyle: TextStyle(
                      color: ConstantData.mainTextColor,
                      fontFamily: ConstantData.fontFamily)),
              textStyle: TextStyle(
                  color: ConstantData.mainTextColor,
                  fontFamily: ConstantData.fontFamily),
              dialogTextStyle: TextStyle(
                  color: ConstantData.mainTextColor,
                  fontFamily: ConstantData.fontFamily),

              showFlagDialog: true,
              hideSearch: true,
              // comparator: (a, b) => b.name!.compareTo(a.name),

              onInit: (code) {
                // countryCode = code.dialCode;
                // print("on init ${code!.name} ${code.dialCode} ${code.name}");
              },
            ),
          ),
          Expanded(
            child: Container(
              height: subHeight,
              padding: const EdgeInsets.only(left: 7),
              margin: const EdgeInsets.only(left: 7),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: ConstantData.cellColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: (value) async {
                  try {} catch (e) {
                    // print("resge$e");
                  }
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: ConstantWidget.getWidthPercentSize(context, 2)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'phoneNumber',
                    hintStyle: TextStyle(
                        fontFamily: ConstantData.fontFamily,
                        color: ConstantData.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
                style: TextStyle(
                    fontFamily: ConstantData.fontFamily,
                    color: ConstantData.textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
