import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/create_pin_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/custom_dialog_box.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhoneVerification extends StatefulWidget {
  PhoneVerification({
    Key? key,
    required this.phone,
  }) : super(key: key);

  final String phone;

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  /// [_pinEditingController] for taking the OTP pin.
  final _pinEditingController = TextEditingController();

  Timer? _timer;
  int _start = 60;

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //---> Defining all the required Mobx Stores
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    // final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    double height = ConstantWidget.getScreenPercentSize(context, 18);

    return Scaffold(
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
          padding:
              EdgeInsets.all(ConstantWidget.getScreenPercentSize(context, 2.5)),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              ),

              //---> Logo widget
              MedLogo(height: height),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 5),
              ),

              //---> Pin input
              Center(
                child: Observer(builder: (_) {
                  return PinInput(
                    pinEditingController: _pinEditingController,
                    isObscure: false,
                    action: TextInputAction.go,
                    // enable: _enable,
                    onSubmit: (value) async {
                      final i = await store.verifyOTP(
                        mobile: widget.phone,
                        otp: value,
                      );
                      // int i = 1;
                      // print(i);
                      // _pinEditingController.clear();
                      if (i == 1) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                header: 'Success',
                                description: 'Successfully Verified!',
                                image: 'security.png',
                                buttonText: 'Continue',
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
                              return CustomAlertDialog(
                                  header: 'Failure',
                                  image: 'security.png',
                                  description:
                                      'Failed to verify please try again',
                                  func: () {
                                    Navigator.pop(context);
                                  },
                                  buttonText: 'Cancel');
                            });
                      }
                    },
                    label: 'OTP',
                  );
                }),
              ),
              SizedBox(
                height: safeBlockVertical(context: context) * 5,
              ),

              //---> OTP verfiy button
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: safeBlockVertical(context: context) * 9),
                child: Column(
                  children: [
                    // Observer(builder: (_) {
                    //   final state = store.buttonState;

                    //   switch (state) {
                    //     case ButtonState.LOADING:
                    //       return CircularProgressIndicator(
                    //         color: ConstantData.mainTextColor,
                    //       );
                    //     case ButtonState.SUCCESS:
                    //       return InkWell(
                    //         onTap: () async {
                    //           final i = await store.verifyOTP(
                    //             mobile: widget.phone,
                    //             otp: _pinEditingController.text.trim(),
                    //           );
                    //           // print(i);
                    //           _pinEditingController.clear();
                    //           if (i == 1) {
                    //             showDialog(
                    //                 context: context,
                    //                 builder: (BuildContext context) {
                    //                   return Dialog(
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                           BorderRadius.circular(20),
                    //                     ),
                    //                     elevation: 0,
                    //                     backgroundColor: ConstantData.bgColor,
                    //                     child: Stack(
                    //                       children: <Widget>[
                    //                         Container(
                    //                           padding: const EdgeInsets.only(
                    //                               left: ConstantData.padding,
                    //                               top: ConstantData
                    //                                       .avatarRadius +
                    //                                   ConstantData.padding,
                    //                               right: ConstantData.padding,
                    //                               bottom: ConstantData.padding),
                    //                           margin: const EdgeInsets.only(
                    //                               top: ConstantData
                    //                                   .avatarRadius),
                    //                           child: Column(
                    //                             mainAxisSize: MainAxisSize.min,
                    //                             children: <Widget>[
                    //                               ConstantWidget.getCustomText(
                    //                                   'Success',
                    //                                   ConstantData
                    //                                       .mainTextColor,
                    //                                   1,
                    //                                   TextAlign.center,
                    //                                   FontWeight.w600,
                    //                                   20),
                    //                               const SizedBox(
                    //                                 height: 10,
                    //                               ),
                    //                               ConstantWidget.getCustomText(
                    //                                   'Successfully verified!',
                    //                                   ConstantData
                    //                                       .mainTextColor,
                    //                                   2,
                    //                                   TextAlign.center,
                    //                                   FontWeight.normal,
                    //                                   14),
                    //                               const SizedBox(
                    //                                 height: 22,
                    //                               ),
                    //                               Container(
                    //                                 margin:
                    //                                     const EdgeInsets.only(
                    //                                         left: 15,
                    //                                         right: 15),
                    //                                 width: double.infinity,
                    //                                 child: InkWell(
                    //                                   onTap: () {
                    //                                     Navigator
                    //                                         .pushReplacement(
                    //                                       context,
                    //                                       MaterialPageRoute(
                    //                                         builder: (_) =>
                    //                                             Provider.value(
                    //                                           value: store
                    //                                             ..init(),
                    //                                           child: Provider
                    //                                               .value(
                    //                                             value:
                    //                                                 productStore,
                    //                                             child: Provider
                    //                                                 .value(
                    //                                               value:
                    //                                                   profileStore,
                    //                                               child: Provider
                    //                                                   .value(
                    //                                                 value:
                    //                                                     bottomNavigationStore,
                    //                                                 child:
                    //                                                     SignInPage(),
                    //                                               ),
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     );
                    //                                   },
                    //                                   child: ConstantWidget
                    //                                       .getButtonWidget(
                    //                                           context,
                    //                                           'Continue',
                    //                                           ConstantData
                    //                                               .primaryColor),
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         Positioned(
                    //                           top: 10,
                    //                           left: ConstantData.padding,
                    //                           right: ConstantData.padding,
                    //                           child: CircleAvatar(
                    //                             backgroundColor:
                    //                                 Colors.transparent,
                    //                             radius:
                    //                                 ConstantData.avatarRadius,
                    //                             child: ClipRRect(
                    //                                 borderRadius:
                    //                                     const BorderRadius.all(
                    //                                         Radius.circular(
                    //                                             ConstantData
                    //                                                 .avatarRadius)),
                    //                                 child: Image.asset(
                    //                                   ConstantData.assetsPath +
                    //                                       "security.png",
                    //                                   color: ConstantData
                    //                                       .mainTextColor,
                    //                                 )),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   );
                    //                 });
                    //             // Navigator.pushReplacement(
                    //             //     context,
                    //             //     MaterialPageRoute(
                    //             //       builder: (context) => Provider.value(
                    //             //           value: store, child: SignInPage()),
                    //             //     ));
                    //           } else {
                    //             showDialog(
                    //                 context: context,
                    //                 builder: (BuildContext context) {
                    //                   return CustomDialogBox(
                    //                     title: "Error!",
                    //                     descriptions: "Please try again!",
                    //                     text: "Continue",
                    //                     func: () async {
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   );
                    //                 });
                    //           }
                    //         },
                    //         child: ConstantWidget.getButtonWidget(
                    //             context, 'Verify', ConstantData.primaryColor),
                    //       );
                    //     case ButtonState.ERROR:
                    //       return ConstantWidget.getButtonWidget(
                    //           context, 'Verify', ConstantData.primaryColor);
                    //   }
                    // }),

                    //---> Resend button
                    SizedBox(
                      height: safeBlockVertical(context: context) * 3,
                    ),
                    Column(
                      children: [
                        if (_start > 0)
                          ConstantWidget.getCustomText(
                            'Resend OTP in 0:${_start}s',
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.center,
                            FontWeight.w500,
                            font18Px(context: context),
                          ),
                        if (_start == 0)
                          // InkWell(
                          //   onTap: () async {
                          //     _pinEditingController.clear();
                          //     await store.getOTP(
                          //         mobile: widget.phone, context: context);
                          //     _start = 60;
                          //     _startTimer();
                          //   },
                          //   child: ConstantWidget.getButtonWidget(
                          //     context,
                          //     'Resend',
                          //     ConstantData.primaryColor,
                          //   ),
                          // ),
                          Container(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 7.5),
                            width:
                                ConstantWidget.getWidthPercentSize(context, 40),
                            margin: EdgeInsets.symmetric(
                                vertical: ConstantWidget.getScreenPercentSize(
                                    context, 1.2)),
                            decoration: BoxDecoration(
                              color: ConstantData.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  ConstantWidget.getPercentSize(height, 20),
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () async {
                                _pinEditingController.clear();
                                await store.getOTP(
                                    mobile: widget.phone, context: context);
                                _start = 60;
                                _startTimer();
                              },
                              child: Center(
                                child: ConstantWidget.getDefaultTextWidget(
                                  'Resend',
                                  TextAlign.center,
                                  FontWeight.w600,
                                  font22Px(context: context),
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )

                    // Observer(builder: (_) {
                    //   final state = store.buttonState;

                    //   switch (state) {
                    //     case ButtonState.LOADING:
                    //       return CircularProgressIndicator(
                    //         color: ConstantData.primaryColor,
                    //       );
                    //     case ButtonState.SUCCESS:
                    //       return Column(
                    //         children: [
                    //           if (_start > 0)
                    //             ConstantWidget.getCustomText(
                    //               'Resend OTP in 0:${_start}s',
                    //               ConstantData.mainTextColor,
                    //               1,
                    //               TextAlign.center,
                    //               FontWeight.w500,
                    //               font18Px(context: context),
                    //             ),
                    //           if (_start == 0)
                    //             InkWell(
                    //               onTap: () async {
                    //                 _pinEditingController.clear();
                    //                 await store.getOTP(
                    //                     mobile: widget.phone, context: context);
                    //                 _start = 60;
                    //                 _startTimer();
                    //               },
                    //               child: ConstantWidget.getButtonWidget(
                    //                 context,
                    //                 'Resend',
                    //                 ConstantData.primaryColor,
                    //               ),
                    //             ),
                    //         ],
                    //       );
                    //     case ButtonState.ERROR:
                    //       return InkWell(
                    //         onTap: () async {
                    //           await store.getOTP(
                    //               mobile: widget.phone, context: context);
                    //           _start = 60;
                    //           _startTimer();
                    //           _pinEditingController.clear();
                    //         },
                    //         child: ConstantWidget.getButtonWidget(
                    //           context,
                    //           'Resend',
                    //           ConstantData.primaryColor,
                    //         ),
                    //       );
                    //   }
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

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.header,
    required this.image,
    required this.description,
    required this.func,
    required this.buttonText,
  }) : super(key: key);

  // final LoginStore store;
  // final ProductsStore productStore;
  // final ProfileStore profileStore;
  // final BottomNavigationStore bottomNavigationStore;
  // final OrderHistoryStore orderHistoryStore;
  final String header;
  final String description;
  final String buttonText;
  final String image;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: ConstantData.bgColor,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                left: ConstantData.padding,
                top: ConstantData.avatarRadius + ConstantData.padding,
                right: ConstantData.padding,
                bottom: ConstantData.padding),
            margin: const EdgeInsets.only(top: ConstantData.avatarRadius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstantWidget.getCustomText(header, ConstantData.mainTextColor,
                    1, TextAlign.center, FontWeight.w600, 20),
                const SizedBox(
                  height: 10,
                ),
                ConstantWidget.getCustomText(
                    description,
                    ConstantData.mainTextColor,
                    2,
                    TextAlign.center,
                    FontWeight.normal,
                    14),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: InkWell(
                    onTap: func,
                    child: ConstantWidget.getButtonWidget(
                        context, buttonText, ConstantData.primaryColor),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: ConstantData.padding,
            right: ConstantData.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: ConstantData.avatarRadius,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(ConstantData.avatarRadius)),
                  child: Image.asset(
                    "${ConstantData.assetsPath}$image",
                    color: ConstantData.mainTextColor,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class MedLogo extends StatelessWidget {
  /// Mederpha logo widget [MedLogo]
  const MedLogo({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "${ConstantData.assetsPath}med_logo_text_img.png",
        height: height,
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  /// 4-pin input [PinInputTextField]
  const PinInput({
    Key? key,
    required this.label,
    required this.pinEditingController,
    required this.isObscure,
    required this.action,
    this.onSubmit,
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
  final ValueSetter<String>? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: safeBlockVertical(context: context) * 2,
          horizontal: blockSizeHorizontal(context: context) * 5),
      child: SizedBox(
        width: safeBlockHorizontal(context: context) * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getTextWidget(
              '$label :',
              ConstantData.mainTextColor,
              TextAlign.center,
              FontWeight.w600,
              font18Px(context: context) * 1.2,
            ),
            SizedBox(
              height: safeBlockVertical(context: context) * 2,
            ),
            PinCodeTextField(
              cursorColor: ConstantData.mainTextColor,
              // cursorHeight: ConstantWidget.getWidthPercentSize(context, 20),
              // cursorWidth: blockSizeHorizontal(context: context) * 4,
              textStyle: TextStyle(
                color: ConstantData.mainTextColor,
                fontSize: font18Px(context: context),
                fontWeight: FontWeight.w600,
              ),
              obscureText: isObscure,
              obscuringCharacter: '*',
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 1,

                activeColor: ConstantData.clrBorder,
                disabledColor: ConstantData.clrBorder,
                inactiveColor: ConstantData.clrBorder,
                selectedColor: ConstantData.clrBorder,
                errorBorderColor: ConstantData.clrBorder,
                activeFillColor: ConstantData.bgColor,
                inactiveFillColor: ConstantData.bgColor,
                selectedFillColor: ConstantData.bgColor,
                fieldWidth: ConstantWidget.getWidthPercentSize(context, 15),
                // fieldHeight: ConstantWidget.getScreenPercentSize(context, 20),
              ),
              keyboardType: TextInputType.number,
              appContext: context,
              length: 4,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (v) {},
              onCompleted: onSubmit,
            ),
            // PinInputTextFormField(
            //   // key: _formKey,
            //   pinLength: 4,

            //   decoration: BoxLooseDecoration(
            //     textStyle: TextStyle(
            //         color: ConstantData.mainTextColor,
            //         fontFamily: ConstantData.fontFamily,
            //         fontWeight: FontWeight.w600,
            //         fontSize: font18Px(context: context)),

            //     strokeColorBuilder: PinListenColorBuilder(
            //         ConstantData.textColor, ConstantData.primaryColor),

            //     obscureStyle: ObscureStyle(
            //       isTextObscure: isObscure,
            //       obscureText: '*',
            //     ),
            //     // hintText: _kDefaultHint,
            //   ),
            //   controller: pinEditingController,
            //   textInputAction: action,
            //   enabled: true,
            //   keyboardType: TextInputType.number,
            //   textCapitalization: TextCapitalization.characters,
            //   onSubmit: onSubmit,

            //   onChanged: (pin) {
            //     // setState(() {
            //     //   debugPrint('onChanged execute. pin:$pin');
            //     // });
            //   },
            //   onSaved: (pin) {
            //     // print('onSaved pin:$pin');
            //   },
            //   validator: (pin) {
            //     if (pin!.isEmpty) {
            //       // setState(() {
            //       //   // _hasError = true;
            //       // });
            //       return 'Pin cannot empty.';
            //     }
            //     // setState(() {
            //     //   // _hasError = false;
            //     // });
            //     return null;
            //   },
            //   cursor: Cursor(
            //     width: 2,
            //     color: Colors.white,
            //     radius: const Radius.circular(1),
            //     enabled: true,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
