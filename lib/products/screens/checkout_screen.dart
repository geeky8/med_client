import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medrpha_customer/bottom_navigation/screens/home_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/repository/order_history_repository.dart';
import 'package:medrpha_customer/order_history/screens/order_history_details_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/online_payment_bottom_sheet.dart';
import 'package:medrpha_customer/products/utils/order_dialog.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({
    Key? key,
  }) : super(key: key);

  // Future<bool> _requestPop() {

  // Timer? _timer;
  // int _start = 300;

  // void _startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double leftMargin = blockSizeHorizontal(context: context) * 4;
    double topMargin = blockSizeVertical(context: context) * 2;

    final _profileStore = context.read<ProfileStore>();

    double cellHeight = MediaQuery.of(context).size.width * 0.2;

    final _productStore = context.read<ProductsStore>();
    final _loginStore = context.read<LoginStore>();
    final _orderHistoryStore = context.read<OrderHistoryStore>();
    final _bottomNavigationStore = context.read<BottomNavigationStore>();

    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar:
            ConstantWidget.customAppBar(context: context, title: 'Checkout'),
        // appBar: AppBar(
        //   elevation: 0,
        //   // centerTitle: true,
        //   backgroundColor: ConstantData.primaryColor,
        //   title: ConstantWidget.getCustomTextWithoutAlign(
        //     'Checkout',
        //     ConstantData.bgColor,
        //     FontWeight.w600,
        //     font22Px(context: context),
        //   ),
        //   leading: Builder(
        //     builder: (BuildContext context) {
        //       return IconButton(
        //         icon: const Icon(
        //           Icons.keyboard_backspace_outlined,
        //           // color: ConstantData.bg,
        //         ),
        //         color: ConstantData.bgColor,
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       );
        //     },
        //   ),
        // ),
        bottomNavigationBar: ConstantWidget.getBottomButton(
          context: context,
          func: () async {
            // _startTimer();
            // await _loginStore.getUserStatus();
            // if (_loginStore.loginModel.adminStatus) {
            //   if (_productStore.paymentOptions == PaymentOptions.ONLINE) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Provider.value(
                  value: _productStore,
                  child: Provider.value(
                    value: _profileStore,
                    child: Provider.value(
                      value: _orderHistoryStore,
                      child: Provider.value(
                        value: _loginStore,
                        child: Provider.value(
                          value: _bottomNavigationStore,
                          child: OnlinePaymentScreen(
                            model: _productStore.cartModel,
                            profileModel: _profileStore.profileModel,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            //   } else if (_productStore.paymentOptions ==
            //           PaymentOptions.PAYLATER &&
            //       !_loginStore.loginModel.payLater) {
            //     final snackBar = ConstantWidget.customSnackBar(
            //         text: 'Your paylater has been deactivated',
            //         context: context);
            //     // ignore: use_build_context_synchronously
            //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //   } else {
            //     await _productStore.successOrder(
            //       context: context,
            //       loginStore: _loginStore,
            //       profileStore: _profileStore,
            //       bottomNavigationStore: _bottomNavigationStore,
            //       orderHistoryStore: _orderHistoryStore,
            //       productsStore: _productStore,
            //     );
            //     // final status = await _productStore.checkout(
            //     //   context: context,
            //     //   func: () {},
            //     // );
            //     // if (status != '') {
            //     //   await _productStore.getCartItems();
            //     //   await _orderHistoryStore.getOrdersList();
            //     //   // ignore: use_build_context_synchronously
            //     //   Navigator.pushReplacement(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //       builder: (_) => Provider.value(
            //     //         value: _productStore,
            //     //         child: Provider.value(
            //     //           value: _loginStore,
            //     //           child: Provider.value(
            //     //             value: _profileStore,
            //     //             child: Provider.value(
            //     //               value: _orderHistoryStore..getOrdersList(),
            //     //               child: Provider.value(
            //     //                 value: _bottomNavigationStore,
            //     //                 child: const HomeScreen(),
            //     //               ),
            //     //             ),
            //     //           ),
            //     //         ),
            //     //       ),
            //     //     ),
            //     //   );
            //     //   showDialog(
            //     //     context: context,
            //     //     builder: (context) => OrderDialog(
            //     //       func: () async {
            //     //         final repo = OrderHistoryRepository();
            //     //         final orderHistoryResponseModel =
            //     //             await repo.getOrdersResponseModel(orderId: status);

            //     //         // print('----orderId $status');

            //     //         final orderHistoryModel = await repo.getListOrdersHistory(
            //     //           orderNo: orderHistoryResponseModel.orderNo,
            //     //         );

            //     //         // print(
            //     //         //     // '-order payment status -${orderHistoryModel.first.paymentStatusType.name}');
            //     //         // ignore: use_build_context_synchronously
            //     //         Navigator.pop(context);
            //     //         // ignore: use_build_context_synchronously
            //     //         Navigator.push(
            //     //           context,
            //     //           MaterialPageRoute(
            //     //             builder: (_) => Provider.value(
            //     //               value: _orderHistoryStore,
            //     //               child: OrderHistoryDetailsScreen(
            //     //                 model: orderHistoryModel.first,
            //     //               ),
            //     //             ),
            //     //           ),
            //     //         );
            //     //       },
            //     //       image: 'order-confirmed.png',
            //     //       text: 'Thank you for placing your order',
            //     //       label: 'Check status',
            //     //     ),
            //     //   );
            //     // } else {
            //     //   showDialog(
            //     //     context: context,
            //     //     builder: (context) => OrderDialog(
            //     //       func: () {
            //     //         Navigator.pop(context);
            //     //       },
            //     //       image: 'online-payment-error.png',
            //     //       text:
            //     //           'Oops...something went wrong. If money is deducted it will be refunded to your account.',
            //     //       label: 'Cancel',
            //     //     ),
            //     //   );
            //     //   final snackBar = ConstantWidget.customSnackBar(
            //     //       text: 'Failed to place the order', context: context);
            //     //   // ignore: use_build_context_synchronously
            //     //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //     // }
            //   }
            // } else {
            //   final snackBar = ConstantWidget.customSnackBar(
            //       text: 'Your account has been deactivated', context: context);
            //   // ignore: use_build_context_synchronously
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // }
          },
          label: 'Confirm',
        ),
        body: Stack(
          children: [
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loginStore.getUserStatus();
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      vertical: blockSizeVertical(context: context) * 2),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: blockSizeVertical(context: context) * 2,
                      ),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: leftMargin,
                          ),
                          itemCount: _productStore.cartModel.productList.length,
                          itemBuilder: (_, index) {
                            return Row(
                              children: [
                                Container(
                                  height: ConstantWidget.getScreenPercentSize(
                                      context, 8),
                                  width: ConstantWidget.getWidthPercentSize(
                                      context, 16),
                                  padding: EdgeInsets.all(
                                      blockSizeHorizontal(context: context) *
                                          2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        font18Px(context: context)),
                                    border: Border.all(
                                      color: ConstantData.borderColor,
                                      width: 1.2,
                                    ),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          ConstantData.productUrl +
                                              _productStore
                                                  .cartModel
                                                  .productList[index]
                                                  .productImg,
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(12),
                                //   child: CachedNetworkImage(
                                //     imageUrl: ConstantData.productUrl +
                                //         _productStore.cartModel
                                //             .productList[index].productImg,
                                //     height: ConstantWidget.getScreenPercentSize(
                                //         context, 7),
                                //     width: ConstantWidget.getWidthPercentSize(
                                //         context, 14),
                                //     fit: BoxFit.fill,
                                //   ),
                                // ),
                                const Spacer(),
                                Expanded(
                                  flex: 15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstantWidget.getCustomText(
                                        _productStore.cartModel
                                            .productList[index].productName,
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w600,
                                        font15Px(context: context) * 1.2,
                                      ),
                                      ConstantWidget.getCustomText(
                                        ' X ${_productStore.cartModel.productList[index].cartQuantity}',
                                        Colors.black45,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w500,
                                        font15Px(context: context) * 1.1,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ConstantWidget.getCustomText(
                                  '₹${_productStore.cartModel.productList[index].subTotal}',
                                  ConstantData.mainTextColor,
                                  1,
                                  TextAlign.center,
                                  FontWeight.w600,
                                  font15Px(context: context) * 1.2,
                                )
                              ],
                            );
                          }),
                    ),
                    Divider(
                      color: ConstantData.cellColor,
                      thickness: blockSizeVertical(context: context) * 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: leftMargin,
                        vertical: topMargin,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                'Address',
                                ConstantData.mainTextColor,
                                TextAlign.start,
                                FontWeight.w600,
                                font18Px(context: context) * 1.2,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context) * 1.5,
                          ),
                          Observer(builder: (_) {
                            return InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstantWidget.getCustomText(
                                              _profileStore.profileModel
                                                  .firmInfoModel.address,
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w400,
                                              font15Px(context: context) * 1.1,
                                            ),
                                            SizedBox(
                                              height: blockSizeVertical(
                                                  context: context),
                                            ),
                                            ConstantWidget.getCustomText(
                                              '${_profileStore.getCityName(cityId: int.parse(_profileStore.profileModel.firmInfoModel.city))} , ${_profileStore.getState(stateId: int.parse(_profileStore.profileModel.firmInfoModel.state))} - ${_profileStore.getArea(areaId: int.parse(_profileStore.profileModel.firmInfoModel.pin))}',
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w400,
                                              font15Px(context: context) * 1.1,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                // _selectedAddress = index;
                                // setState(() {});
                              },
                            );
                          }),

                          // SizedBox(
                          //   height: ConstantWidget.getScreenPercentSize(context, 3),
                          // ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ConstantData.cellColor,
                      thickness: blockSizeVertical(context: context) * 2,
                    ),
                    // Divider(
                    //   color: ConstantData.cellColor,
                    //   thickness:
                    //       ConstantWidget.getScreenPercentSize(context, 2),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: leftMargin,
                    //     vertical: topMargin,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           ConstantWidget.getTextWidget(
                    //             'Options',
                    //             ConstantData.mainTextColor,
                    //             TextAlign.start,
                    //             FontWeight.w600,
                    //             font18Px(context: context) * 1.2,
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: blockSizeVertical(context: context) * 1.5,
                    //       ),
                    //       Column(
                    //         children: [
                    //           PaymentOptionsWidget(
                    //             productStore: _productStore,
                    //             logo: 'mastercard.png',
                    //             logo1: 'visa.png',
                    //             // logo2: 'razorpay.png',
                    //             label: 'Online Payment',
                    //             options: PaymentOptions.ONLINE,
                    //           ),
                    //           Offstage(
                    //             offstage: !(_loginStore.loginModel.payLater),
                    //             child: PaymentOptionsWidget(
                    //               productStore: _productStore,
                    //               logo: 'paylater.jpg',
                    //               label: 'Pay-Later',
                    //               options: PaymentOptions.PAYLATER,
                    //             ),
                    //           ),
                    //           PaymentOptionsWidget(
                    //             productStore: _productStore,
                    //             logo: 'money.png',
                    //             label: 'Pay On Delivery',
                    //             options: PaymentOptions.PAYONDELIVERY,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: ConstantData.cellColor,
                    //   thickness: blockSizeVertical(context: context) * 2,
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: leftMargin, vertical: topMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstantWidget.getCustomText(
                            'Details',
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            font18Px(context: context) * 1.2,
                          ),
                          SizedBox(
                            height:
                                ConstantWidget.getScreenPercentSize(context, 3),
                          ),
                          Row(
                            children: [
                              ConstantWidget.getCustomText(
                                'Item Total',
                                Colors.black45,
                                1,
                                TextAlign.center,
                                FontWeight.w500,
                                font15Px(context: context) * 1.1,
                              ),
                              const Spacer(),
                              ConstantWidget.getCustomText(
                                '₹${_productStore.cartModel.totalSalePrice}',
                                Colors.black45,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font15Px(context: context) * 1.1,
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            height: blockSizeVertical(context: context) * 2.5,
                          ),
                          Row(
                            children: [
                              ConstantWidget.getCustomText(
                                'Amount Payable',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font15Px(context: context) * 1.25,
                              ),
                              const Spacer(),
                              ConstantWidget.getCustomText(
                                '₹${_productStore.cartModel.totalSalePrice}',
                                ConstantData.primaryColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font15Px(context: context) * 1.30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_productStore.checkoutState == StoreState.LOADING)
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
        ),
      );
    });
  }
}

