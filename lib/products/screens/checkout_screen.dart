// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/online_payment_bottom_sheet.dart';
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

    final profileStore = context.read<ProfileStore>();
    final productStore = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar:
            ConstantWidget.customAppBar(context: context, title: 'Checkout'),
        bottomNavigationBar: Container(
          height: ConstantWidget.getScreenPercentSize(context, 9),
          child: ConstantWidget.getBottomButton(
            context: context,
            height: 10,
            func: () async {
              // _startTimer();
              // await _loginStore.getUserStatus();
              // if (_loginStore.loginModel.adminStatus) {
              //   if (_productStore.paymentOptions == PaymentOptions.ONLINE) {
              productStore.checkoutState = StoreState.LOADING;
              final value = await productStore.checkout(context: context);
              productStore.checkoutState = StoreState.SUCCESS;

              // print('orderid------------------${productStore.orderId}');
              if (value != '') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Provider.value(
                      value: productStore..init(),
                      child: Provider.value(
                        value: profileStore,
                        child: Provider.value(
                          value: orderHistoryStore,
                          child: Provider.value(
                            value: loginStore,
                            child: Provider.value(
                              value: bottomNavigationStore,
                              child: OnlinePaymentScreen(
                                model: productStore.cartModel,
                                profileModel: profileStore.profileModel,
                                orderId: productStore.orderId,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            label: 'Confirm',
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await loginStore.getUserStatus();
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      vertical: blockSizeVertical(context: context) * 2),
                  physics: const BouncingScrollPhysics(),
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
                          itemCount: productStore.cartModel.productList.length,
                          itemBuilder: (_, index) {
                            return Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        blockSizeHorizontal(context: context) *
                                            3,
                                  ),
                                  child: Container(
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
                                                productStore
                                                    .cartModel
                                                    .productList[index]
                                                    .productImg,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstantWidget.getCustomText(
                                        productStore.cartModel
                                            .productList[index].productName,
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w600,
                                        font15Px(context: context) * 1.2,
                                      ),
                                      ConstantWidget.getCustomText(
                                        ' X ${productStore.cartModel.productList[index].cartQuantity}',
                                        Colors.black45,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w600,
                                        font15Px(context: context) * 1.1,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ConstantWidget.getCustomText(
                                  '₹${double.parse(productStore.cartModel.productList[index].subTotal).toStringAsFixed(4)}',
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
                                              profileStore.profileModel
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
                                              '${profileStore.getCityName(cityId: int.parse(profileStore.profileModel.firmInfoModel.city))} , ${profileStore.getState(stateId: int.parse(profileStore.profileModel.firmInfoModel.state))} - ${profileStore.getArea(areaId: int.parse(profileStore.profileModel.firmInfoModel.pin))}',
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
                                FontWeight.w600,
                                font15Px(context: context) * 1.1,
                              ),
                              const Spacer(),
                              ConstantWidget.getCustomText(
                                '₹${double.parse(productStore.cartModel.totalSalePrice).toStringAsFixed(4)}',
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
                                '₹${double.parse(productStore.cartModel.totalSalePrice).toStringAsFixed(4)}',
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
                  (_productStore.paymentOptions == options)
                      ? ConstantData.primaryColor
                      : ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  (_productStore.paymentOptions == options)
                      ? FontWeight.w600
                      : FontWeight.w400,
                  font18Px(context: context) * 1.1,
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
                size: font25Px(context: context) * 1.2,
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
