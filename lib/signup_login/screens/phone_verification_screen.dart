// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/create_pin_screen.dart';
import 'package:medrpha_customer/signup_login/screens/otp_verification_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhoneVerification extends StatefulWidget {
  const PhoneVerification({
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
              ConstantWidget.getCustomText(
                'Enter Code',
                ConstantData.mainTextColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font25Px(context: context),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 3),
              ),
              ConstantWidget.getCustomText(
                'We have sent a verification code to the phone',
                ConstantData.clrBorder,
                2,
                TextAlign.center,
                FontWeight.w600,
                font18Px(context: context) * 1.12,
              ),
              SizedBox(
                height: blockSizeHorizontal(context: context) * 2,
              ),
              ConstantWidget.getCustomText(
                '+91 ${widget.phone}',
                ConstantData.mainTextColor,
                2,
                TextAlign.center,
                FontWeight.w600,
                font22Px(context: context),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 5),
              ),

              //---> Pin input
              Center(
                child: PinInput(
                  pinEditingController: _pinEditingController,
                  isObscure: false,
                  pinShape: PinCodeFieldShape.circle,
                  action: TextInputAction.go,
                  // enable: _enable,
                  onSubmit: (value) async {
                    final i = await store.verifyOTP(
                      mobile: widget.phone,
                      otp: value,
                    );
                    if (i == 1) {
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
                                    child: const OTPSuccessFailure(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              header: 'Incorrect OTP',
                              description:
                                  'It looks like you entered incorrect verification code, please try again',
                              func: () async {
                                await store.getOTP(mobile: widget.phone);

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
                                                    value:
                                                        bottomNavigationStore,
                                                    child: Provider.value(
                                                      value: orderHistoryStore,
                                                      child: PhoneVerification(
                                                        phone: widget.phone,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )));
                              },
                              buttonText: 'Try Again',
                            );
                          });
                    }
                  },
                ),
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
                    //---> Resend button
                    SizedBox(
                      height: safeBlockVertical(context: context) * 3,
                    ),
                    Column(
                      children: [
                        if (_start > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstantWidget.getCustomText(
                                'Resend new code in  ',
                                ConstantData.clrBorder,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font18Px(context: context) * 1.1,
                              ),
                              ConstantWidget.getCustomText(
                                '0:${_start}s',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font18Px(context: context) * 1.15,
                              ),
                            ],
                          ),
                        if (_start == 0)
                          InkWell(
                            onTap: () async {
                              await store.getOTP(mobile: widget.phone);

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
                                                      phone: widget.phone,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )));
                            },
                            child: Container(
                              height: ConstantWidget.getScreenPercentSize(
                                  context, 7.5),
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 40),
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
    // required this.image,
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
  // final String image;
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
              // top: ConstantData.avatarRadius + ConstantData.padding,
              right: ConstantData.padding,
              bottom: ConstantData.padding,
            ),
            margin: const EdgeInsets.only(top: ConstantData.avatarRadius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstantWidget.getCustomText(header, ConstantData.mainTextColor,
                    2, TextAlign.center, FontWeight.w600, 20),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                ConstantWidget.getCustomText(
                  description,
                  ConstantData.mainTextColor,
                  2,
                  TextAlign.center,
                  FontWeight.w500,
                  font18Px(context: context),
                ),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: InkWell(
                    onTap: func,
                    child: ConstantWidget.getButtonWidget(
                      context,
                      buttonText,
                      ConstantData.primaryColor,
                    ),
                  ),
                )
              ],
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
        "${ConstantData.assetsPath}med_logo_text.png",
        height: height,
        width: screenWidth(context: context) / 1.2,
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  /// 4-pin input [PinInputTextField]
  const PinInput({
    Key? key,
    required this.pinEditingController,
    required this.isObscure,
    required this.action,
    this.onSubmit,
    this.unfocus,
    required this.pinShape,
    this.focusNode,
    this.func,
  }) :
        //  _pinEditingController = pinEditingController,
        //       _enable = enable,
        super(key: key);

  final TextEditingController pinEditingController;
  final bool isObscure;
  final Function? func;
  final TextInputAction action;
  final bool? unfocus;
  final ValueSetter<String>? onSubmit;
  final PinCodeFieldShape pinShape;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: safeBlockVertical(context: context) * 2,
          horizontal: blockSizeHorizontal(context: context) * 5),
      child: SizedBox(
        width: ConstantWidget.getWidthPercentSize(context, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              showCursor: false,
              controller: pinEditingController,
              focusNode: focusNode,
              obscuringCharacter: '*',
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 1,
                activeColor: ConstantData.primaryColor,
                disabledColor: ConstantData.clrBorder,
                inactiveColor: ConstantData.clrBorder,
                selectedColor: ConstantData.clrBorder,
                errorBorderColor: ConstantData.clrBorder,
                activeFillColor: ConstantData.bgColor,
                inactiveFillColor: ConstantData.bgColor,
                selectedFillColor: Colors.blueAccent,
                fieldWidth: ConstantWidget.getWidthPercentSize(context, 15),
                fieldHeight: ConstantWidget.getWidthPercentSize(context, 15),
              ),
              keyboardType: TextInputType.number,
              appContext: context,
              length: 4,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (v) {
                func;
              },
              onCompleted: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
