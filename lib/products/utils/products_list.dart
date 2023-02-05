// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class CategoryProducts extends StatelessWidget {
  /// View list of products based on [ProductModel] and [CategoryModel]
  const CategoryProducts({
    Key? key,
    required this.store,
    required this.loginStore,
    required this.profileStore,
    required this.bottomNavigationStore,
    required this.orderHistoryStore,
    required this.list,
    required this.state,
  }) : super(key: key);

  final ProductsStore store;
  final List<ProductModel> list;
  final StoreState state;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final state1 = store.prodState;

      print('------ status of prod --------${state1.name}');

      switch (state1) {
        case StoreState.LOADING:
          // return Center(
          //   child: LoadingAnimationWidget.dotsTriangle(
          //     color: ConstantData.accentColor,
          //     size: ConstantWidget.getScreenPercentSize(context, 7),
          //   ),
          // );
          return Center(
            child: SizedBox(
              height: ConstantWidget.getWidthPercentSize(context, 10),
              width: ConstantWidget.getWidthPercentSize(context, 10),
              child: const CircularProgressIndicator(),
            ),
          );

        case StoreState.SUCCESS:
          return ProductsList(
            store: store,
            list: list,
            axis: Axis.vertical,
            itemCount: list.length,
            loginStore: loginStore,
            profileStore: profileStore,
            orderHistoryStore: orderHistoryStore,
            bottomNavigationStore: bottomNavigationStore,
          );
        case StoreState.ERROR:
          return Container(
            height: ConstantWidget.getScreenPercentSize(context, 50),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: ConstantWidget.getScreenPercentSize(context, 12),
                // ),
                Image.asset(
                  '${ConstantData.assetsPath}med_logo_text.png',
                  height: ConstantWidget.getScreenPercentSize(context, 15),
                  width: ConstantWidget.getWidthPercentSize(context, 30),
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ConstantWidget.getWidthPercentSize(context, 10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ConstantWidget.getCustomText(
                          store.message,
                          ConstantData.mainTextColor,
                          3,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context) * 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        case StoreState.EMPTY:
          return Center(
            child: ConstantWidget.errorWidget(
              context: context,
              height: 20,
              width: 25,
              // fontSize: font15Px(context: context),
            ),
          );
      }
    });
  }
}

class ProductsList extends StatelessWidget {
  /// List of products
  const ProductsList({
    required this.list,
    required this.axis,
    required this.itemCount,
    required this.store,
    required this.loginStore,
    required this.profileStore,
    required this.bottomNavigationStore,
    required this.orderHistoryStore,
    Key? key,
  }) : super(key: key);

  final List<ProductModel> list;
  final Axis axis;
  final int itemCount;
  final ProductsStore store;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 40);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 35);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);

    return (list.isNotEmpty)
        ? GridView.builder(
            padding: EdgeInsets.only(
              left: sideMargin,
              right: sideMargin,
              bottom: margin,
            ),
            // shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: sideMargin,
              mainAxisSpacing: sideMargin,
            ),
            // physics: const BouncingScrollPhysics(),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return ProductsCard(
                store: store,
                loginStore: loginStore,
                list: list,
                width: width,
                firstHeight: ConstantWidget.getWidthPercentSize(context, 17),
                radius: radius,
                sideMargin: sideMargin,
                remainHeight: remainHeight,
                index: index,
                profileStore: profileStore,
                orderHistoryStore: orderHistoryStore,
                bottomNavigationStore: bottomNavigationStore,
              );
            })
        : Center(
            child: ConstantWidget.errorWidget(
              context: context,
              height: 20,
              width: 25,
              // fontSize: font15Px(context: context),
            ),
          );
  }
}

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
              value: store,
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
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
                color: ConstantData.borderColor,
                width: ConstantWidget.getWidthPercentSize(context, 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
              )
            ]),
        child: Stack(
          children: [
            Observer(builder: (_) {
              final adminStatus = loginStore.loginModel.adminStatus;
              return Offstage(
                offstage: !adminStatus,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(sideMargin / 7),
                    decoration: BoxDecoration(
                      color: ConstantData.accentColor,
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
                        font12Px(context: context)),
                  ),
                ),
              );
            }),
            Container(
              padding: EdgeInsets.all((sideMargin / 2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: firstHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(font18Px(context: context)),
                          child: CachedNetworkImage(
                              imageUrl: ConstantData.productUrl +
                                  list[index].productImg,
                              height: firstHeight,
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 22),
                              fit: BoxFit.cover,
                              placeholder: (_, s) => Image.asset(
                                  '${ConstantData.assetsPath}no_image.png')),
                        ),
                        Observer(builder: (_) {
                          final adminStatus = loginStore.loginModel.adminStatus;
                          if (adminStatus) {
                            return Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ConstantWidget.getLineTextView(
                                  '₹${list[index].oldMrp}',
                                  Colors.grey,
                                  font12Px(context: context),
                                ),
                                SizedBox(
                                  height: ConstantWidget.getPercentSize(
                                      firstHeight, 8),
                                ),
                                ConstantWidget.getCustomText(
                                  '₹${list[index].newMrp}',
                                  ConstantData.mainTextColor,
                                  1,
                                  TextAlign.start,
                                  FontWeight.w600,
                                  font15Px(context: context),
                                ),
                                SizedBox(
                                  height: ConstantWidget.getPercentSize(
                                      firstHeight, 8),
                                ),
                              ],
                            ));
                          } else {
                            return const SizedBox();
                          }
                        })
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ConstantWidget.getPercentSize(remainHeight, 8),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ConstantWidget.getCustomText(
                              list[index].productName,
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.w600,
                              font15Px(context: context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ConstantWidget.getPercentSize(remainHeight, 8),
                      ),
                      ConstantWidget.getCustomText(
                        'Avl Qty : ${(list[index].quantity.length > 4) ? '${list[index].quantity.substring(0, 4)}...' : list[index].quantity}',
                        ConstantData.textColor,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        font12Px(context: context),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Observer(builder: (_) {
              final adminStatus = loginStore.loginModel.adminStatus;

              return Offstage(
                offstage: !adminStatus,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: blockSizeHorizontal(context: context),
                      bottom: blockSizeVertical(context: context),
                    ),
                    child: Observer(builder: (_) {
                      final _index = store.cartModel.productList.indexWhere(
                          (element) => element.pid == list[index].pid);

                      if (list[index].cartQuantity >= 1 && _index != -1) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: RemoveButton(
                                store: store,
                                model: list[index],
                                width:
                                    blockSizeVertical(context: context) / 1.2,
                                height:
                                    blockSizeHorizontal(context: context) * 4,
                                fontSize: font12Px(context: context),
                              ),
                            ),
                            const Spacer(),
                            PlusMinusWidget(
                              model: list[index],
                              store: store,
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
            }),
          ],
        ),
      ),
    );
  }
}
