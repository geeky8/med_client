// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/enums/payment_status_type.dart';
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
    required this.orderId,
  }) : super(key: key);

  final CartModel model;
  final ProfileModel profileModel;
  final String orderId;

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  // int seconds = 60;
  // int mins = 4;
  // late Timer timer;

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

  // _startTimer() async {
  //   const duration = Duration(seconds: 1);
  //   timer = Timer.periodic(duration, (timer) async {
  //     if (seconds - 1 == 0 && mins > 0) {
  //       if (mounted) {
  //         setState(() {
  //           mins -= 1;
  //           seconds = 60;
  //         });
  //       }
  //     } else if (seconds == 0 && mins == 0) {
  //       _relocateToHome();
  //       if (mounted) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       }
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           seconds -= 1;
  //         });
  //       }
  //     }
  //   });
  // }

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
      // orderId: widget.orderId,
    );
  }

  _handlePaymentFailure(PaymentFailureResponse response) {
    if (kDebugMode) {
      print('-----------Failure Payment-------- ${response.message}');
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

    print('----- paybale -${payment}');

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
    // _startTimer();
    // _openGateway(model: widget.model, profileModel: widget.profileModel);
    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    // timer.cancel();
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
        backgroundColor: ConstantData.bgColor,
        body: SafeArea(
          child: Observer(builder: (_) {
            print('my state --------------- ${productStore.checkoutState}');
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: blockSizeVertical(context: context) * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Spacer(),
                      // Divider(
                      //   color: ConstantData.cellColor,
                      //   thickness:
                      //       ConstantWidget.getScreenPercentSize(context, 2),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                blockSizeHorizontal(context: context) * 6,
                            vertical: blockSizeVertical(context: context),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConstantWidget.getTextWidget(
                                    'Select Payment Options',
                                    ConstantData.mainTextColor,
                                    TextAlign.start,
                                    FontWeight.w600,
                                    font22Px(context: context) * 1.1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: blockSizeVertical(context: context),
                              ),
                              const Divider(
                                thickness: 1.5,
                                // height: blockSizeVertical(context: context),
                              ),
                              SizedBox(
                                height: blockSizeVertical(context: context) * 4,
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
                                    offstage: !(loginStore.loginModel.payLater),
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
                      ),
                      // Divider(
                      //   color: ConstantData.cellColor,
                      //   thickness: blockSizeVertical(context: context) * 2,
                      // ),
                      // Expanded(
                      //   flex: 2,
                      //   child: Column(
                      //     children: [
                      //       ConstantWidget.getCustomText(
                      //         '$mins : ${(seconds < 10) ? 0 : ''}$seconds',
                      //         ConstantData.mainTextColor,
                      //         1,
                      //         TextAlign.center,
                      //         FontWeight.w600,
                      //         font25Px(context: context) * 2,
                      //       ),
                      //       SizedBox(
                      //         height: blockSizeVertical(context: context) * 4,
                      //       ),
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           // ConstantWidget.getCustomText(
                      //           //   'Note : ',
                      //           //   ConstantData.textColor,
                      //           //   1,
                      //           //   TextAlign.center,
                      //           //   FontWeight.w600,
                      //           //   font22Px(context: context),
                      //           // ),
                      //           // const Spacer(),
                      //           Expanded(
                      //             flex: 4,
                      //             child: ConstantWidget.getCustomText(
                      //               'If unable to complete the payment, try again before the countdown ends to successfully place the order else your order will stand to be cancelled',
                      //               ConstantData.textColor,
                      //               5,
                      //               TextAlign.center,
                      //               FontWeight.w600,
                      //               font18Px(context: context),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const Spacer(),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: blockSizeHorizontal(context: context) * 4,
                          // vertical: blockSizeVertical(context: context) * 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Observer(builder: (_) {
                                return ConstantWidget.getBottomButton(
                                  context: context,
                                  height: 7,
                                  func: () async {
                                    // if (mins != 0 && seconds != 0) {
                                    //----- Fetching user status
                                    // await loginStore.getUserStatus();
                                    productStore.checkoutState =
                                        StoreState.LOADING;
                                    //--------- Online Payment
                                    if (productStore.paymentOptions ==
                                        PaymentOptions.ONLINE) {
                                      openGateway(
                                        noOfProducts:
                                            productStore.cartModel.noOfProducts,
                                        payment: productStore.payableAmount,
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
                                          // orderId: widget.orderId,
                                        );
                                      }
                                    }
                                    productStore.checkoutState =
                                        StoreState.SUCCESS;
                                    // } else {
                                    //   final snackBar =
                                    //       ConstantWidget.customSnackBar(
                                    //           text: 'Time has been elapsed',
                                    //           context: context);
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(snackBar);
                                    // }
                                  },
                                  label: (productStore.paymentOptions ==
                                          PaymentOptions.ONLINE)
                                      ? 'Pay Now'
                                      : 'Place Order',
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                blockSizeHorizontal(context: context) * 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: ConstantWidget.getBottomButton(
                                context: context,
                                height: 7,
                                color: Colors.grey[200],
                                func: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ConstantWidget.alertDialog(
                                      context: _,
                                      buttonText: 'Cancel',
                                      title:
                                          'Sure you want to cancel the order?',
                                      func: () async {
                                        //
                                        // if (mins != 0 && seconds != 0) {
                                        Navigator.pop(context);
                                        productStore.checkoutState =
                                            StoreState.LOADING;
                                        await orderHistoryStore.cancelOrder(
                                          id: productStore.orderId,
                                          remarks:
                                              'cancelling order ${productStore.orderId}',
                                          context: context,
                                        );
                                        productStore.checkoutState =
                                            StoreState.SUCCESS;

                                        Navigator.pop(context);
                                        // } else {}

                                        // Navigator.pop(widget.checkoutContext);
                                      },
                                    ),
                                  );
                                },
                                labelColor: ConstantData.mainTextColor,
                                label: 'Cancel',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
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
                      child: ConstantWidget.loadingWidget(
                        size: blockSizeVertical(context: context) * 5,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