class PaymentOptionsWidget extends StatelessWidget {
  const PaymentOptionsWidget({
    Key? key,
    required ProductsStore productStore,
    required this.logo,
    required this.label,
    required this.options,
    this.logo1,
    this.logo2,
  })  : _productStore = productStore,
        super(key: key);

  final ProductsStore _productStore;
  final String logo;
  final String? logo1;
  final String? logo2;
  final String label;
  final PaymentOptions options;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: blockSizeVertical(context: context),
        ),
        child: Row(
          children: [
            Row(
              children: [
                // Container(
                //   decoration: const BoxDecoration(shape: BoxShape.circle),
                //   height: blockSizeVertical(context: context) * 4,
                //   width: blockSizeHorizontal(context: context) * 7,
                //   child: Image.asset(
                //     ConstantData.assetsPath + logo,
                //     fit: BoxFit.fill,
                //   ),
                // ),
                // if (logo1 != null)
                //   Container(
                //     decoration: const BoxDecoration(shape: BoxShape.circle),
                //     height: blockSizeVertical(context: context) * 5,
                //     width: blockSizeHorizontal(context: context) * 7,
                //     child: Image.asset(ConstantData.assetsPath + (logo1 ?? '')),
                //   ),
                // if (logo2 != null)
                //   Container(
                //     decoration: const BoxDecoration(shape: BoxShape.circle),
                //     height: blockSizeVertical(context: context) * 5,
                //     width: blockSizeHorizontal(context: context) * 7,
                //     child: Image.asset(ConstantData.assetsPath + (logo2 ?? '')),
                //   ),
                // SizedBox(
                //   width: blockSizeHorizontal(context: context),
                // ),
                ConstantWidget.getCustomText(
                  label,
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  (_productStore.paymentOptions == options)
                      ? FontWeight.w600
                      : FontWeight.w400,
                  font15Px(context: context) * 1.1,
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _productStore.paymentOptions = options;
                // print('true');
              },
              child: Icon(
                (_productStore.paymentOptions == options)
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                size: font22Px(context: context) * 1.2,
                color: (_productStore.paymentOptions == options)
                    ? ConstantData.primaryColor
                    : ConstantData.textColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}
