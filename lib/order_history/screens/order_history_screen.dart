import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/delivery_status_type.dart';
import 'package:medrpha_customer/enums/payment_status_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/order_history/screens/order_history_details_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/order_dialog.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key, this.fromSettingsPage}) : super(key: key);

  final bool? fromSettingsPage;

  List<OrderHistoryModel> getUpdatedList({
    required OrderStatusType orderStatusType,
    required OrderHistoryStore store,
  }) {
    final list = <OrderHistoryModel>[];
    for (final model in store.orders) {
      if (model.orderStatusType == orderStatusType) {
        list.add(model);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<OrderHistoryStore>();
    final loginStore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();

    return Scaffold(
        backgroundColor: ConstantData.cellColor,
        appBar: ConstantWidget.customAppBar(
          context: context,
          title: 'ORDERS',
          isHome: (fromSettingsPage ?? false) ? true : false,
        ),
        body: Observer(
          builder: (_) {
            return Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: ConstantData.bgColor),
                        width: screenWidth(context: context),
                        padding: EdgeInsets.symmetric(
                          horizontal: blockSizeHorizontal(context: context) * 2,
                          // vertical: blockSizeVertical(context: context) * 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    blockSizeVertical(context: context) * 2,
                              ),
                              child: Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CurrentOrderStatusTile(
                                        store: store,
                                        status: 'All',
                                        orderStatusType:
                                            OrderStatusType.CONFIRMED,
                                      ),
                                      CurrentOrderStatusTile(
                                        store: store,
                                        status: 'Dispatched',
                                        orderStatusType:
                                            OrderStatusType.DISPATCHED,
                                      ),
                                      CurrentOrderStatusTile(
                                        store: store,
                                        status: 'Delivered',
                                        orderStatusType:
                                            OrderStatusType.DELIVERED,
                                      ),
                                      CurrentOrderStatusTile(
                                        store: store,
                                        status: 'Cancelled',
                                        orderStatusType:
                                            OrderStatusType.CANCELLED,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Observer(builder: (_) {
                                final adminStatus =
                                    loginStore.loginModel.adminStatus;
                                return Offstage(
                                  offstage: adminStatus,
                                  child:
                                      ConstantWidget.adminStatusbanner(context),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Observer(builder: (_) {
                        List<OrderHistoryModel> list = <OrderHistoryModel>[];
                        final state = store.viewOrdersStatusType;
                        switch (state) {
                          case OrderStatusType.CONFIRMED:
                            list = store.orders;
                            break;
                          case OrderStatusType.DISPATCHED:
                            list = getUpdatedList(
                              orderStatusType: OrderStatusType.DISPATCHED,
                              store: store,
                            );
                            break;
                          case OrderStatusType.DELIVERED:
                            list = getUpdatedList(
                              orderStatusType: OrderStatusType.DELIVERED,
                              store: store,
                            );
                            break;
                          case OrderStatusType.CANCELLED:
                            list = getUpdatedList(
                              orderStatusType: OrderStatusType.CANCELLED,
                              store: store,
                            );
                            break;
                        }

                        final adminStatus = loginStore.loginModel.adminStatus;
                        return Expanded(
                          child: (adminStatus)
                              ? ViewOrdersList(
                                  list: list,
                                  store: store,
                                  productsStore: productStore,
                                  loginStore: loginStore,
                                  profileStore: profileStore,
                                )
                              : ConstantWidget.errorWidget(
                                  context: context,
                                  height: 20,
                                  width: 25,
                                ),
                        );
                      }),
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
          },
        ));
  }
}

class CurrentOrderStatusTile extends StatelessWidget {
  const CurrentOrderStatusTile({
    Key? key,
    required this.store,
    required this.status,
    required this.orderStatusType,
  }) : super(key: key);

  final OrderHistoryStore store;
  final String status;
  final OrderStatusType orderStatusType;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: blockSizeHorizontal(context: context) * 4,
        ),
        child: InkWell(
          onTap: () {
            store.viewOrdersStatusType = orderStatusType;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 3,
              vertical: blockSizeVertical(context: context),
            ),
            decoration: BoxDecoration(
              color: (store.viewOrdersStatusType == orderStatusType)
                  ? ConstantData.bgColor
                  : ConstantData.cartColor,
              borderRadius: BorderRadius.circular(15),
              border: (store.viewOrdersStatusType == orderStatusType)
                  ? Border.all(color: ConstantData.mainTextColor, width: 1.5)
                  : Border.all(color: ConstantData.clrBlack20, width: 1.5),
            ),
            child: ConstantWidget.getCustomText(
              status,
              ConstantData.mainTextColor,
              1,
              TextAlign.center,
              FontWeight.w600,
              font15Px(context: context),
            ),
          ),
        ),
      );
    });
  }
}

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
              child: ListView.builder(
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
  final razorPay = Razorpay();

  handlePaymentSuccess(PaymentSuccessResponse response) async {
    // print('-----------Success Payment-------- ${response.orderId}');
    final store = context.read<ProductsStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    // final profileStore = context.read<ProfileStore>();
    // final loginStore = context.read<LoginStore>();
    // final bottomNavigationStore = context.read<BottomNavigationStore>();
    store.checkoutState = StoreState.LOADING;
    await store.confirmPayment(
      orderId: widget.model.orderId,
      context: context,
      orderHistoryStore: orderHistoryStore,
    );
    store.checkoutState = StoreState.SUCCESS;
  }

  handlePaymentFailure(PaymentFailureResponse response) {
    // print('-----------Failure Payment-------- ${response.code}');
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

  handlePaymentExternalWallet(PaymentSuccessResponse response) {
    print(
        '-----------Success Payment External wallet-------- ${response.signature}');
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

    razorPay.open(options);
  }

  Color boxColor({required OrderStatusType orderStatus}) {
    switch (orderStatus) {
      case OrderStatusType.CONFIRMED:
        return Colors.yellow[700]!;
      case OrderStatusType.DISPATCHED:
        return Colors.orange;
      case OrderStatusType.DELIVERED:
        return Colors.green;
      case OrderStatusType.CANCELLED:
        return Colors.red;
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
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlePaymentExternalWallet);
    // _openGateway(model: widget.model, profileModel: widget.profileModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = safeBlockVertical(context: context) * 6;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Provider.value(
                value: widget.store,
                child: Provider.value(
                  value: widget.productsStore,
                  child: Provider.value(
                    value: widget.loginStore,
                    child: Provider.value(
                      value: widget.profileStore,
                      child: OrderHistoryDetailsScreen(
                        model: widget.model,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: blockSizeVertical(context: context),
          ),
          decoration: BoxDecoration(
            color: ConstantData.bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context),
                  horizontal: blockSizeHorizontal(context: context) * 4,
                ),
                child: ConstantWidget.getCustomText(
                  'Date : ${widget.model.placedDateTime.split(' ')[0]}',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context),
                ),
              ),
              Divider(
                thickness: 1,
                color: ConstantData.cellColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context),
                  horizontal: blockSizeHorizontal(context: context) * 4,
                ),
                child: ConstantWidget.getCustomText(
                  'Order ID : ${widget.model.orderId}',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context),
                ),
              ),
              const Divider(
                thickness: 1.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context) * 1.5,
                  horizontal: blockSizeHorizontal(context: context) * 5,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: ConstantData.productUrl +
                            widget.model.ordersList.first.productImg,
                        fit: BoxFit.cover,
                        height: imageSize * 1.5,
                        width: imageSize * 1.5,
                      ),
                    ),
                    SizedBox(
                      width: blockSizeHorizontal(context: context) * 4,
                    ),
                    // const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              blockSizeHorizontal(context: context) * 2,
                            ),
                            decoration: BoxDecoration(
                              color: ConstantData.cartColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ConstantWidget.getCustomText(
                              getText(
                                  paymentStatus:
                                      widget.model.paymentStatusType),
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font12Px(context: context),
                            ),
                          ),
                          SizedBox(height: blockSizeVertical(context: context)),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height:
                                      blockSizeVertical(context: context) * 2,
                                  child: ListView.builder(
                                    itemCount: widget.model.ordersList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      return ConstantWidget.getCustomText(
                                        widget.model.ordersList[index]
                                                .productName +
                                            ((index !=
                                                    widget.model.ordersList
                                                            .length -
                                                        1)
                                                ? ', '
                                                : ''),
                                        ConstantData.mainTextColor,
                                        2,
                                        TextAlign.left,
                                        FontWeight.w600,
                                        font15Px(context: context) * 1.1,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  blockSizeVertical(context: context) * 2.5),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: blockSizeHorizontal(context: context) * 2,
                                color: boxColor(
                                    orderStatus: widget.model.orderStatusType),
                              ),
                              SizedBox(
                                width:
                                    blockSizeHorizontal(context: context) * 2,
                              ),
                              ConstantWidget.getCustomText(
                                widget.model.orderStatusType
                                    .orderStatusString(),
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font15Px(context: context),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // const Spacer(),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_right,
                            size: font25Px(context: context),
                            color: ConstantData.clrBlack30,
                          ),
                        ),
                        if ((widget.model.paymentStatusType !=
                                PaymentStatusType.PAID) &&
                            (widget.model.orderStatusType ==
                                OrderStatusType.CONFIRMED))
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => ConstantWidget.alertDialog(
                                  context: context,
                                  func: () async {
                                    Navigator.pop(context);
                                    openGateway(
                                      payment: widget.model.orderAmount,
                                      noOfProducts:
                                          widget.model.ordersList.length,
                                      profileModel:
                                          widget.profileStore.profileModel,
                                    );
                                  },
                                  buttonText: 'Confirm',
                                  title: 'Please confirm to continue payment',
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      blockSizeHorizontal(context: context) * 3,
                                  vertical:
                                      blockSizeVertical(context: context)),
                              decoration: BoxDecoration(
                                color: ConstantData.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  font25Px(context: context),
                                ),
                              ),
                              child: ConstantWidget.getCustomText(
                                'Pay Now',
                                ConstantData.bgColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font12Px(context: context) * 1.1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllOrdersList extends StatelessWidget {
  const AllOrdersList({
    Key? key,
    required this.list,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  final List<OrderHistoryModel> list;
  final OrderHistoryStore store;
  final LoginStore loginStore;

  // final _orderStatusValues = [
  //   'Placed',
  //   'Confirmed',
  // ];

  @override
  Widget build(BuildContext context) {
    double imageSize = safeBlockVertical(context: context) * 6;
    double margin = safeBlockVertical(context: context) * 2;
    double leftMargin = safeBlockVertical(context: context) * 3;
    double radius = ConstantWidget.getPercentSize(imageSize, 30);
    double padding = ConstantWidget.getPercentSize(imageSize, 10);
    double dotSize = ConstantWidget.getPercentSize(imageSize, 15);
    double circleSize = ConstantWidget.getScreenPercentSize(context, 2);
    return (list.isNotEmpty && loginStore.loginModel.adminStatus)
        ? Container(
            margin: EdgeInsets.only(top: leftMargin),
            child: Observer(builder: (_) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: margin, right: margin),
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Container(
                                      height: imageSize,
                                      width: imageSize,
                                      margin: EdgeInsets.all(margin),
                                      padding: EdgeInsets.all(padding),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(radius),
                                        ),
                                      ),
                                      child: Image.asset(
                                        "${ConstantData.assetsPath}med_logo_text.png",
                                        height: ConstantWidget.getPercentSize(
                                            imageSize, 50),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: padding),
                                            child: ConstantWidget.getCustomText(
                                              'Order #${list[index].orderId}',
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w600,
                                              font18Px(context: context) * 1.1,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ConstantWidget.getCustomText(
                                                list[index]
                                                    .ordersList
                                                    .length
                                                    .toString(),
                                                ConstantData.textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w400,
                                                font18Px(context: context),
                                              ),
                                              Container(
                                                height: dotSize,
                                                width: dotSize,
                                                margin: EdgeInsets.only(
                                                    left: margin,
                                                    right: margin),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        ConstantData.textColor),
                                              ),
                                              ConstantWidget.getCustomText(
                                                (list[index].orderStatusType)
                                                    .orderStatusString(),
                                                ConstantData.textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                font18Px(context: context),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: margin, right: margin),
                                      child: Icon(
                                        (list[index].isView)
                                            ? CupertinoIcons.chevron_up
                                            : CupertinoIcons.chevron_down,
                                        color: ConstantData.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await store.updateTheOrdersState(
                                    model: list[index],
                                  );
                                },
                              ),
                            ),
                            Offstage(
                              offstage: !list[index].isView,
                              child: Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    DropDownListTile(
                                      margin: margin,
                                      leftMargin: leftMargin,
                                      circleSize: circleSize,
                                      padding: padding,
                                      // list: list,
                                      status: 'Order Placed',
                                      date: list[index].placedDateTime,
                                      dotColor: ConstantData.primaryColor,
                                    ),
                                    DropDownListTile(
                                      margin: margin,
                                      leftMargin: leftMargin,
                                      circleSize: circleSize,
                                      padding: padding,
                                      // list: list,
                                      status: 'Order Confirmed',
                                      date: list[index].placedDateTime,
                                      dotColor: ConstantData.primaryColor,
                                    ),
                                    DropDownListTile(
                                      margin: margin,
                                      leftMargin: leftMargin,
                                      circleSize: circleSize,
                                      padding: padding,
                                      // list: list,
                                      status: 'Order Dispatched',
                                      date: (list[index].orderStatusType !=
                                              OrderStatusType.DISPATCHED)
                                          ? 'Not yet dispatched'
                                          : list[index].dispatchedDate,
                                      dotColor: (list[index].orderStatusType !=
                                              OrderStatusType.DISPATCHED)
                                          ? ConstantData.textColor
                                          : ConstantData.primaryColor,
                                    ),
                                    DropDownListTile(
                                      margin: margin,
                                      leftMargin: leftMargin,
                                      circleSize: circleSize,
                                      padding: padding,
                                      // list: list,
                                      status: 'Order Delivered',
                                      date: (list[index].orderStatusType !=
                                              OrderStatusType.DELIVERED)
                                          ? 'Not yet delivered'
                                          : list[index].deliveredDate,
                                      dotColor: (list[index].orderStatusType !=
                                              OrderStatusType.DELIVERED)
                                          ? ConstantData.textColor
                                          : ConstantData.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: margin, bottom: margin),
                              color: ConstantData.textColor,
                              height: ConstantWidget.getScreenPercentSize(
                                  context, 0.08),
                            )
                          ],
                        ),
                      ),
                      onTap: () {},
                    );
                  });
            }))
        : Column(
            // mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 17),
              ),
              // SizedBox(
              // height: ConstantWidget.getScreenPercentSize(context, 30),
              //   width: ConstantWidget.getWidthPercentSize(context, 60),
              //   child: Image.asset(
              //     ConstantData.assetsPath + 'thank_you.png',
              //     fit: BoxFit.cover,
              //   ),
              // ),
              ConstantWidget.errorWidget(
                context: context,
                height: 25,
                width: 20,
              ),
            ],
          );
  }
}

