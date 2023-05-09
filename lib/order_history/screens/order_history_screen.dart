// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/order_status_type.dart';
import 'package:medrpha_customer/enums/payment_status_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/order_history/repository/order_history_repository.dart';
import 'package:medrpha_customer/order_history/screens/order_history_details_screen.dart';
import 'package:medrpha_customer/order_history/screens/search_orders.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';

import '../../bottom_navigation/store/bottom_navigation_store.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key, this.fromSettingsPage}) : super(key: key);

  final bool? fromSettingsPage;

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  // List<OrderHistoryModel> getUpdatedList({
  //   required OrderStatusType orderStatusType,
  //   required OrderHistoryStore store,
  // }) {
  //   final list = <OrderHistoryModel>[];
  //   for (final model in store.orders) {
  //     if (model.orderStatusType == orderStatusType) {
  //       list.add(model);
  //     }
  //   }
  //   return list;
  // }

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: ConstantWidget.customAppBar(
          context: context,
          title: 'ORDERS',
          isHome: (widget.fromSettingsPage ?? false) ? true : false,
          widgetList: [
            Observer(builder: (context) {
              final adminStatus = loginStore.loginModel.adminStatus;
              return Offstage(
                offstage: !adminStatus,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: blockSizeVertical(context: context) * 3,
                    right: blockSizeHorizontal(context: context) * 4,
                  ),
                  child: Observer(builder: (context) {
                    return InkWell(
                      onTap: () {
                        // orderHistoryStore.filter = !orderHistoryStore.filter;
                        // if (!orderHistoryStore.filter) {
                        //   orderHistoryStore.searchOrders
                        //     ..clear()
                        //     ..addAll(orderHistoryStore.allOrders);
                        // }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiProvider(
                              providers: [
                                Provider.value(value: store),
                                Provider.value(value: loginStore),
                                Provider.value(value: profileStore),
                                Provider.value(value: bottomNavigationStore),
                                Provider.value(value: orderHistoryStore),
                              ],
                              child: const SearchOrders(),
                            ),
                          ),
                        );
                      },
                      child: ConstantWidget.getCustomText(
                        'Search Orders',
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        font18Px(context: context),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        ),
        body: Observer(
          builder: (_) {
            return Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Observer(builder: (_) {
                        final adminStatus = loginStore.loginModel.adminStatus;
                        return Offstage(
                          offstage: adminStatus,
                          child: ConstantWidget.adminStatusbanner(context),
                        );
                      }),
                    ),
                    // Offstage(
                    //   offstage: (!orderHistoryStore.filter),
                    //   child: searchOrders(),
                    // ),
                    Observer(builder: (_) {
                      final adminStatus = loginStore.loginModel.adminStatus;
                      return Expanded(
                        child: Offstage(
                          offstage: !adminStatus,
                          child: listMyOrders(context),
                        ),
                      );
                    }),
                  ],
                ),
                if (store.checkoutState == StoreState.LOADING)
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
          },
        ));
  }

  Widget listMyOrders(BuildContext context) {
    final store = context.read<OrderHistoryStore>();
    final loginStore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();

    // int currentTab = 0;

    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: blockSizeVertical(context: context) * 2,
          horizontal: blockSizeHorizontal(context: context) * 2,
        ),
        child: Column(
          children: [
            Observer(builder: (_) {
              return TabBar(
                controller: tabController,
                physics: const ScrollPhysics(),
                indicatorColor: ConstantData.primaryColor,
                indicator: BoxDecoration(
                  color: ConstantData.primaryColor,
                  borderRadius: BorderRadius.circular(
                    font22Px(context: context),
                  ),
                ),
                isScrollable: true,
                unselectedLabelColor: ConstantData.mainTextColor,
                labelStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: font18Px(context: context),
                ),
                tabs: const [
                  // Tab(
                  //   text: 'ALL',
                  // ),
                  Tab(
                    text: 'LIVE',
                  ),
                  Tab(
                    text: 'DISPATCHED',
                  ),
                  Tab(
                    text: 'DELIVERED',
                  ),
                  Tab(
                    text: 'RETURNED/CANCELLED',
                  ),
                ],
                onTap: (tab) {
                  store.orderStatusTypeSelected = tab;
                },
              );
            }),
            Divider(
              color: ConstantData.cartColor,
              thickness: 1,
            ),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                // Column(
                //   children: [
                //     Expanded(
                //       child: Observer(builder: (context) {
                //         // if (store.searchOrders.isEmpty) {
                //         //   return const SizedBox();
                //         // }
                //         final list = (store.filter)
                //             ? store.searchOrders
                //             : store.allOrders;
                //         return ViewOrdersList(
                //           list: list,
                //           store: store,
                //           productsStore: productStore,
                //           loginStore: loginStore,
                //           profileStore: profileStore,
                //         );
                //       }),
                //     ),
                //   ],
                // ),
                Column(
                  children: [
                    Expanded(
                      child: Observer(builder: (_) {
                        // final list = store.liveOrders;
                        return ViewOrdersList(
                          list: store.liveOrders,
                          store: store,
                          productsStore: productStore,
                          loginStore: loginStore,
                          profileStore: profileStore,
                        );
                      }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Observer(builder: (_) {
                        return ViewOrdersList(
                          list: store.dispatchedOrders,
                          store: store,
                          productsStore: productStore,
                          loginStore: loginStore,
                          profileStore: profileStore,
                        );
                      }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Observer(builder: (_) {
                        return ViewOrdersList(
                          list: store.deliveredOrders,
                          store: store,
                          productsStore: productStore,
                          loginStore: loginStore,
                          profileStore: profileStore,
                        );
                      }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Observer(builder: (c_) {
                        return ViewOrdersList(
                          list: store.returnCancelledOrders,
                          store: store,
                          productsStore: productStore,
                          loginStore: loginStore,
                          profileStore: profileStore,
                        );
                      }),
                    ),
                  ],
                ),
              ]),
            ),
            // TabBarView(
            //   child: Observer(builder: (_) {
            //     final list = <OrderHistoryModel>[];
            //     final adminStatus = loginStore.loginModel.adminStatus;
            //     switch (store.orderStatusTypeSelected) {
            //       case 0:
            //         list
            //           ..clear()
            //           ..addAll(store.liveOrders);
            //         break;
            //       case 1:
            //         list
            //           ..clear()
            //           ..addAll(store.dispatchedOrders);
            //         break;
            //       case 2:
            //         list
            //           ..clear()
            //           ..addAll(store.deliveredOrders);
            //         break;
            //       case 3:
            //         list
            //           ..clear()
            //           ..addAll(store.returnCancelledOrders);
            //         break;
            //     }
            //     return Expanded(
            //       child: Offstage(
            //         offstage: !adminStatus,
            //         child: ViewOrdersList(
            //           list: list,
            //           store: store,
            //           productsStore: productStore,
            //           loginStore: loginStore,
            //           profileStore: profileStore,
            //         ),
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

// class CurrentOrderStatusTile extends StatelessWidget {
//   const CurrentOrderStatusTile({
//     Key? key,
//     required this.store,
//     required this.status,
//     required this.orderStatusType,
//   }) : super(key: key);

//   final OrderHistoryStore store;
//   final String status;
//   final OrderStatusType orderStatusType;

//   @override
//   Widget build(BuildContext context) {
//     return Observer(builder: (_) {
//       return Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: blockSizeHorizontal(context: context) * 4,
//         ),
//         child: InkWell(
//           onTap: () {
//             store.viewOrdersStatusType = orderStatusType;
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: blockSizeHorizontal(context: context) * 3,
//               vertical: blockSizeVertical(context: context),
//             ),
//             decoration: BoxDecoration(
//               color: (store.viewOrdersStatusType == orderStatusType)
//                   ? ConstantData.bgColor
//                   : ConstantData.cartColor,
//               borderRadius: BorderRadius.circular(15),
//               border: (store.viewOrdersStatusType == orderStatusType)
//                   ? Border.all(color: ConstantData.mainTextColor, width: 1.5)
//                   : Border.all(color: ConstantData.clrBlack20, width: 1.5),
//             ),
//             child: ConstantWidget.getCustomText(
//               status,
//               ConstantData.mainTextColor,
//               1,
//               TextAlign.center,
//               FontWeight.w600,
//               font15Px(context: context),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

class ViewOrdersList extends StatelessWidget {
  const ViewOrdersList({
    Key? key,
    required this.list,
    required this.store,
    required this.loginStore,
    required this.productsStore,
    required this.profileStore,
  }) : super(key: key);

  final List<OrderHistoryModel> list;
  final OrderHistoryStore store;
  final ProductsStore productsStore;
  final LoginStore loginStore;
  final ProfileStore profileStore;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (list.isEmpty)
          ? Center(
              child: ConstantWidget.errorWidget(
                context: context,
                height: 20,
                width: 15,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await store.getOrdersList();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  // return Divider(
                  //   thickness: 1,
                  //   color: ConstantData.mainTextColor,
                  // );
                  return SizedBox(
                    height: blockSizeVertical(context: context) * 2,
                  );
                },
                physics: const BouncingScrollPhysics(),
                // shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    vertical: blockSizeVertical(context: context)),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return OrderTile(
                    model: list[index],
                    store: store,
                    productsStore: productsStore,
                    loginStore: loginStore,
                    profileStore: profileStore,
                  );
                },
              ),
            ),
    );
  }
}

