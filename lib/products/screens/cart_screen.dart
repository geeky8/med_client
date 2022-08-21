import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/checkout_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key? key,
    // required this.list,
  }) : super(key: key);

  // final List<ProductModel> list;

  @override
  Widget build(BuildContext context) {
    double leftMargin = MediaQuery.of(context).size.width * 0.04;
    // double radius = ConstantWidget.getScreenPercentSize(context, 4);
    // double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    // double padding = ConstantWidget.getScreenPercentSize(context, 1.5);
    // double bottomHeight = ConstantWidget.getScreenPercentSize(context, 6);

    // double subRadius = ConstantWidget.getPercentSize(bottomHeight, 10);

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return WillPopScope(
      child: Scaffold(
        backgroundColor: ConstantData.bgColor,
        bottomNavigationBar: Stack(
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
                            FontWeight.w500,
                            font18Px(context: context),
                            // 1.2,
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context),
                          ),
                          Observer(builder: (_) {
                            final adminStatus =
                                loginStore.loginModel.adminStatus;

                            return ConstantWidget.getCustomText(
                              '₹${(adminStatus) ? store.cartModel.totalSalePrice.toString() : '0'}',
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.end,
                              FontWeight.w500,
                              font18Px(context: context) * 1.1,
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
                          if (store.cartModel.productList.isNotEmpty &&
                              adminStatus) {
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
                            final snackBar = ConstantWidget.customSnackBar(
                                text: 'No items in cart', context: context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: blockSizeVertical(context: context) * 2,
                            // horizontal:
                            //     blockSizeHorizontal(context: context) * 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ConstantData.primaryColor,
                          ),
                          child: ConstantWidget.getCustomText(
                            'Continue',
                            ConstantData.bgColor,
                            1,
                            TextAlign.center,
                            FontWeight.w500,
                            font18Px(context: context),
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
                          child: ConstantWidget.errorWidget(
                            context: context,
                            height: 20,
                            width: 15,
                            // fontSize: font18Px(context: context),
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
                                  return ListItem(
                                    model: store.cartModel.productList[index],
                                    store: store,
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
              TextAlign.start, FontWeight.w500, font18Px(context: context)),
        ),
        Expanded(
          flex: 1,
          child: ConstantWidget.getCustomText(s1, ConstantData.textColor, 1,
              TextAlign.end, FontWeight.w500, font18Px(context: context)),
        )
      ],
    );
  }

  void removeItem(int index) {
    // setState(() {
    //   cartModelList.removeAt(index);
    // });
  }
}

// class CheckoutDialog extends StatelessWidget {
//   const CheckoutDialog({Key? key, required this.store}) : super(key: key);

//   final ProductsStore store;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 0,
//       backgroundColor: ConstantData.bgColor,
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.only(
//               left: ConstantData.padding,
//               top: ConstantData.avatarRadius + ConstantData.padding,
//               right: ConstantData.padding,
//               bottom: ConstantData.padding),
//           margin: const EdgeInsets.only(top: ConstantData.avatarRadius),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ConstantWidget.getCustomText(
//                   'Checkout',
//                   ConstantData.mainTextColor,
//                   1,
//                   TextAlign.center,
//                   FontWeight.w500,
//                   20),
//               const SizedBox(
//                 height: 10,
//               ),
//               ConstantWidget.getCustomText(
//                   'Confirm Checkout',
//                   ConstantData.mainTextColor,
//                   2,
//                   TextAlign.center,
//                   FontWeight.normal,
//                   14),
//               const SizedBox(
//                 height: 22,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 15, right: 15),
//                         decoration: BoxDecoration(
//                           color: Colors.grey,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             vertical: blockSizeVertical(context: context) * 2),
//                         child: ConstantWidget.getCustomText(
//                           'Cancel',
//                           ConstantData.bgColor,
//                           1,
//                           TextAlign.center,
//                           FontWeight.w500,
//                           font18Px(context: context),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Expanded(
//                     flex: 3,
//                     child: InkWell(
//                       onTap: () async {
//                         await store.checkout(
//                             context: context,
//                             func: () {
//                               Navigator.pop(context);
//                             });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 15, right: 15),
//                         decoration: BoxDecoration(
//                           color: ConstantData.primaryColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             vertical: blockSizeVertical(context: context) * 2),
//                         child: ConstantWidget.getCustomText(
//                           'Confirm',
//                           ConstantData.bgColor,
//                           1,
//                           TextAlign.center,
//                           FontWeight.w500,
//                           font18Px(context: context),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 10,
//           left: ConstantData.padding,
//           right: ConstantData.padding,
//           child: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: ConstantData.avatarRadius,
//             child: ClipRRect(
//                 borderRadius: const BorderRadius.all(
//                     Radius.circular(ConstantData.avatarRadius)),
//                 child: Image.asset(
//                   "${ConstantData.assetsPath}med_logo.png",
//                   color: ConstantData.mainTextColor,
//                 )),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ListItem extends StatelessWidget {
  // final SubCategoryModel subCategoryModel;

  // final int index;
  // final ValueChanged<int> onChanged;

  final ProductModel model;
  final ProductsStore store;

  const ListItem({
    Key? key,
    required this.model,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 20);
    double imageSize = ConstantWidget.getScreenPercentSize(context, 10);
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
            child: Container(
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
                    ConstantData.productUrl + model.productImg,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: (margin * 1.2)),
              // child: Row(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ConstantWidget.getCustomText(
                              model.productName,
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.w500,
                              font18Px(context: context),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   width: ConstantWidget.getPercentSize(height, 7),
                      // ),
                      // ConstantWidget.getCustomText(
                      //     model.company,
                      //     Colors.grey,
                      //     1,
                      //     TextAlign.start,
                      //     FontWeight.w500,
                      //     font15Px(context: context)),
                      SizedBox(
                        height:
                            ConstantWidget.getWidthPercentSize(context, 1.2),
                      ),
                      ConstantWidget.getLineTextView('₹${model.oldMrp}',
                          Colors.grey, font15Px(context: context)),
                      SizedBox(
                        height:
                            ConstantWidget.getWidthPercentSize(context, 1.2),
                      ),
                      ConstantWidget.getCustomText(
                          '₹${model.newMrp}',
                          ConstantData.accentColor,
                          1,
                          TextAlign.start,
                          FontWeight.w800,
                          font18Px(context: context)),
                      SizedBox(
                        height: blockSizeVertical(context: context) * 1.5,
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ConstantWidget.getCustomText(
                            'Sub-Total:',
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.center,
                            FontWeight.w500,
                            font18Px(context: context),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                    blockSizeHorizontal(context: context) * 2),
                            child: ConstantWidget.getCustomText(
                              '₹${model.subTotal}',
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.center,
                              FontWeight.w500,
                              font18Px(context: context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  ///------------------- Remove from cart ---------------------------------
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: blockSizeHorizontal(context: context) * 2,
                      ),
                      child: Observer(builder: (_) {
                        if (store.removeState == StoreState.LOADING) {
                          return ConstantWidget.loadingWidget(
                            size: blockSizeVertical(context: context) * 2,
                          );
                        } else {
                          return InkWell(
                            onTap: () async {
                              store.removeState = StoreState.LOADING;
                              await store.removeFromCart(
                                model: model,
                                context: context,
                              );
                              store.removeState = StoreState.SUCCESS;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ConstantData.clrBlack20,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(
                                  blockSizeHorizontal(context: context) * 1.5),
                              child: Icon(
                                Icons.close,
                                color: ConstantData.textColor,
                                size: ConstantWidget.getWidthPercentSize(
                                    context, 4),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: blockSizeHorizontal(context: context) * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Observer(builder: (_) {
                                return PlusMinusWidget(
                                    model: model, store: store);
                              }),
                            ],
                          ),
                          SizedBox(
                            width:
                                ConstantWidget.getWidthPercentSize(context, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
