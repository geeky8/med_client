// ignore_for_file: unnecessary_const, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/enums/delivery_status_type.dart';
import 'package:medrpha_customer/enums/payment_status_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/order_history/screens/order_history_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';

import '../../api_service.dart';

class OrderHistoryDetailsScreen extends StatelessWidget {
  const OrderHistoryDetailsScreen({Key? key, required this.model})
      : super(key: key);

  final OrderHistoryModel model;

  @override
  Widget build(BuildContext context) {
    final store = context.read<OrderHistoryStore>();
    final productStore = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final profileSTore = context.read<ProfileStore>();

    // double margin = safeBlockVertical(context: context) * 2;
    // double padding = safeBlockVertical(context: context) * 0.9;

    // double leftMargin = screenWidth(context: context) * 0.05;
    return Scaffold(
      backgroundColor: ConstantData.cellColor,
      appBar:
          ConstantWidget.customAppBar(context: context, title: 'ORDER DETAILS'),
      bottomNavigationBar: Observer(builder: (_) {
        final state = store.invoiceDwdState;
        switch (state) {
          case StoreState.LOADING:
            return LinearProgressIndicator(
              color: ConstantData.primaryColor,
            );
          case StoreState.SUCCESS:
            return const SizedBox();
          case StoreState.ERROR:
            return const SizedBox();
          case StoreState.EMPTY:
            return const SizedBox();
        }
      }),
      body: Container(
        // margin: EdgeInsets.only(left: leftMargin, right: leftMargin),
        // padding: EdgeInsets.only(top: margin),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: OrderHistoryDetailsWidget(
            model: model,
            productsStore: productStore,
            loginStore: loginStore,
            profileStore: profileSTore,
            orderHistoryStore: store,
          ),
        ),
      ),
    );
  }
}

class OrderHistoryDetailsWidget extends StatefulWidget {
  const OrderHistoryDetailsWidget({
    Key? key,
    required this.model,
    required this.productsStore,
    required this.loginStore,
    required this.profileStore,
    required this.orderHistoryStore,
  }) : super(key: key);

  final OrderHistoryModel model;
  final ProductsStore productsStore;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;

  @override
  State<OrderHistoryDetailsWidget> createState() =>
      _OrderHistoryDetailsWidgetState();
}

class _OrderHistoryDetailsWidgetState extends State<OrderHistoryDetailsWidget> {
  String getText({required PaymentStatusType paymentStatus}) {
    switch (paymentStatus) {
      case PaymentStatusType.PAID:
        return 'Online Payment';
      case PaymentStatusType.UNPAID:
        return 'Cash on delivery';
      case PaymentStatusType.PAYLATER:
        return 'Cash on delivery/Paylater';
    }
  }

  bool viewInvoice = false;
  bool cancelOrder = false;
  final remarksContoller = TextEditingController();