class OrderTile extends StatefulWidget {
  const OrderTile({
    Key? key,
    required this.model,
    required this.store,
    required this.loginStore,
    required this.productsStore,
    required this.profileStore,
  }) : super(key: key);

  final OrderHistoryModel model;
  final OrderHistoryStore store;
  final ProductsStore productsStore;
  final LoginStore loginStore;
  final ProfileStore profileStore;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  Color boxColor({required OrderStatusType orderStatus}) {
    if (orderStatus == OrderStatusType.CANCELLED) {
      return ConstantData.color1;
    }
    return Colors.green;
  }

  Color paymentBoxColor({required PaymentStatusType paymentStatus}) {
    switch (paymentStatus) {
      case PaymentStatusType.PAID:
        return Colors.green;
      case PaymentStatusType.UNPAID:
        return ConstantData.color1;
      case PaymentStatusType.PAYLATER:
        return ConstantData.color2;
    }
  }

  Color orderStatusColor({required OrderStatusType orderStatusType}) {
    switch (orderStatusType) {
      case OrderStatusType.CONFIRMED:
        return Colors.green;
      case OrderStatusType.DISPATCHED:
        return Colors.green;
      case OrderStatusType.DELIVERED:
        return Colors.green;
      case OrderStatusType.CANCELLED:
        return ConstantData.color1;
      case OrderStatusType.RETURNED:
        return Colors.orange;
    }
  }

