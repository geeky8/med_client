import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/screens/sign_in_page.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/custom_dialog_box.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhoneVerification extends StatelessWidget {
  // bool isRemember = false;
  // int themeMode = 0;
  PhoneVerification({
    Key? key,
    required this.phone,
  }) : super(key: key);

  final String phone;
  // TextEditingController textEmailController = new TextEditingController();
  // TextEditingController textPasswordController = new TextEditingController();

  // Future<bool> _requestPop() {
  //   Navigator.of(context).pop();
  //   return new Future.value(true);
  // }

  // final GlobalKey<FormFieldState<String>> _formKey =
  //     GlobalKey<FormFieldState<String>>(debugLabel: '_formkey');

  /// [_pinEditingController] for taking the OTP pin.
  final _pinEditingController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   setTheme();
  // }

  // setTheme() async {
  //   themeMode = await PrefData.getThemeMode();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();

    // print('verification $phone');

    // SizeConfig().init(context);
    // ConstantData.setThemePosition();

    ///
    double height = ConstantWidget.getScreenPercentSize(context, 18);

    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.all(ConstantWidget.getScreenPercentSize(context, 2.5)),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              ),
              MedLogo(height: height),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              ),
              ConstantWidget.getTextWidget(
                'verification',
                ConstantData.mainTextColor,
                TextAlign.center,
                FontWeight.bold,
                ConstantWidget.getScreenPercentSize(context, 4.2),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 5),
              ),
              Center(
                child: PinInput(
                  pinEditingController: _pinEditingController,
                  isObscure: false,
                  action: TextInputAction.go,
                  // enable: _enable,
                  label: 'OTP',
                ),
              ),
              SizedBox(
                height: safeBlockVertical(context: context) * 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: safeBlockVertical(context: context) * 9),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await store.getOTP(mobile: phone);
                      },
                      child: ConstantWidget.getButtonWidget(
                        context,
                        'resend',
                        ConstantData.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: safeBlockVertical(context: context) * 3,
                    ),
                    Container(
                      height: ConstantWidget.getScreenPercentSize(context, 7.5),
                      margin: EdgeInsets.symmetric(
                          vertical: ConstantWidget.getScreenPercentSize(
                              context, 1.2)),
                      decoration: BoxDecoration(
                        color: ConstantData.cellColor,
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
                            return CircularProgressIndicator(
                              color: ConstantData.mainTextColor,
                            );
                          case ButtonState.SUCCESS:
                            return InkWell(
                              onTap: () async {
                                final i = await store.verifyOTP(
                                  mobile: phone,
                                  otp: _pinEditingController.text.trim(),
                                );
                                // print(i);
                                _pinEditingController.clear();
                                if (i == 1) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: "SUCCESS!",
                                          descriptions:
                                              "Successfully verified!",
                                          text: "Continue",
                                          func: () {
                                            // Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Provider.value(
                                                          value: store,
                                                          child: Provider.value(
                                                              value:
                                                                  productStore,
                                                              child:
                                                                  SignInPage())),
                                                ));
                                          },
                                        );
                                      });
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => Provider.value(
                                  //           value: store, child: SignInPage()),
                                  //     ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: "Error!",
                                          descriptions: "Please try again!",
                                          text: "Continue",
                                          func: () {
                                            Navigator.of(context).pop();
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           IntroPage(),
                                            //     ));
                                          },
                                        );
                                      });
                                }
                              },
                              child: ConstantWidget.getDefaultTextWidget(
                                  'Verify',
                                  TextAlign.center,
                                  FontWeight.w500,
                                  font22Px(context: context),
                                  (ConstantData.cellColor ==
                                          ConstantData.primaryColor)
                                      ? Colors.white
                                      : ConstantData.mainTextColor),
                            );
                          case ButtonState.ERROR:
                            return ConstantWidget.getDefaultTextWidget(
                                'Verify',
                                TextAlign.center,
                                FontWeight.w500,
                                font12Px(context: context),
                                (ConstantData.cellColor ==
                                        ConstantData.primaryColor)
                                    ? Colors.white
                                    : ConstantData.mainTextColor);
                        }
                      })),
                    ),
                    // Observer(builder: (_) {
                    //   final state = store.buttonState;

                    //   switch (state) {
                    //     case ButtonState.LOADING:
                    // return const CircularProgressIndicator(
                    //   color: Colors.white,
                    // );
                    //     case ButtonState.SUCCESS:
                    // return ConstantWidget.getButtonWidget(
                    //     context,
                    //     S.of(context)!.verification,
                    //     ConstantData.cellColor, () async {
                    //   await store.verifyOTP(
                    //       mobile: phone,
                    //       otp: _pinEditingController.text.trim());

                    //         // showDialog(
                    //         //     context: context,
                    //         //     builder: (BuildContext context) {
                    //         //       return CustomDialogBox(
                    //         //         title: "Account Created!",
                    //         //         descriptions:
                    //         //             "Your account has\nbeen successfully created!",
                    //         //         text: "Continue",
                    //         //         func: () {
                    //         //           Navigator.push(
                    //         //               context,
                    //         //               MaterialPageRoute(
                    //         //                 builder: (context) =>
                    //         //                     WidgetNotificationConfirmation(),
                    //         //               ));
                    //         //         },
                    //         //       );
                    //         //     });

                    //         // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
                    //       });
                    //     case ButtonState.ERROR:
                    //       return ConstantWidget.getButtonWidget(
                    //           context,
                    //           S.of(context)!.verification,
                    //           ConstantData.cellColor, () async {
                    //         // await store.verifyOTP(
                    //         //     mobile: phone,
                    //         //     otp: _pinEditingController.text.trim());

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

                    //       // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
                    //     });
                    // }
                    // }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MedLogo extends StatelessWidget {
  const MedLogo({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ConstantData.assetsPath + "med_logo_text_img.png",
        height: height,
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  const PinInput({
    Key? key,
    required this.label,
    required this.pinEditingController,
    required this.isObscure,
    required this.action,
    this.unfocus,
    this.func,
  }) :
        //  _pinEditingController = pinEditingController,
        //       _enable = enable,
        super(key: key);

  final TextEditingController pinEditingController;
  final bool isObscure;
  final String label;
  final Function? func;
  final TextInputAction action;
  final bool? unfocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: safeBlockVertical(context: context) * 2),
      child: SizedBox(
        width: safeBlockHorizontal(context: context) * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getTextWidget(
              '$label :',
              ConstantData.mainTextColor,
              TextAlign.center,
              FontWeight.w500,
              font22Px(context: context),
            ),
            SizedBox(
              height: safeBlockVertical(context: context) * 2,
            ),
            PinInputTextFormField(
              // key: _formKey,
              pinLength: 4,

              decoration: BoxLooseDecoration(
                textStyle: TextStyle(
                    color: ConstantData.mainTextColor,
                    fontFamily: ConstantData.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),

                strokeColorBuilder: PinListenColorBuilder(
                    ConstantData.textColor, ConstantData.primaryColor),

                obscureStyle: ObscureStyle(
                  isTextObscure: isObscure,
                  obscureText: '*',
                ),
                // hintText: _kDefaultHint,
              ),
              controller: pinEditingController,
              textInputAction: action,
              enabled: true,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.characters,
              onSubmit: (pin) => func,
              onChanged: (pin) {
                // setState(() {
                //   debugPrint('onChanged execute. pin:$pin');
                // });
              },
              onSaved: (pin) {
                debugPrint('onSaved pin:$pin');
              },
              validator: (pin) {
                if (pin!.isEmpty) {
                  // setState(() {
                  //   // _hasError = true;
                  // });
                  return 'Pin cannot empty.';
                }
                // setState(() {
                //   // _hasError = false;
                // });
                return null;
              },
              cursor: Cursor(
                width: 2,
                color: Colors.white,
                radius: const Radius.circular(1),
                enabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