  String? getTextValidation({required String value}) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ConstantWidget.customAppBar(context: context, title: 'ORDER DETAILS'),
        OrderDetailHeader(context),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: blockSizeVertical(context: context),
          ),
          child: Container(
            decoration: BoxDecoration(color: ConstantData.bgColor),
            // height: ConstantWidget.getScreenPercentSize(context, 60),
            padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 4,
              vertical: blockSizeVertical(context: context) * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productDetailsWidget(context),
                const Divider(thickness: 1),
                SizedBox(height: blockSizeVertical(context: context) * 3),
                ConstantWidget.getCustomText(
                  'Order Tracking',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.1,
                ),
                SizedBox(height: blockSizeVertical(context: context) * 2.5),
                OrderTrackingRadioTile(
                  orderStatusType: widget.model.orderStatusType,
                  date:
                      '${widget.model.placedDateTime.split(' ')[0]} ${widget.model.placedDateTime.split(' ')[1]}',
                  status: 'Placed',
                  color: Colors.green[700]!,
                ),
                OrderTrackingRadioTile(
                  orderStatusType: OrderStatusType.CONFIRMED,
                  date:
                      '${widget.model.placedDateTime.split(' ')[0]} ${widget.model.placedDateTime.split(' ')[1]}',
                  color: (widget.model.orderStatusType ==
                          OrderStatusType.CONFIRMED)
                      ? Colors.green[700]!
                      : ConstantData.cellColor,
                ),
                OrderTrackingRadioTile(
                  orderStatusType: OrderStatusType.DISPATCHED,
                  date: (widget.model.dispatchedDate == '')
                      ? 'Not yet dispatched'
                      : widget.model.dispatchedDate,
                  color: (widget.model.orderStatusType ==
                          OrderStatusType.DISPATCHED)
                      ? Colors.green[700]!
                      : ConstantData.cellColor,
                ),
                OrderTrackingRadioTile(
                  orderStatusType: OrderStatusType.DELIVERED,
                  date: (widget.model.deliveredDate == '')
                      ? 'Not yet delivered'
                      : widget.model.deliveredDate,
                  color: (widget.model.orderStatusType ==
                          OrderStatusType.DELIVERED)
                      ? Colors.green[700]!
                      : ConstantData.cellColor,
                ),
                if (widget.model.orderStatusType == OrderStatusType.CANCELLED)
                  OrderTrackingRadioTile(
                    orderStatusType: OrderStatusType.CANCELLED,
                    date: 'Order cancelled',
                    color: Colors.red[700]!,
                  ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: widget.model.orderStatusType == OrderStatusType.CANCELLED ||
              widget.model.orderStatusType == OrderStatusType.DELIVERED,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context),
            ),
            child: Container(
              decoration: BoxDecoration(color: ConstantData.bgColor),
              padding: EdgeInsets.symmetric(
                vertical: blockSizeVertical(context: context) * 2,
                horizontal: blockSizeHorizontal(context: context) * 4,
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        cancelOrder = !cancelOrder;
                      });
                    },
                    child: Row(
                      children: [
                        ConstantWidget.getCustomText(
                          (widget.model.orderStatusType ==
                                  OrderStatusType.DELIVERED)
                              ? 'Return/Exchange Order'
                              : 'Cancel Order',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context),
                        ),
                        const Spacer(),
                        Icon(
                          (cancelOrder)
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right_outlined,
                          size: font25Px(context: context),
                          color: ConstantData.mainTextColor,
                        ),
                      ],
                    ),
                  ),
                  if (cancelOrder)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: blockSizeVertical(context: context) * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  blockSizeHorizontal(context: context) * 3,
                              vertical: blockSizeVertical(context: context) * 1,
                            ),
                            child: ConstantWidget.getCustomText(
                              'Remarks',
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font15Px(context: context),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height:
                                ConstantWidget.getWidthPercentSize(context, 33),
                            child: TextFormField(
                              controller: remarksContoller,
                              enabled: cancelOrder,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: ConstantData.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: font18Px(context: context),
                              ),
                              // onChanged: (value) async {
                              //   remarksContoller.notifyListeners();
                              //   // await store.getSearchedResults(term: value);
                              // },
                              validator: (value) {
                                if (value != null) {
                                  if (value == '') {
                                    return 'Remarks are mandatory';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                              maxLines: 5,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      blockSizeHorizontal(context: context) * 4,
                                  vertical:
                                      blockSizeVertical(context: context) * 1.5,
                                ),
                                hintText: 'Add remarks....',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: ConstantData.fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: font15Px(context: context),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontFamily: ConstantData.fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: font12Px(context: context) * 1.1,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(font18Px(context: context)),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(font18Px(context: context)),
                                  ),
                                  borderSide: BorderSide(
                                    color: ConstantData.clrBorder,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          font18Px(context: context))),
                                  borderSide: BorderSide(
                                    color: ConstantData.clrBorder,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(font18Px(context: context)),
                                  ),
                                  borderSide: BorderSide(
                                    color: ConstantData.clrBorder,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ConstantWidget.alertDialog(
                                      context: _,
                                      buttonText: 'Cancel',
                                      title:
                                          'Sure you want to cancel the order?',
                                      func: () async {
                                        Navigator.pop(context);
                                        if (remarksContoller.text
                                            .trim()
                                            .isNotEmpty) {
                                          await widget.orderHistoryStore
                                              .cancelOrder(
                                            id: widget.model.orderId,
                                            remarks:
                                                remarksContoller.text.trim(),
                                            context: context,
                                          );
                                          remarksContoller.clear();
                                        } else {
                                          final snackBar =
                                              ConstantWidget.customSnackBar(
                                                  text:
                                                      'Please add the remarks',
                                                  context: context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  );
                                  setState(() {
                                    cancelOrder = !cancelOrder;
                                  });
                                },
                                child: Container(
                                  width: ConstantWidget.getWidthPercentSize(
                                      context, 20),
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        blockSizeVertical(context: context) *
                                            1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ConstantData.primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ConstantWidget.getCustomText(
                                    'Cancel',
                                    ConstantData.bgColor,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w600,
                                    font15Px(context: context),
                                  ),
                                ),
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
        ),
        Offstage(
          offstage:
              widget.model.orderStatusType == OrderStatusType.DISPATCHED ||
                  widget.model.orderStatusType == OrderStatusType.CONFIRMED,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context),
            ),
            child: Container(
              decoration: BoxDecoration(color: ConstantData.bgColor),
              padding: EdgeInsets.symmetric(
                vertical: blockSizeVertical(context: context) * 2,
                horizontal: blockSizeHorizontal(context: context) * 4,
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      // await orderHistoryStore.downloadInvoice(
                      //     invoice: model.orderId, context: context);
                      setState(() {
                        viewInvoice = !viewInvoice;
                      });
                    },
                    child: Row(
                      children: [
                        ConstantWidget.getCustomText(
                          'Invoice',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font22Px(context: context),
                        ),
                        const Spacer(),
                        Icon(
                          (viewInvoice)
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right_outlined,
                          size: font25Px(context: context),
                          color: ConstantData.mainTextColor,
                        ),
                      ],
                    ),
                  ),
                  if (viewInvoice)
                    SizedBox(
                      height: blockSizeVertical(context: context) * 1.5,
                    ),
                  if (viewInvoice)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: blockSizeVertical(context: context) * 1.2),
                      child: InkWell(
                        onTap: () async {
                          final contact = await DataBox().readPhoneNo();
                          showDialog(
                            context: context,
                            builder: (context) => InvoiceView(
                              phone: contact,
                              url: '${widget.model.orderId}.pdf',
                              store: widget.orderHistoryStore,
                              invoice: widget.model.orderId,
                              detailsContext: context,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ConstantWidget.getCustomText(
                              'View Invoice',
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font15Px(context: context),
                            ),
                            SizedBox(
                              width: blockSizeHorizontal(context: context) * 2,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: font18Px(context: context),
                              color: ConstantData.mainTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (viewInvoice)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: blockSizeVertical(context: context) * 1.2),
                      child: InkWell(
                        onTap: () async {
                          await widget.orderHistoryStore.downloadInvoice(
                              invoice: widget.model.orderId, context: context);
                        },
                        child: Row(
                          children: [
                            ConstantWidget.getCustomText(
                              'Download Invoice',
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font15Px(context: context),
                            ),
                            SizedBox(
                              width: blockSizeHorizontal(context: context) * 2,
                            ),
                            Icon(
                              Icons.download,
                              size: font22Px(context: context),
                              color: ConstantData.mainTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context)),
          child: Container(
            decoration: BoxDecoration(color: ConstantData.bgColor),
            padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context) * 2,
              horizontal: blockSizeHorizontal(context: context) * 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getCustomText(
                  'Order Details',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.2,
                ),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 3),
                ),
                Row(
                  children: [
                    ConstantWidget.getCustomText(
                      'Item Charges',
                      Colors.black45,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font12Px(context: context) * 1.2,
                    ),
                    const Spacer(),
                    ConstantWidget.getCustomText(
                      '₹${widget.model.roundValTotal}',
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
                      'Order Total',
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font15Px(context: context) * 1.1,
                    ),
                    const Spacer(),
                    ConstantWidget.getCustomText(
                      '₹${widget.model.roundValTotal}',
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
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context)),
          child: Container(
            decoration: BoxDecoration(color: ConstantData.bgColor),
            padding: EdgeInsets.symmetric(
              vertical: blockSizeVertical(context: context) * 2,
              horizontal: blockSizeHorizontal(context: context) * 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getCustomText(
                  'Shipping Address',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.1,
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ConstantWidget.getCustomText(
                        widget.profileStore.profileModel.firmInfoModel.address,
                        ConstantData.mainTextColor,
                        4,
                        TextAlign.left,
                        FontWeight.w600,
                        font15Px(context: context) * 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget productDetailsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidget.getCustomText(
          'Product Details',
          ConstantData.mainTextColor,
          1,
          TextAlign.left,
          FontWeight.w600,
          font22Px(context: context),
        ),
        SizedBox(height: blockSizeVertical(context: context) * 2),
        Container(
          height: ConstantWidget.getScreenPercentSize(context, 30),
          child: ListView.builder(
            itemCount: widget.model.ordersList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return ProductDetailsTile(
                model: widget.model.ordersList[index],
                productsStore: widget.productsStore,
                loginStore: widget.loginStore,
              );
            },
          ),
        ),
      ],
    );
  }

  Padding OrderDetailHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: blockSizeVertical(context: context),
      ),
      child: Container(
        decoration: BoxDecoration(color: ConstantData.bgColor),
        padding: EdgeInsets.symmetric(
          horizontal: blockSizeHorizontal(context: context) * 4,
          vertical: blockSizeVertical(context: context) * 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getCustomText(
              'Order #${widget.model.orderId}',
              ConstantData.mainTextColor,
              1,
              TextAlign.center,
              FontWeight.w600,
              font18Px(context: context),
            ),
            SizedBox(
              height: blockSizeVertical(context: context) * 2,
            ),
            Row(
              children: [
                ConstantWidget.getCustomText(
                  'Payment Mode : ',
                  Colors.black38,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font15Px(context: context),
                ),
                SizedBox(
                  width: blockSizeHorizontal(context: context) * 2,
                ),
                ConstantWidget.getCustomText(
                  getText(paymentStatus: widget.model.paymentStatusType),
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
    );
  }
}

class OrderTrackingRadioTile extends StatelessWidget {
  const OrderTrackingRadioTile({
    Key? key,
    required this.orderStatusType,
    required this.date,
    required this.color,
    this.status,
  }) : super(key: key);

  final OrderStatusType orderStatusType;
  final String? status;
  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context) * 1.5,
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 13,
            color: color,
          ),
          SizedBox(
            width: blockSizeHorizontal(context: context) * 7,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidget.getCustomText(
                status ?? orderStatusType.orderStatusString(),
                ConstantData.mainTextColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font15Px(context: context) * 1.1,
              ),
              SizedBox(
                height: blockSizeHorizontal(context: context) * 2,
              ),
              ConstantWidget.getCustomText(
                date,
                Colors.black38,
                1,
                TextAlign.center,
                FontWeight.w600,
                font15Px(context: context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDetailsTile extends StatelessWidget {
  const ProductDetailsTile({
    Key? key,
    required this.model,
    required this.productsStore,
    required this.loginStore,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore productsStore;
  final LoginStore loginStore;

  @override
  Widget build(BuildContext context) {
    double imageSize = ConstantWidget.getWidthPercentSize(context, 20);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: productUrl + model.productImg,
                fit: BoxFit.cover,
                height: imageSize,
                width: imageSize * 1.5,
              ),
            ),
          ),
          SizedBox(
            width: blockSizeHorizontal(context: context) * 4,
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getCustomText(
                  model.productName,
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.1,
                ),
                SizedBox(
                  height: blockSizeVertical(context: context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstantWidget.getCustomText(
                      '₹${model.mrp}',
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font18Px(context: context),
                    ),
                    // const Spacer(),
                    ConstantWidget.getCustomText(
                      'Qty: ${model.quantity}',
                      Colors.black38,
                      1,
                      TextAlign.center,
                      FontWeight.w600,
                      font15Px(context: context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsProductList extends StatelessWidget {
  const OrderDetailsProductList({
    Key? key,
    required this.list,
    required this.store,
    required this.model,
  }) : super(key: key);

  final List<ProductModel> list;
  final OrderHistoryModel model;
  final OrderHistoryStore store;

  @override
  Widget build(BuildContext context) {
    double imageSize = safeBlockVertical(context: context) * 9;
    // double smallTextSize = ConstantWidget.getScreenPercentSize(context, 1.6);
    double margin = safeBlockVertical(context: context) * 2;

    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 0.3,
                        color: ConstantData.textColor,
                        margin: EdgeInsets.only(bottom: margin, top: margin),
                      ),
                      Row(
                        children: [
                          Container(
                            height: imageSize,
                            width: imageSize,
                            margin: EdgeInsets.only(right: margin),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: ConstantData.cellColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(margin),
                              ),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      productUrl + list[index].productImg),
                                  fit: BoxFit.cover),
                            ),
                            // child: Image.asset(ConstantData.assetsPath +
                            //     myOrderList[index].image),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ConstantWidget.getCustomText(
                                      list[index].productName,
                                      ConstantData.mainTextColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      font18Px(context: context),
                                    ),
                                    const Spacer(),
                                    ConstantWidget.getCustomText(
                                      "Quantity: ",
                                      ConstantData.textColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      font15Px(context: context),
                                    ),
                                    ConstantWidget.getCustomText(
                                      list[index].quantity,
                                      ConstantData.accentColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      font15Px(context: context),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: ConstantWidget.getCustomText(
                                    '₹${list[index].totalQtyPrice}',
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w600,
                                    font15Px(context: context) * 1.1,
                                  ),
                                ),
                                Observer(builder: (_) {
                                  final index = store.orders.indexWhere(
                                      (element) =>
                                          element.orderId == model.orderId);
                                  final state =
                                      store.orders[index].orderStatusType;

                                  switch (state) {
                                    case OrderStatusType.CONFIRMED:
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.brightness_1,
                                            color: Colors.grey,
                                            size: 10,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child:
                                                  ConstantWidget.getCustomText(
                                                "Confirmed at ${model.placedDateTime.split(' ')[1]}",
                                                ConstantData.textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                font15Px(context: context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );

                                    case OrderStatusType.DISPATCHED:
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.brightness_1,
                                            color: Colors.grey,
                                            size: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: ConstantWidget.getCustomText(
                                                "Dispatched at ${model.dispatchedDate}",
                                                ConstantData.textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.8)),
                                          ),
                                        ],
                                      );
                                    case OrderStatusType.DELIVERED:
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.brightness_1,
                                            color: Colors.grey,
                                            size: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: ConstantWidget.getCustomText(
                                                "Delivered at ${model.deliveredDate}",
                                                ConstantData.textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.8)),
                                          ),
                                        ],
                                      );
                                    case OrderStatusType.CANCELLED:
                                      return const SizedBox();
                                  }
                                }),
                              ],
                            ),
                          )
                        ],
                      ),

                      //   ],
                      // )
                    ],
                  ),
                ),
                onTap: () {},
              );
            }));
  }
}