  String getText({required PaymentStatusType paymentStatus}) {
    switch (paymentStatus) {
      case PaymentStatusType.PAID:
        return 'Prepaid order';
      case PaymentStatusType.UNPAID:
        return 'Unpaid';
      case PaymentStatusType.PAYLATER:
        return 'Unpaid/Paylater';
    }
  }

  @override
  void initState() {
    // razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    // razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    // razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlePaymentExternalWallet);
    // _openGateway(model: widget.model, profileModel: widget.profileModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double imageSize = safeBlockVertical(context: context) * 6;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeVertical(context: context),
      ),
      child: InkWell(
        onTap: () async {
          widget.productsStore.checkoutState = StoreState.LOADING;
          final sessId = await DataBox().readSessId();
          final ordersResponse =
              await OrderHistoryRepository().getOrdersResponseModel(
            sessId: sessId,
            orderId: widget.model.orderId,
          );
          final updatedModel = widget.model
              .copyWith(ordersList: [...ordersResponse.productList]);

          widget.productsStore.checkoutState = StoreState.SUCCESS;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  Provider.value(value: widget.store),
                  Provider.value(value: widget.loginStore),
                  Provider.value(value: widget.productsStore),
                  Provider.value(value: widget.profileStore),
                ],
                child: OrderHistoryDetailsScreen(model: updatedModel),
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: blockSizeHorizontal(context: context) * 3,
          ),
          decoration: BoxDecoration(
            color: ConstantData.bgColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ConstantData.mainTextColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medication,
                color: ConstantData.clrBlack30,
                size: ConstantWidget.getWidthPercentSize(context, 20),
              ),
              // SizedBox(
              //   width: blockSizeHorizontal(context: context) * 4,
              // ),
              // const Spacer(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Observer(
                      builder: (_) => Container(
                        padding: EdgeInsets.all(
                          blockSizeHorizontal(context: context) * 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(font12Px(context: context)),
                          border: Border.all(
                            color: paymentBoxColor(
                                paymentStatus: widget.model.paymentStatusType),
                          ),
                        ),
                        child: ConstantWidget.getCustomText(
                          getText(
                              paymentStatus: widget.model.paymentStatusType),
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 2,
                    ),
                    ConstantWidget.getCustomText(
                      'Order ID : ${widget.model.orderId}',
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font18Px(context: context),
                    ),
                    SizedBox(
                      height: blockSizeVertical(context: context),
                    ),
                    ConstantWidget.getCustomText(
                      'Date : ${widget.model.placedDateTime.split(' ')[0]}',
                      ConstantData.clrBorder,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font15Px(context: context),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  right: blockSizeHorizontal(context: context) * 4,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    blockSizeHorizontal(context: context) * 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(font12Px(context: context)),
                    border: Border.all(
                      color: orderStatusColor(
                          orderStatusType: widget.model.orderStatusType),
                      width: 1.2,
                    ),
                  ),
                  child: ConstantWidget.getCustomText(
                    widget.model.orderStatusType.orderStatusString(),
                    ConstantData.mainTextColor,
                    1,
                    TextAlign.center,
                    FontWeight.w600,
                    font18Px(context: context) * 1.1,
                  ),
                ),
              ),
              // Offstage(
              // offstage: (widget.model.paymentStatusType ==
              //         PaymentStatusType.PAID) ||
              //     (widget.model.orderStatusType == OrderStatusType.CANCELLED),
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //       right: blockSizeHorizontal(context: context) * 4,
              //     ),
              //     child: InkWell(
              //       onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (_) => ConstantWidget.alertDialog(
              //     context: context,
              //     func: () async {
              //       Navigator.pop(context);
              //       openGateway(
              //         payment: widget.model.orderAmount,
              //         noOfProducts: widget.model.ordersList.length,
              //         profileModel: widget.profileStore.profileModel,
              //       );
              //     },
              //     buttonText: 'Confirm',
              //     title: 'Please confirm to continue payment',
              //   ),
              // );
              //       },
              //       child: Container(
              //         padding: EdgeInsets.symmetric(
              //             horizontal: blockSizeHorizontal(context: context) * 3,
              //             vertical: blockSizeVertical(context: context)),
              //         decoration: BoxDecoration(
              //           color: ConstantData.primaryColor,
              //           borderRadius: BorderRadius.circular(
              //             font25Px(context: context),
              //           ),
              //         ),
              //         child: ConstantWidget.getCustomText(
              //           'Pay Now',
              //           ConstantData.bgColor,
              //           1,
              //           TextAlign.center,
              //           FontWeight.w600,
              //           font12Px(context: context) * 1.1,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const Spacer(),
              // Column(
              //   children: [
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.arrow_right,
              //         size: font25Px(context: context),
              //         color: ConstantData.clrBlack30,
              //       ),
              //     ),
              //   ],
              // ),
              // const Divider(
              //   thickness: 1.5,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// class AllOrdersList extends StatelessWidget {
