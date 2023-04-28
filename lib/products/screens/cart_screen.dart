import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/checkout_screen.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/products/utils/product_card.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

import '../../api_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key? key,
    // required this.list,
  }) : super(key: key);

  // final List<ProductModel> list;

  @override
  Widget build(BuildContext context) {
    double leftMargin = MediaQuery.of(context).size.width * 0.04;

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return WillPopScope(
      child: Scaffold(
        backgroundColor: ConstantData.bgColor,
        bottomNavigationBar: Container(
          height: ConstantWidget.getScreenPercentSize(context, 16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            // overflow: Overflow.visible,
            children: [
              Container(
                height: ConstantWidget.getScreenPercentSize(context, 10),
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 4,
                  vertical: blockSizeVertical(context: context) * 1.5,
                ),
                decoration: BoxDecoration(
                  color: ConstantData.bgColor,
                  borderRadius: BorderRadius.circular(12),

                  boxShadow: [
                    BoxShadow(
                      color: ConstantData.textColor,
                      blurRadius: 4,
                      // spreadRadius: 4,
                      offset: const Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                  // borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: blockSizeHorizontal(context: context) * 4),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstantWidget.getCustomText(
                              'Amount:',
                              ConstantData.primaryColor,
                              1,
                              TextAlign.start,
                              FontWeight.w600,
                              font18Px(context: context) * 1.18,
                              // 1.2,
                            ),
                            SizedBox(
                              height: blockSizeVertical(context: context),
                            ),
                            Observer(builder: (_) {
                              final adminStatus =
                                  loginStore.loginModel.adminStatus;

                              // print(
                              //     'check cart price-------- ${store.cartModel.totalSalePrice}');

                              return ConstantWidget.getCustomText(
                                '₹${(adminStatus) ? double.parse(store.cartModel.totalSalePrice).toStringAsFixed(2) : '0'}',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.end,
                                FontWeight.w600,
                                font18Px(context: context) * 1.2,
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: blockSizeVertical(context: context) * 2,
                    // ),
                    const Spacer(),

                    Expanded(
                      flex: 5,
                      child: Observer(builder: (_) {
                        final adminStatus = loginStore.loginModel.adminStatus;
                        return InkWell(
                          onTap: () {
                            // if admin approval is pending
                            if (!adminStatus) {
                              Fluttertoast.showToast(
                                  msg: 'Admin Approval is Pending');
                            } else {
                              final check = store.cartModel.productList
                                  .indexWhere(
                                      (element) => element.subTotal == '0.00');
                              if (check != -1) {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please remove the unnecessary products');
                              }
                              // else if (double.parse(
                              //         store.cartModel.totalSalePrice) <
                              //     500.00) {
                              //   Fluttertoast.showToast(
                              //       msg: 'Mimimum Order of ₹500');
                              // }
                              else {
                                if (store.cartModel.productList.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Provider.value(
                                        value: profileStore,
                                        child: Provider.value(
                                          value: store,
                                          child: Provider.value(
                                            value: loginStore,
                                            child: Provider.value(
                                              value: orderHistoryStore,
                                              child: Provider.value(
                                                value: bottomNavigationStore,
                                                child: const CheckoutScreen(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'No products in cart',
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: blockSizeVertical(context: context) * 2,
                              // horizontal:
                              //     blockSizeHorizontal(context: context) * 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  font25Px(context: context)),
                              color: ConstantData.primaryColor,
                            ),
                            child: ConstantWidget.getCustomText(
                              'Continue',
                              ConstantData.bgColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font18Px(context: context) * 1.12,
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Observer(builder: (_) {
            final state = store.cartState;

            return Stack(
              children: [
                Column(
                  children: [
                    ConstantWidget.customAppBar(
                        context: context, title: 'Cart'),
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
                    Observer(builder: (_) {
                      final show = store.cartModel.productList.length;
                      if (show == 0 || !loginStore.loginModel.adminStatus) {
                        return Expanded(
                          child: Icon(
                            CupertinoIcons.cart,
                            color: Colors.black38,
                            size:
                                ConstantWidget.getWidthPercentSize(context, 30),
                          ),
                        );
                      } else {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: leftMargin,
                              right: leftMargin,
                              // bottom: MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: store.cartModel.productList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MultiProvider(
                                            providers: [
                                              Provider.value(value: store),
                                              Provider.value(value: loginStore),
                                              Provider.value(
                                                  value: profileStore),
                                              Provider.value(
                                                  value: orderHistoryStore),
                                              Provider.value(
                                                  value: bottomNavigationStore),
                                            ],
                                            child: ProductsDetailScreen(
                                              model: store
                                                  .cartModel.productList[index],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListItem(
                                      model: store.cartModel.productList[index],
                                      store: store,
                                      loginStore: loginStore,
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    }),
                  ],
                ),
                if (state == StoreState.LOADING)
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
      onWillPop: () {
        return Future.value(true);
      },
    );
  }

  getRoWCell(String s, String s1, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ConstantWidget.getCustomText(s, ConstantData.textColor, 1,
              TextAlign.start, FontWeight.w600, font18Px(context: context)),
        ),
        Expanded(
          flex: 1,
          child: ConstantWidget.getCustomText(s1, ConstantData.textColor, 1,
              TextAlign.end, FontWeight.w600, font18Px(context: context)),
        )
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  final ProductModel model;
  final LoginStore loginStore;
  final ProductsStore store;

  const ListItem({
    Key? key,
    required this.model,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 22);
    double imageSize = ConstantWidget.getScreenPercentSize(context, 14);
    double margin = ConstantWidget.getScreenPercentSize(context, 1.5);
    double radius = ConstantWidget.getScreenPercentSize(context, 1.5);

    // setThemePosition();
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: ConstantData.borderColor,
            width: ConstantWidget.getWidthPercentSize(context, 0.08)),
      ),
      margin: EdgeInsets.only(top: margin, bottom: margin),
      height: height,
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: imageWidget(imageSize, margin, context),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: (margin * 1.2)),
              // child: Row(
              child: Stack(
                children: [
                  productDataWidget(context),

                  ///------------------- Remove from cart ---------------------------------
                  Align(
                    alignment: Alignment.topRight,
                    child: removeCartWiget(context),
                  ),
                  Observer(builder: (_) {
                    if (model.subTotal == '0.00') return const SizedBox();
                    return Align(
                      alignment: Alignment.centerRight,
                      child: addToCartWidget(context),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding addToCartWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeHorizontal(context: context) * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Observer(
          //       builder: (_) {
          //         return PlusMinusWidget(
          //           model: model,
          //           store: store,
          //         );
          //       },
          //     ),
          //   ],
          // ),
          CartQuantityWidget(
            model: model,
            store: store,
            fontSize: font18Px(context: context),
            padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 4,
              vertical: blockSizeHorizontal(context: context) * 2,
            ),
          ),
          SizedBox(
            width: ConstantWidget.getWidthPercentSize(context, 3),
          ),
        ],
      ),
    );
  }

  Widget removeCartWiget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeHorizontal(context: context) * 2,
      ),
      child: Observer(
        builder: (_) {
          return InkWell(
            onTap: () async {
              store.removeState = StoreState.LOADING;
              await store.removeFromCart(
                model: model,
                // context: context,
              );
              store.removeState = StoreState.SUCCESS;
            },
            child: Icon(
              CupertinoIcons.delete,
              color: ConstantData.color1,
              size: font25Px(context: context),
            ),
          );
          // }
        },
      ),
    );
  }

  Column productDataWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ConstantWidget.getCustomText(
                model.productName,
                ConstantData.mainTextColor,
                3,
                TextAlign.start,
                FontWeight.w600,
                font18Px(context: context) * 1.12,
              ),
            ),
          ],
        ),
        SizedBox(
          height: blockSizeVertical(context: context) * 2,
        ),
        ConstantWidget.getLineTextView(
          'MRP : ₹${model.oldMrp}',
          Colors.grey,
          font15Px(context: context) * 1.1,
        ),
        SizedBox(
          height: blockSizeHorizontal(context: context) * 2,
        ),
        ConstantWidget.getCustomText(
          '₹${model.newMrp}',
          ConstantData.primaryColor,
          1,
          TextAlign.start,
          FontWeight.w600,
          font18Px(context: context) * 1.1,
        ),
        SizedBox(
          height: blockSizeVertical(context: context) * 1.5,
        ),
        Padding(
          padding: EdgeInsets.only(
            right: blockSizeHorizontal(context: context) * 2,
          ),
          child: Divider(
            color: ConstantData.primaryColor,
            thickness: 0.8,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstantWidget.getCustomText(
                'Sub-Total:',
                ConstantData.mainTextColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font18Px(context: context) * 1.12,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: blockSizeHorizontal(context: context) * 2),
                child: ConstantWidget.getCustomText(
                  '₹${(double.parse(model.newMrp) * (model.cartQuantity)).toStringAsFixed(2)}',
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font18Px(context: context) * 1.12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container imageWidget(double imageSize, double margin, BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all((margin / 5)),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // color: ConstantData.bgColor,

        borderRadius: BorderRadius.all(
          Radius.circular(
            font18Px(context: context),
          ),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            (model.productImg != '')
                ? productUrl + model.productImg
                : 'https://www.labikineria.shop/assets/images/no_image.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  getCartButton(var icon, Function function, BuildContext context) {
    double mainHeight = ConstantWidget.getScreenPercentSize(context, 15);

    double height = ConstantWidget.getPercentSize(mainHeight, 23);

    return InkWell(
      child: Container(
        height: height,
        // margin: EdgeInsets.symmetric(horizontal: ConstantWidget.getPercentSize(height, 30)),
        width: height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
                color: Colors.grey,
                width: ConstantWidget.getPercentSize(height, 2))),
        child: Icon(
          icon,
          size: ConstantWidget.getPercentSize(height, 50),
          color: Colors.grey,
        ),
      ),
      onTap: () {},
    );
  }
}
