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
import 'package:medrpha_customer/products/utils/product_card.dart';
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

      // print('------ status of prod --------${state1.name}');

      switch (state1) {
        case StoreState.LOADING:
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
              childAspectRatio:
                  ConstantWidget.getWidthPercentSize(context, 40) /
                      ConstantWidget.getScreenPercentSize(context, 35),
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
                firstHeight: ConstantWidget.getWidthPercentSize(context, 20),
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