//   const AllOrdersList({
//     Key? key,
//     required this.list,
//     required this.store,
//     required this.loginStore,
//   }) : super(key: key);

//   final List<OrderHistoryModel> list;
//   final OrderHistoryStore store;
//   final LoginStore loginStore;

//   // final _orderStatusValues = [
//   //   'Placed',
//   //   'Confirmed',
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     double imageSize = safeBlockVertical(context: context) * 6;
//     double margin = safeBlockVertical(context: context) * 2;
//     double leftMargin = safeBlockVertical(context: context) * 3;
//     double radius = ConstantWidget.getPercentSize(imageSize, 30);
//     double padding = ConstantWidget.getPercentSize(imageSize, 10);
//     double dotSize = ConstantWidget.getPercentSize(imageSize, 15);
//     double circleSize = ConstantWidget.getScreenPercentSize(context, 2);
//     return (list.isNotEmpty && loginStore.loginModel.adminStatus)
//         ? Container(
//             margin: EdgeInsets.only(top: leftMargin),
//             child: Observer(builder: (_) {
//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: list.length,
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               margin:
//                                   EdgeInsets.only(left: margin, right: margin),
//                               child: InkWell(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       height: imageSize,
//                                       width: imageSize,
//                                       margin: EdgeInsets.all(margin),
//                                       padding: EdgeInsets.all(padding),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(radius),
//                                         ),
//                                       ),
//                                       child: Image.asset(
//                                         "${ConstantData.assetsPath}med_logo_text.png",
//                                         height: ConstantWidget.getPercentSize(
//                                             imageSize, 50),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: padding),
//                                             child: ConstantWidget.getCustomText(
//                                               'Order #${list[index].orderId}',
//                                               ConstantData.mainTextColor,
//                                               1,
//                                               TextAlign.start,
//                                               FontWeight.w600,
//                                               font18Px(context: context) * 1.1,
//                                             ),
//                                           ),
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               ConstantWidget.getCustomText(
//                                                 list[index]
//                                                     .ordersList
//                                                     .length
//                                                     .toString(),
//                                                 ConstantData.textColor,
//                                                 1,
//                                                 TextAlign.start,
//                                                 FontWeight.w400,
//                                                 font18Px(context: context),
//                                               ),
//                                               Container(
//                                                 height: dotSize,
//                                                 width: dotSize,
//                                                 margin: EdgeInsets.only(
//                                                     left: margin,
//                                                     right: margin),
//                                                 decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color:
//                                                         ConstantData.textColor),
//                                               ),
//                                               ConstantWidget.getCustomText(
//                                                 (list[index].orderStatusType)
//                                                     .orderStatusString(),
//                                                 ConstantData.textColor,
//                                                 1,
//                                                 TextAlign.start,
//                                                 FontWeight.w600,
//                                                 font18Px(context: context),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                           left: margin, right: margin),
//                                       child: Icon(
//                                         (list[index].isView)
//                                             ? CupertinoIcons.chevron_up
//                                             : CupertinoIcons.chevron_down,
//                                         color: ConstantData.textColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () async {
//                                   // await store.updateTheOrdersState(
//                                   //   model: list[index],
//                                   // );
//                                 },
//                               ),
//                             ),
//                             Offstage(
//                               offstage: !list[index].isView,
//                               child: Container(
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   children: [
//                                     DropDownListTile(
//                                       margin: margin,
//                                       leftMargin: leftMargin,
//                                       circleSize: circleSize,
//                                       padding: padding,
//                                       // list: list,
//                                       status: 'Order Placed',
//                                       date: list[index].placedDateTime,
//                                       dotColor: ConstantData.primaryColor,
//                                     ),
//                                     DropDownListTile(
//                                       margin: margin,
//                                       leftMargin: leftMargin,
//                                       circleSize: circleSize,
//                                       padding: padding,
//                                       // list: list,
//                                       status: 'Order Confirmed',
//                                       date: list[index].placedDateTime,
//                                       dotColor: ConstantData.primaryColor,
//                                     ),
//                                     DropDownListTile(
//                                       margin: margin,
//                                       leftMargin: leftMargin,
//                                       circleSize: circleSize,
//                                       padding: padding,
//                                       // list: list,
//                                       status: 'Order Dispatched',
//                                       date: (list[index].orderStatusType !=
//                                               OrderStatusType.DISPATCHED)
//                                           ? 'Not yet dispatched'
//                                           : list[index].dispatchedDate,
//                                       dotColor: (list[index].orderStatusType !=
//                                               OrderStatusType.DISPATCHED)
//                                           ? ConstantData.textColor
//                                           : ConstantData.primaryColor,
//                                     ),
//                                     DropDownListTile(
//                                       margin: margin,
//                                       leftMargin: leftMargin,
//                                       circleSize: circleSize,
//                                       padding: padding,
//                                       // list: list,
//                                       status: 'Order Delivered',
//                                       date: (list[index].orderStatusType !=
//                                               OrderStatusType.DELIVERED)
//                                           ? 'Not yet delivered'
//                                           : list[index].deliveredDate,
//                                       dotColor: (list[index].orderStatusType !=
//                                               OrderStatusType.DELIVERED)
//                                           ? ConstantData.textColor
//                                           : ConstantData.primaryColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin:
//                                   EdgeInsets.only(top: margin, bottom: margin),
//                               color: ConstantData.textColor,
//                               height: ConstantWidget.getScreenPercentSize(
//                                   context, 0.08),
//                             )
//                           ],
//                         ),
//                       ),
//                       onTap: () {},
//                     );
//                   });
//             }))
//         : Column(
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Observer(builder: (_) {
//                   final adminStatus = loginStore.loginModel.adminStatus;
//                   return Offstage(
//                     offstage: adminStatus,
//                     child: ConstantWidget.adminStatusbanner(context),
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: ConstantWidget.getScreenPercentSize(context, 17),
//               ),
//               // SizedBox(
//               // height: ConstantWidget.getScreenPercentSize(context, 30),
//               //   width: ConstantWidget.getWidthPercentSize(context, 60),
//               //   child: Image.asset(
//               //     ConstantData.assetsPath + 'thank_you.png',
//               //     fit: BoxFit.cover,
//               //   ),
//               // ),
//               ConstantWidget.errorWidget(
//                 context: context,
//                 height: 25,
//                 width: 20,
//               ),
//             ],
//           );
//   }
// }

// class DropDownListTile extends StatelessWidget {
//   const DropDownListTile({
//     Key? key,
//     required this.margin,
//     required this.leftMargin,
//     required this.circleSize,
//     required this.padding,
//     // required this.list,
//     required this.date,
//     required this.status,
//     required this.dotColor,
//   }) : super(key: key);

//   final double margin;
//   final double leftMargin;
//   final double circleSize;
//   final double padding;
//   // final List<OrderHistoryModel> list;
//   final String status;
//   final String date;
//   final Color dotColor;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: margin, bottom: margin),
//       child: Container(
//         margin: EdgeInsets.only(left: leftMargin, right: leftMargin),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: circleSize,
//               width: circleSize,
//               margin: EdgeInsets.only(
//                 right: margin,
//               ),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: dotColor,
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(bottom: padding),
//                     child: ConstantWidget.getCustomText(
//                         status,
//                         ConstantData.mainTextColor,
//                         1,
//                         TextAlign.start,
//                         FontWeight.w600,
//                         ConstantWidget.getScreenPercentSize(context, 1.8)),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ConstantWidget.getCustomText(
//                           date,
//                           ConstantData.textColor,
//                           1,
//                           TextAlign.start,
//                           FontWeight.w600,
//                           ConstantWidget.getScreenPercentSize(context, 1.5)),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrdersList extends StatelessWidget {
//   const OrdersList({
//     Key? key,
//     required this.list,
//     required this.store,
//     required this.loginStore,
//   }) : super(key: key);

//   final List<OrderHistoryModel> list;
//   final OrderHistoryStore store;
//   final LoginStore loginStore;
//   // final PaymentStatusType? paymentStatusType;

//   @override
//   Widget build(BuildContext context) {
//     return (list.isNotEmpty && loginStore.loginModel.adminStatus)
//         ? SizedBox(
//             height: double.infinity,
//             child: Observer(builder: (_) {
//               // final list = store.dispatchedOrders;
//               return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: list.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => OrderHistoryDetailsScreen(
//                               model: list[index],
//                             ),
//                           ),
//                         );
//                       },
//                       child: orderTile(
//                         model: list[index],
//                         context: context,
//                       ),
//                     );
//                   });
//             }),
//           )
//         : Column(
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Observer(builder: (_) {
//                   final adminStatus = loginStore.loginModel.adminStatus;
//                   return Offstage(
//                     offstage: adminStatus,
//                     child: ConstantWidget.adminStatusbanner(context),
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: ConstantWidget.getScreenPercentSize(context, 17),
//               ),
//               ConstantWidget.errorWidget(
//                 context: context,
//                 height: 25,
//                 width: 20,
//               ),
//             ],
//           );
//   }

//   Widget orderTile(
//       {required OrderHistoryModel model, required BuildContext context}) {
//     double leftMargin = MediaQuery.of(context).size.width * 0.05;
//     double imageSize = safeBlockVertical(context: context) * 8;

//     double cellHeight = safeBlockVertical(context: context) * 5.5;
//     double radius = safeBlockVertical(context: context) * 2;
//     double subRadius = safeBlockVertical(context: context) * 1.5;

//     double margin = safeBlockVertical(context: context) * 2;
//     double padding = safeBlockVertical(context: context) * 1.5;
//     double fontSize = ConstantWidget.getPercentSize(cellHeight, 35);
//     return Container(
//       decoration: BoxDecoration(
//           color: ConstantData.bgColor,
//           borderRadius: BorderRadius.circular(radius),
//           border: Border.all(
//               color: ConstantData.borderColor,
//               width: ConstantWidget.getWidthPercentSize(context, 0.08)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//             )
//           ]),
//       margin: EdgeInsets.only(left: leftMargin, top: margin, right: leftMargin),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               orderImageWidget(imageSize, radius, padding, model),
//               productListOrderWidget(model, context, padding)
//             ],
//           ),

//           Padding(
//             padding: EdgeInsets.only(
//                 top: padding, bottom: margin, left: margin, right: margin),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: reorderWidget(
//                       model, cellHeight, margin, subRadius, fontSize),
//                 ),
//                 const Spacer(),
//                 Expanded(
//                   child: viewInvoiceWidget(
//                       cellHeight, margin, subRadius, fontSize),
//                 ),
//               ],
//             ),
//           )

//           //   ],
//           // )
//         ],
//       ),
//     );
//   }

//   InkWell viewInvoiceWidget(
//       double cellHeight, double margin, double subRadius, double fontSize) {
//     return InkWell(
//       child: Container(
//         height: cellHeight,
//         margin: EdgeInsets.only(right: margin),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: ConstantData.cellColor,
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(subRadius),
//         ),
//         child: Center(
//           child: ConstantWidget.getCustomTextWithoutAlign(
//               'Invoice', ConstantData.mainTextColor, FontWeight.w600, fontSize),
//         ),
//       ),
//       onTap: () async {},
//     );
//   }

//   Offstage reorderWidget(OrderHistoryModel model, double cellHeight,
//       double margin, double subRadius, double fontSize) {
//     return Offstage(
//       offstage: !(model.orderStatusType == OrderStatusType.DELIVERED),
//       child: InkWell(
//         child: Container(
//           height: cellHeight,
//           margin: EdgeInsets.only(left: margin),
//           decoration: BoxDecoration(
//             color: ConstantData.primaryColor,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(subRadius),
//           ),
//           child: Center(
//             child: ConstantWidget.getCustomTextWithoutAlign(
//               'Re-order',
//               Colors.white,
//               FontWeight.w600,
//               fontSize,
//             ),
//           ),
//         ),
//         onTap: () {},
//       ),
//     );
//   }

//   Expanded productListOrderWidget(
//       OrderHistoryModel model, BuildContext context, double padding) {
//     return Expanded(
//       flex: 1,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ConstantWidget.getCustomText(
//             "Order: #${model.orderId}",
//             ConstantData.mainTextColor,
//             1,
//             TextAlign.start,
//             FontWeight.w600,
//             font18Px(context: context) * 1.1,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: (padding / 1.8)),
//             child: ConstantWidget.getCustomText(
//               '${model.ordersList.length} items',
//               ConstantData.textColor,
//               1,
//               TextAlign.start,
//               FontWeight.w600,
//               font18Px(context: context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container orderImageWidget(double imageSize, double radius, double padding,
//       OrderHistoryModel model) {
//     return Container(
//       height: imageSize,
//       width: imageSize,
//       margin: EdgeInsets.all(radius),
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           color: ConstantData.cellColor,
//           borderRadius: BorderRadius.all(
//             Radius.circular(radius),
//           ),
//           image: DecorationImage(
//               image: CachedNetworkImageProvider(
//                   productUrl + model.ordersList[0].productImg),
//               fit: BoxFit.cover)),
//     );
//   }
// }

class InvoiceView extends StatelessWidget {
  const InvoiceView({
    Key? key,
    required this.phone,
    required this.url,
    required this.store,
    required this.invoice,
    required this.detailsContext,
  }) : super(key: key);

  final String phone;
  final String url;
  final OrderHistoryStore store;
  final String invoice;
  final BuildContext detailsContext;

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 70);
    double radius = ConstantWidget.getPercentSize(height, 2);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: blockSizeVertical(context: context) * 2,
        ),
        height: height,
        width: ConstantWidget.getWidthPercentSize(context, 70),
        decoration: BoxDecoration(
          color: ConstantData.bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
