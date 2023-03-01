// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/products/utils/quantity_dialog.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../bottom_navigation/store/bottom_navigation_store.dart';
import '../../order_history/stores/order_history_store.dart';
import '../../profile/store/profile_store.dart';
import '../../signup_login/store/login_store.dart';
import '../../utils/constant_data.dart';
import '../../utils/constant_widget.dart';
import '../store/products_store.dart';

// class ProductsCard extends StatelessWidget {
//   /// To display information of each [ProductModel]
//   const ProductsCard({
//     Key? key,
//     required this.store,
//     required this.loginStore,
//     required this.profileStore,
//     required this.bottomNavigationStore,
//     required this.orderHistoryStore,
//     required this.list,
//     required this.width,
//     required this.firstHeight,
//     required this.radius,
//     required this.sideMargin,
//     required this.remainHeight,
//     required this.index,
//   }) : super(key: key);

//   final ProductsStore store;
//   final LoginStore loginStore;
//   final ProfileStore profileStore;
//   final OrderHistoryStore orderHistoryStore;
//   final BottomNavigationStore bottomNavigationStore;
//   final List<ProductModel> list;
//   final double width;
//   final double firstHeight;
//   final double radius;
//   final double sideMargin;
//   final double remainHeight;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         // print(list[index].category);
//         ProductModel model = list[index];

