// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/cart_model.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:medrpha_customer/products/screens/checkout_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'order_dialog.dart';

class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({
    Key? key,
    required this.profileModel,
    required this.model,
  }) : super(key: key);

  final CartModel model;
  final ProfileModel profileModel;

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  int seconds = 60;
  int mins = 4;
  late Timer timer;

  final _razorPay = Razorpay();

  _relocateToHome() async {
    final store = context.read<ProductsStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final profileStore = context.read<ProfileStore>();
    final loginStore = context.read<LoginStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    await store.getCartItems();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Provider.value(
          value: store,
          child: Provider.value(
            value: loginStore,
            child: Provider.value(
              value: profileStore,
              child: Provider.value(
                value: orderHistoryStore,
                child: Provider.value(
                  value: bottomNavigationStore,
                  child: const HomeScreen(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _startTimer() async {
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) async {
      if (seconds - 1 == 0 && mins > 0) {
        if (mounted) {
          setState(() {
            mins -= 1;
            seconds = 60;
          });
        }
      } else if (seconds == 0 && mins == 0) {
        _relocateToHome();
        if (mounted) {
          setState(() {
            timer.cancel();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            seconds -= 1;
          });
        }
      }
    });
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (kDebugMode) {
      print('-----------Success Payment-------- ${response.orderId}');
    }
    final store = context.read<ProductsStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final profileStore = context.read<ProfileStore>();
    final loginStore = context.read<LoginStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    await store.successOrder(
      context: context,
      loginStore: loginStore,
      profileStore: profileStore,
      bottomNavigationStore: bottomNavigationStore,
      orderHistoryStore: orderHistoryStore,
      productsStore: store,
    );
  }

  _handlePaymentFailure(PaymentFailureResponse response) {
    if (kDebugMode) {
      print('-----------Failure Payment-------- ${response.code}');
    }
    showDialog(
      context: context,
      builder: (_) => OrderDialog(
        func: () {
          Navigator.pop(context);
        },
        image: 'online-payment-error.png',
        label: 'Cancel',
        text: 'Oops...Something went wrong',
      ),
    );
  }

  _handlePaymentExternalWallet(PaymentSuccessResponse response) {
    if (kDebugMode) {
      print(
          '-----------Success Payment External wallet-------- ${response.signature}');
    }
  }

  void openGateway({
    required String payment,
    required ProfileModel profileModel,
    required int noOfProducts,
  }) async {
    final repo = ProductsRepository();
    final id = await repo.createOrder(
      payment: payment,
      noOfProducts: noOfProducts,
    );

    final phoneNo = await DataBox().readPhoneNo();
    final email = profileModel.firmInfoModel.email;

    var options = {
      'key': ConstantData.apiKey,
      'amount': double.parse(payment) * 100,
      'name': 'Mederpha',
      'order_id': id,
      'description': 'Online Medical Hub',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': phoneNo,
        'email': email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    _razorPay.open(options);
  }

  @override
  void initState() {
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentFailure);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentExternalWallet);
    _startTimer();
    // _openGateway(model: widget.model, profileModel: widget.profileModel);
    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final loginStore = context.read<LoginStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    double leftMargin = blockSizeHorizontal(context: context) * 4;
    double topMargin = blockSizeVertical(context: context) * 2;

    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (_) => ConstantWidget.alertDialog(
            context: context,
            buttonText: 'Cancel',
            title: 'Sure you want to cancel the payment?',
            func: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigator.pop(widget.checkoutContext);
            },
          ),
        );
        return Future.delayed(const Duration(seconds: 1), () {
          return true;
        });
      },
      child: Scaffold(
        body: Observer(builder: (_) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: ConstantData.bgColor),
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 4,
                  vertical: blockSizeVertical(context: context) * 6,
                  // vertical: ConstantWidget.getWidthPercentSize(context, 40),
                ),
                // height: screenHeight(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          ConstantWidget.getCustomText(
                            '$mins : ${(seconds < 10) ? 0 : ''}$seconds',
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            font25Px(context: context) * 2,
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context) * 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ConstantWidget.getCustomText(
                              //   'Note : ',
                              //   ConstantData.textColor,
                              //   1,
                              //   TextAlign.center,
                              //   FontWeight.w600,
                              //   font22Px(context: context),
                              // ),
                              // const Spacer(),
                              Expanded(
                                flex: 4,
                                child: ConstantWidget.getCustomText(
                                  'If unable to complete the payment, try again before the countdown ends to successfully place the order else your order will stand to be cancelled',
                                  ConstantData.textColor,
                                  5,
                                  TextAlign.center,
                                  FontWeight.w500,
                                  font18Px(context: context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      // flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: ConstantWidget.getBottomButton(
                                context: context,
                                func: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ConstantWidget.alertDialog(
                                      context: context,
                                      buttonText: 'Cancel',
                                      title:
                                          'Sure you want to cancel the payment?',
                                      func: () {
                                        if (mins != 0 && seconds != 0) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {}

                                        // Navigator.pop(widget.checkoutContext);
                                      },
                                    ),
                                  );
                                },
                                label: 'Cancel'),
                          ),
                          Expanded(
                            child: ConstantWidget.getBottomButton(
                              context: context,
                              func: () async {
                                if (mins != 0 && seconds != 0) {
                                  //----- Fetching user status
                                  await loginStore.getUserStatus();

                                  if (loginStore.loginModel.adminStatus) {
                                    //--------- Online Payment
                                    if (productStore.paymentOptions ==
                                        PaymentOptions.ONLINE) {
                                      openGateway(
                                        noOfProducts:
                                            productStore.cartModel.noOfProducts,
                                        payment: productStore
                                            .cartModel.totalSalePrice,
                                        profileModel: profileStore.profileModel,
                                      );
                                    }
                                    // else{

                                    // }//-------------- Payment with Paylater
                                    else {
                                      if (productStore.paymentOptions ==
                                              PaymentOptions.PAYLATER &&
                                          !loginStore.loginModel.payLater) {
                                        final snackBar =
                                            ConstantWidget.customSnackBar(
                                                text:
                                                    'Your paylater has been deactivated',
                                                context: context);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } //---------- Payment with pay on delivery
                                      else {
                                        await productStore.successOrder(
                                          context: context,
                                          loginStore: loginStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          orderHistoryStore: orderHistoryStore,
                                          productsStore: productStore,
                                        );
                                      }
                                    }
                                  } else {
                                    final snackBar = ConstantWidget.customSnackBar(
                                        text:
                                            'Your account has been deactivated',
                                        context: context);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  final snackBar =
                                      ConstantWidget.customSnackBar(
                                          text: 'Time has been elapsed',
                                          context: context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              label: 'Pay Now',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Divider(
                            color: ConstantData.cellColor,
                            thickness:
                                ConstantWidget.getScreenPercentSize(context, 2),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: leftMargin,
                              vertical: topMargin,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ConstantWidget.getTextWidget(
                                      'Options',
                                      ConstantData.mainTextColor,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      font18Px(context: context) * 1.2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      blockSizeVertical(context: context) * 1.5,
                                ),
                                Column(
                                  children: [
                                    PaymentOptionsWidget(
                                      productStore: productStore,
                                      logo: 'mastercard.png',
                                      logo1: 'visa.png',
                                      // logo2: 'razorpay.png',
                                      label: 'Online Payment',
                                      options: PaymentOptions.ONLINE,
                                    ),
                                    // SizedBox(
                                    //   height: blockSizeVertical(context: context),
                                    // ),
                                    Offstage(
                                      offstage:
                                          !(loginStore.loginModel.payLater),
                                      child: PaymentOptionsWidget(
                                        productStore: productStore,
                                        logo: 'paylater.jpg',
                                        label: 'Pay-Later',
                                        options: PaymentOptions.PAYLATER,
                                      ),
                                    ),

                                    PaymentOptionsWidget(
                                      productStore: productStore,
                                      logo: 'money.png',
                                      label: 'Pay On Delivery',
                                      options: PaymentOptions.PAYONDELIVERY,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: ConstantData.cellColor,
                            thickness: blockSizeVertical(context: context) * 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (productStore.checkoutState == StoreState.LOADING)
                Container(
                  height: screenHeight(context: context),
                  width: screenWidth(context: context),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  child: Center(
                    child: LoadingAnimationWidget.twoRotatingArc(
                      color: ConstantData.primaryColor,
                      size: ConstantWidget.getScreenPercentSize(context, 10),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