class DropDownListTile extends StatelessWidget {
  const DropDownListTile({
    Key? key,
    required this.margin,
    required this.leftMargin,
    required this.circleSize,
    required this.padding,
    // required this.list,
    required this.date,
    required this.status,
    required this.dotColor,
  }) : super(key: key);

  final double margin;
  final double leftMargin;
  final double circleSize;
  final double padding;
  // final List<OrderHistoryModel> list;
  final String status;
  final String date;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin, bottom: margin),
      child: Container(
        margin: EdgeInsets.only(left: leftMargin, right: leftMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: circleSize,
              width: circleSize,
              margin: EdgeInsets.only(
                right: margin,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: ConstantWidget.getCustomText(
                        status,
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        ConstantWidget.getScreenPercentSize(context, 1.8)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidget.getCustomText(
                          date,
                          ConstantData.textColor,
                          1,
                          TextAlign.start,
                          FontWeight.w600,
                          ConstantWidget.getScreenPercentSize(context, 1.5)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({
    Key? key,
    required this.list,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  final List<OrderHistoryModel> list;
  final OrderHistoryStore store;
  final LoginStore loginStore;
  // final PaymentStatusType? paymentStatusType;

  @override
  Widget build(BuildContext context) {
    double leftMargin = MediaQuery.of(context).size.width * 0.05;
    double imageSize = safeBlockVertical(context: context) * 8;

    double cellHeight = safeBlockVertical(context: context) * 5.5;
    double radius = safeBlockVertical(context: context) * 2;
    double subRadius = safeBlockVertical(context: context) * 1.5;

    double margin = safeBlockVertical(context: context) * 2;
    double padding = safeBlockVertical(context: context) * 1.5;
    double fontSize = ConstantWidget.getPercentSize(cellHeight, 35);

    return (list.isNotEmpty && loginStore.loginModel.adminStatus)
        ? Container(
            child: Observer(builder: (_) {
              // final list = store.dispatchedOrders;
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderHistoryDetailsScreen(
                                    model: list[index])));
                      },
                      child: Container(
                        // decoration: BoxDecoration(
                        //     color: ConstantData.whiteColor,
                        //     borderRadius: BorderRadius.circular(radius),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.shade200,
                        //         blurRadius: 10,
                        //       )
                        //     ]),

                        decoration: BoxDecoration(
                            color: ConstantData.bgColor,
                            borderRadius: BorderRadius.circular(radius),
                            border: Border.all(
                                color: ConstantData.borderColor,
                                width: ConstantWidget.getWidthPercentSize(
                                    context, 0.08)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                              )
                            ]),
                        margin: EdgeInsets.only(
                            left: leftMargin, top: margin, right: leftMargin),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: imageSize,
                                  width: imageSize,
                                  margin: EdgeInsets.all(radius),
                                  padding: EdgeInsets.all(padding),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: ConstantData.cellColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(radius),
                                      ),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              ConstantData.productUrl +
                                                  list[index]
                                                      .ordersList[0]
                                                      .productImg),
                                          fit: BoxFit.cover)),
                                  // child: Image.asset(ConstantData.assetsPath +
                                  //     myOrderList[index].image),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // RichText(
                                      //   text: TextSpan(
                                      //     text: 'OrderId: ',
                                      //     style: TextStyle(
                                      //       fontFamily: ConstantData.fontFamily,
                                      //       fontSize:
                                      //           font18Px(context: context),
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //     children: [
                                      //       TextSpan(
                                      //         text: list[index].orderId,
                                      //         style: TextStyle(
                                      //           fontFamily:
                                      //               ConstantData.fontFamily,
                                      //           fontSize:
                                      //               font18Px(context: context) *
                                      //                   1.2,
                                      //           fontWeight: FontWeight.w600,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      ConstantWidget.getCustomText(
                                        "Order: #${list[index].orderId}",
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w600,
                                        font18Px(context: context) * 1.1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: (padding / 1.8)),
                                        child: ConstantWidget.getCustomText(
                                          '${list[index].ordersList.length} items',
                                          ConstantData.textColor,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w600,
                                          font18Px(context: context),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: padding,
                                  bottom: margin,
                                  left: margin,
                                  right: margin),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Offstage(
                                      offstage: !(list[index].orderStatusType ==
                                          OrderStatusType.DELIVERED),
                                      child: InkWell(
                                        child: Container(
                                          height: cellHeight,
                                          margin: EdgeInsets.only(left: margin),
                                          decoration: BoxDecoration(
                                            color: ConstantData.primaryColor,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(
                                                subRadius),
                                          ),
                                          child: Center(
                                            child: ConstantWidget
                                                .getCustomTextWithoutAlign(
                                              'Re-order',
                                              Colors.white,
                                              FontWeight.w600,
                                              fontSize,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => OrderTrackMap(),
                                          //     ));
                                        },
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        height: cellHeight,
                                        margin: EdgeInsets.only(right: margin),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: ConstantData.cellColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(subRadius),
                                          // border: Border.all(
                                          //     width: 0.5,
                                          //     color: Colors.grey.shade400)
                                        ),
                                        child: Center(
                                          child: ConstantWidget
                                              .getCustomTextWithoutAlign(
                                                  'Invoice',
                                                  ConstantData.mainTextColor,
                                                  FontWeight.w600,
                                                  fontSize),
                                        ),
                                      ),
                                      onTap: () async {
                                        // final _contact =
                                        //     await DataBox().readPhoneNo();
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (context) => InvoiceView(
                                        //       phone: _contact, url: '111.pdf'),
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )

                            //   ],
                            // )
                          ],
                        ),
                      ),
                    );
                  });
            }),
          )
        : Column(
            // mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 17),
              ),
              // SizedBox(
              //   height: ConstantWidget.getScreenPercentSize(context, 30),
              //   width: ConstantWidget.getWidthPercentSize(context, 60),
              //   child: Image.asset(
              //     ConstantData.assetsPath + 'thank_you.png',
              //     fit: BoxFit.cover,
              //   ),
              // ),
              ConstantWidget.errorWidget(
                context: context,
                height: 25,
                width: 20,
              ),
            ],
          );
  }
}

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
          children: [
            // Expanded(
            //   flex: 1,
            //   child: SfPdfViewer.network(
            //     ConstantData.invoiceUrl + url,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