//         if (list[index].expiryDate == '') {
//           model = await store.getProductDetails(model: list[index]);
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => Provider.value(
//               value: store..getRecommendations(model: model),
//               child: Provider.value(
//                 value: loginStore,
//                 child: Provider.value(
//                   value: profileStore,
//                   child: Provider.value(
//                     value: orderHistoryStore,
//                     child: Provider.value(
//                       value: bottomNavigationStore,
//                       child: ProductsDetailScreen(
//                         model: model,
//                         store: store,
//                         // modelIndex: index,
//                         // list: list,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         // margin: EdgeInsets.only(left: sideMargin),
//         height: firstHeight,
//         width: width,
//         decoration: BoxDecoration(
//             // color: ConstantData.bgColor,
//             borderRadius: BorderRadius.circular(radius),
//             border: Border.all(
//                 color: ConstantData.borderColor,
//                 width: ConstantWidget.getWidthPercentSize(context, 0.08)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade200,
//               )
//             ]),
//         child: Stack(
//           children: [
//             Observer(builder: (_) {
//               final adminStatus = loginStore.loginModel.adminStatus;
//               return Offstage(
//                 offstage: !adminStatus,
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Container(
//                     padding: EdgeInsets.all(sideMargin / 7),
//                     decoration: BoxDecoration(
//                       color: ConstantData.accentColor,
//                       borderRadius:
//                           BorderRadius.only(topRight: Radius.circular(radius)),
//                     ),
//                     child: ConstantWidget.getCustomText(
//                         list[index].percentDiscount,
//                         Colors.white,
//                         // ConstantData.accentColor,
//                         1,
//                         TextAlign.start,
//                         FontWeight.w600,
//                         font12Px(context: context)),
//                   ),
//                 ),
//               );
//             }),
//             Container(
//               padding: EdgeInsets.all((sideMargin / 2)),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: firstHeight,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius:
//                               BorderRadius.circular(font18Px(context: context)),
//                           child: CachedNetworkImage(
//                               imageUrl: ConstantData.productUrl +
//                                   list[index].productImg,
//                               height: firstHeight,
//                               width: ConstantWidget.getWidthPercentSize(
//                                   context, 22),
//                               fit: BoxFit.cover,
//                               errorWidget: (context, s, _) => Image.asset(
//                                   '${ConstantData.assetsPath}no_image.png'),
//                               placeholder: (_, s) => Image.asset(
//                                   '${ConstantData.assetsPath}no_image.png')),
//                         ),
//                         Observer(builder: (_) {
//                           final adminStatus = loginStore.loginModel.adminStatus;
//                           if (adminStatus) {
//                             return Expanded(
//                                 child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 ConstantWidget.getLineTextView(
//                                   '₹${list[index].oldMrp}',
//                                   Colors.grey,
//                                   font12Px(context: context),
//                                 ),
//                                 SizedBox(
//                                   height: ConstantWidget.getPercentSize(
//                                       firstHeight, 8),
//                                 ),
//                                 ConstantWidget.getCustomText(
//                                   '₹${list[index].newMrp}',
//                                   ConstantData.mainTextColor,
//                                   1,
//                                   TextAlign.start,
//                                   FontWeight.w600,
//                                   font15Px(context: context),
//                                 ),
//                                 SizedBox(
//                                   height: ConstantWidget.getPercentSize(
//                                       firstHeight, 8),
//                                 ),
//                               ],
//                             ));
//                           } else {
//                             return const SizedBox();
//                           }
//                         })
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: ConstantWidget.getPercentSize(remainHeight, 8),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ConstantWidget.getCustomText(
//                               list[index].productName,
//                               ConstantData.mainTextColor,
//                               1,
//                               TextAlign.start,
//                               FontWeight.w600,
//                               font15Px(context: context),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: ConstantWidget.getPercentSize(remainHeight, 8),
//                       ),
//                       ConstantWidget.getCustomText(
//                         'Avl Qty : ${(list[index].quantity.length > 4) ? '${list[index].quantity.substring(0, 4)}...' : list[index].quantity}',
//                         ConstantData.textColor,
//                         1,
//                         TextAlign.start,
//                         FontWeight.w600,
//                         font12Px(context: context),
//                       ),
//                     ],
//                   )),
//                 ],
//               ),
//             ),
//             Observer(builder: (_) {
//               final adminStatus = loginStore.loginModel.adminStatus;

//               return Offstage(
//                 offstage: !adminStatus,
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       right: blockSizeHorizontal(context: context),
//                       bottom: blockSizeVertical(context: context),
//                     ),
//                     child: Observer(builder: (_) {
//                       final _index = store.cartModel.productList.indexWhere(
//                           (element) => element.pid == list[index].pid);

//                       if (list[index].cartQuantity >= 1 && _index != -1) {
//                         return Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 5),
//                               child: RemoveButton(
//                                 store: store,
//                                 model: list[index],
//                                 width:
//                                     blockSizeVertical(context: context) / 1.2,
//                                 height:
//                                     blockSizeHorizontal(context: context) * 4,
//                                 fontSize: font12Px(context: context),
//                               ),
//                             ),
//                             const Spacer(),
//                             // PlusMinusWidget(
//                             //   model: list[index],
//                             //   store: store,
//                             // ),
//                             Observer(builder: (_) {
//                               // final updatedModel = updateCurrProduct(model);
//                               final model = list[index];
//                               return InkWell(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => QuantityDialog(
//                                       model: model,
//                                       store: store,
//                                     ),
//                                   );
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: blockSizeHorizontal(
//                                               context: context) *
//                                           3,
//                                       vertical:
//                                           blockSizeVertical(context: context)
//                                       // : 0,
//                                       ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(width: 1.2)),
//                                     padding: EdgeInsets.all(
//                                       blockSizeHorizontal(context: context) * 2,
//                                     ),
//                                     child: ConstantWidget.getCustomText(
//                                       '${(model.cartQuantity.toString().length > 4) ? '${model.cartQuantity.toString().substring(0, 3)}...' : model.cartQuantity}',
//                                       ConstantData.mainTextColor,
//                                       2,
//                                       TextAlign.center,
//                                       FontWeight.w600,
//                                       font15Px(context: context),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ],
//                         );
//                       } else {
//                         return AddProductButton(
//                           store: store,
//                           model: list[index],
//                           width: blockSizeHorizontal(context: context) * 4,
//                           height: blockSizeVertical(context: context) / 1.2,
//                           fontSize: font12Px(context: context),
//                           contextReq: context,
//                         );
//                       }
//                     }),
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ProductsCard extends StatelessWidget {
  /// To display information of each [ProductModel]
  const ProductsCard({
    Key? key,
    required this.store,
    required this.loginStore,
    required this.profileStore,
    required this.bottomNavigationStore,
    required this.orderHistoryStore,
    required this.list,
    required this.width,
    required this.firstHeight,
    required this.radius,
    required this.sideMargin,
    required this.remainHeight,
    required this.index,
  }) : super(key: key);

  final ProductsStore store;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;
  final List<ProductModel> list;
  final double width;
  final double firstHeight;
  final double radius;
  final double sideMargin;
  final double remainHeight;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // print(list[index].category);
        ProductModel model = list[index];

        if (list[index].expiryDate == '') {
          model = await store.getProductDetails(model: list[index]);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Provider.value(
              value: store..getRecommendations(model: model),
              child: Provider.value(
                value: loginStore,
                child: Provider.value(
                  value: profileStore,
                  child: Provider.value(
                    value: orderHistoryStore,
                    child: Provider.value(
                      value: bottomNavigationStore,
                      child: ProductsDetailScreen(
                        model: model,
                        store: store,
                        // modelIndex: index,
                        // list: list,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        // margin: EdgeInsets.only(left: sideMargin),
        height: firstHeight,
        width: width,
        decoration: BoxDecoration(
          // color: ConstantData.bgColor,
          borderRadius: BorderRadius.circular(
            font18Px(context: context),
          ),
          border: Border.all(
            color: Colors.black38,
            width: ConstantWidget.getWidthPercentSize(context, 0.08),
          ),
        ),
        child: Stack(
          children: [
            /// Image box
            ImageWidget(
              sideMargin: sideMargin,
              firstHeight: firstHeight,
              list: list,
              index: index,
              loginStore: loginStore,
              remainHeight: remainHeight,
            ),

            /// Dicount percentage
            DiscountPercent(
              loginStore: loginStore,
              sideMargin: sideMargin,
              radius: radius,
              list: list,
              index: index,
            ),

            /// Remaining Product Data visible
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ConstantWidget.getScreenPercentSize(context, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ProductNameTextWidget(
                        remainHeight: remainHeight,
                        list: list,
                        index: index,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ProductPriceWidget(
                          loginStore: loginStore,
                          list: list,
                          index: index,
                          firstHeight: firstHeight),
                    ),
                    ProductAddWidget(
                      loginStore: loginStore,
                      store: store,
                      list: list,
                      index: index,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductAddWidget extends StatelessWidget {
  const ProductAddWidget({
    Key? key,
    required this.loginStore,
    required this.store,
    required this.list,
    required this.index,
  }) : super(key: key);

  final LoginStore loginStore;
  final ProductsStore store;
  final List<ProductModel> list;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;

      return Padding(
        padding: EdgeInsets.all(blockSizeHorizontal(context: context)),
        child: Offstage(
          offstage: !adminStatus,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Observer(builder: (_) {
              final _index = store.cartModel.productList
                  .indexWhere((element) => element.pid == list[index].pid);

              if (list[index].cartQuantity >= 1 && _index != -1) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RemoveButton(
                      store: store,
                      model: list[index],
                      width: blockSizeVertical(context: context) / 1.2,
                      height: blockSizeHorizontal(context: context) * 4,
                      fontSize: font12Px(context: context),
                    ),
                    CartQuantityWidget(
                      model: list[index],
                      store: store,
                      fontSize: font15Px(context: context) * 1.1,
                      padding: EdgeInsets.symmetric(
                        horizontal: blockSizeHorizontal(context: context) * 2,
                        vertical: blockSizeHorizontal(context: context),
                      ),
                    ),
                  ],
                );
              } else {
                return AddProductButton(
                  store: store,
                  model: list[index],
                  width: blockSizeHorizontal(context: context) * 4,
                  height: blockSizeVertical(context: context) / 1.2,
                  fontSize: font12Px(context: context),
                  contextReq: context,
                );
              }
            }),
          ),
        ),
      );
    });
  }
}

class CartQuantityWidget extends StatelessWidget {
  const CartQuantityWidget({
    Key? key,
    required this.model,
    required this.store,
    required this.fontSize,
    required this.padding,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double fontSize;
  final EdgeInsets padding;

  ProductModel _updateProduct(ProductModel model) {
    final index = store.cartModel.productList
        .indexWhere((element) => element.pid == model.pid);
    return store.cartModel.productList[index];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final updatedModel = _updateProduct(model);
        showDialog(
          context: context,
          builder: (_) => QuantityDialog(
            model: updatedModel,
            store: store,
            // givenQty: model.cartQuantity,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            font15Px(context: context),
          ),
          border: Border.all(width: 1.2, color: ConstantData.primaryColor),
        ),
        padding: padding,
        child: Observer(builder: (_) {
          final updatedModel = _updateProduct(model);
          return ConstantWidget.getCustomText(
            'Qty : ${(updatedModel.cartQuantity.toString().length > 4) ? '${updatedModel.cartQuantity.toString().substring(0, 3)}...' : updatedModel.cartQuantity}',
            ConstantData.mainTextColor,
            2,
            TextAlign.center,
            FontWeight.w600,
            fontSize,
          );
        }),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key? key,
    required this.sideMargin,
    required this.firstHeight,
    required this.list,
    required this.index,
    required this.loginStore,
    required this.remainHeight,
  }) : super(key: key);

  final double sideMargin;
  final double firstHeight;
  final List<ProductModel> list;
  final int index;
  final LoginStore loginStore;
  final double remainHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(font18Px(context: context)),
          child: CachedNetworkImage(
              imageUrl: ConstantData.productUrl + list[index].productImg,
              height: ConstantWidget.getScreenPercentSize(context, 15),
              width: ConstantWidget.getWidthPercentSize(context, 45),
              fit: BoxFit.cover,
              errorWidget: (context, s, _) =>
                  Image.asset('${ConstantData.assetsPath}no_image.png'),
              placeholder: (_, s) =>
                  Image.asset('${ConstantData.assetsPath}no_image.png')),
        ),
      ],
    );
  }
}

class ProductPriceWidget extends StatelessWidget {
  const ProductPriceWidget({
    Key? key,
    required this.loginStore,
    required this.list,
    required this.index,
    required this.firstHeight,
  }) : super(key: key);

  final LoginStore loginStore;
  final List<ProductModel> list;
  final int index;
  final double firstHeight;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;
      if (adminStatus) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidget.getLineTextView(
                    'MRP : ₹${list[index].oldMrp}',
                    Colors.grey,
                    font12Px(context: context),
                  ),
                  SizedBox(
                    height: ConstantWidget.getPercentSize(firstHeight, 8),
                  ),
                  ConstantWidget.getCustomText(
                    '₹${list[index].newMrp}',
                    ConstantData.primaryColor,
                    1,
                    TextAlign.start,
                    FontWeight.w600,
                    font18Px(context: context),
                  ),
                ],
              ),
              ConstantWidget.getCustomText(
                'Avl Qty : ${(list[index].quantity.length > 4) ? '${list[index].quantity.substring(0, 4)}...' : list[index].quantity}',
                ConstantData.textColor,
                2,
                TextAlign.start,
                FontWeight.w600,
                font15Px(context: context),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}

class ProductNameTextWidget extends StatelessWidget {
  const ProductNameTextWidget({
    Key? key,
    required this.remainHeight,
    required this.list,
    required this.index,
  }) : super(key: key);

  final double remainHeight;
  final List<ProductModel> list;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeHorizontal(context: context),
      ),
      child: ConstantWidget.getCustomText(
        list[index].productName,
        ConstantData.mainTextColor,
        3,
        TextAlign.left,
        FontWeight.w600,
        font15Px(context: context) * 1.1,
      ),
    );
  }
}

class DiscountPercent extends StatelessWidget {
  const DiscountPercent({
    Key? key,
    required this.loginStore,
    required this.sideMargin,
    required this.radius,
    required this.list,
    required this.index,
    this.isViewList,
  }) : super(key: key);

  final LoginStore loginStore;
  final double sideMargin;
  final double radius;
  final List<ProductModel> list;
  final int index;
  final bool? isViewList;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;
      return Offstage(
        offstage: !adminStatus,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: (isViewList != null)
                ? EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal(context: context) * 3,
                    vertical: blockSizeHorizontal(context: context) * 1.5,
                  )
                : EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal(context: context) * 2,
                    vertical: blockSizeHorizontal(context: context),
                  ),
            decoration: BoxDecoration(
              color: ConstantData.color1,
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(radius)),
            ),
            child: ConstantWidget.getCustomText(
              list[index].percentDiscount,
              Colors.white,
              // ConstantData.accentColor,
              1,
              TextAlign.start,
              FontWeight.w600,
              (isViewList != null)
                  ? font15Px(context: context)
                  : font12Px(context: context),
            ),
          ),
        ),
      );
    });
  }
}
