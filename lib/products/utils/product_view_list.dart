// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
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

class ProductViewList extends StatelessWidget {
  const ProductViewList({
    Key? key,
    required this.loginStore,
    required this.profileStore,
    required this.orderHistoryStore,
    required this.bottomNavigationStore,
    required this.list,
    required this.store,
    this.termValue,
    this.control,
  }) : super(key: key);

  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;
  final List<ProductModel> list;
  final ProductsStore store;
  final bool? control;
  final String? termValue;

  Future<void> getPaginatedResults() async {
    switch (categoriesfromValue(list[0].category)) {
      case CategoriesType.ETHICAL:
        store.ethicalPageIndex++;
        debugPrint('---- page index------${store.ethicalPageIndex}');
        await store.getEthicalProducts(
          load: true,
        );
        break;
      case CategoriesType.GENERIC:
        store.genericPageIndex++;
        debugPrint('---- page index------${store.genericPageIndex}');
        await store.getGenericProducts(
          load: true,
        );
        break;
      case CategoriesType.SURGICAL:
        store.surgicalPageIndex++;
        debugPrint('---- page index------${store.surgicalPageIndex}');
        await store.getSurgicalProducts(
          load: true,
        );
        break;
      case CategoriesType.VETERINARY:
        store.vetPageIndex++;
        debugPrint('---- page index------${store.vetPageIndex}');
        await store.getVeterinaryProducts(
          load: true,
        );
        break;

      case CategoriesType.AYURVEDIC:
        store.ayurvedicPageIndex++;
        debugPrint('---- page index------${store.ayurvedicPageIndex}');
        await store.getAyurvedicProducts(
          load: true,
        );
        break;
      case CategoriesType.GENERAL:
        store.generalPageIndex++;
        debugPrint('---- page index------${store.generalPageIndex}');
        await store.getGenerallProducts(
          load: true,
        );
        break;
      case CategoriesType.VACCINE:
        store.vaccinePageIndex++;
        debugPrint('---- page index------${store.vaccinePageIndex}');
        await store.getVaccineProducts(
          load: true,
        );
        break;
    }
  }

  void addToList(ProductModel model) {
    switch (categoriesfromValue(model.category)) {
      case CategoriesType.ETHICAL:
        store.ethicalProductList.add(model);
        break;
      case CategoriesType.GENERIC:
        store.genericProductList.add(model);
        break;
      case CategoriesType.SURGICAL:
        store.surgicalProductList.add(model);
        break;
      case CategoriesType.VETERINARY:
        store.veterinaryProductList.add(model);
        break;
      case CategoriesType.AYURVEDIC:
        store.ayurvedicProductList.add(model);
        break;
      case CategoriesType.GENERAL:
        store.generalProductList.add(model);
        break;
      case CategoriesType.VACCINE:
        store.vaccineProductList.add(model);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 60);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 60);
    double remainHeight = height - firstHeight;

    final scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          termValue == null) {
        store.paginationState = StoreState.LOADING;
        await getPaginatedResults();
        store.paginationState = StoreState.SUCCESS;
      }
    });

    double radius = ConstantWidget.getPercentSize(height, 5);
    return (list.isNotEmpty)
        ? ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: blockSizeVertical(context: context) * 2.5,
                ),
            padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 4),
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  ProductModel model = list[index];

                  if (list[index].expiryDate == '') {
                    model = await store.getProductDetails(model: list[index]);
                  }

                  addToList(model);

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
                                  // store: store,
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
                  // }
                },
                child: Container(
                  height: ConstantWidget.getScreenPercentSize(context, 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      font18Px(context: context),
                    ),
                    border:
                        Border.all(color: ConstantData.borderColor, width: 0.5),
                  ),
                  child: Stack(
                    children: [
                      DiscountPercent(
                        loginStore: loginStore,
                        sideMargin: sideMargin,
                        radius: radius,
                        list: list,
                        index: index,
                        isViewList: true,
                      ),
                      Row(
                        children: [
                          /// Image
                          widgetImage(context, index),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    blockSizeHorizontal(context: context) * 2,
                                vertical: blockSizeHorizontal(context: context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: blockSizeVertical(context: context) *
                                              3 +
                                          blockSizeHorizontal(context: context),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Product Name
                                        ConstantWidget.getCustomText(
                                          list[index].productName,
                                          ConstantData.mainTextColor,
                                          3,
                                          TextAlign.start,
                                          FontWeight.w600,
                                          font18Px(context: context) * 1.1,
                                        ),
                                        SizedBox(
                                          height: blockSizeHorizontal(
                                                  context: context) *
                                              2,
                                        ),

                                        /// Available quantity
                                        ConstantWidget.getCustomText(
                                          'Avl Qty : ${list[index].quantity}',
                                          Colors.black38,
                                          3,
                                          TextAlign.start,
                                          FontWeight.w600,
                                          font15Px(context: context) * 1.1,
                                        ),
                                        SizedBox(
                                          height: blockSizeVertical(
                                              context: context),
                                        ),

                                        /// Prices
                                        pricesWidget(
                                            context, index, firstHeight),
                                      ],
                                    ),
                                  ),
                                  cartWidget(index, context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Column(
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
                          'No Products to show',
                          ConstantData.mainTextColor,
                          2,
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
  }

  Observer pricesWidget(BuildContext context, int index, double firstHeight) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;

      return Offstage(
        offstage: !adminStatus,
        child: Row(
          children: [
            ConstantWidget.getLineTextView(
              'MRP : ₹${list[index].oldMrp}',
              Colors.grey,
              font15Px(context: context),
            ),
            SizedBox(
              width: blockSizeHorizontal(context: context) * 2,
            ),
            ConstantWidget.getCustomText(
              '₹${list[index].newMrp}',
              ConstantData.primaryColor,
              1,
              TextAlign.start,
              FontWeight.w600,
              font18Px(context: context) * 1.1,
            ),
          ],
        ),
      );
    });
  }

  Observer cartWidget(int index, BuildContext context) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;

      return Offstage(
        offstage: !adminStatus,
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
                Observer(builder: (_) {
                  // final updatedModel = updateCurrProduct(model);
                  final model = list[index];
                  return CartQuantityWidget(
                    model: model,
                    store: store,
                    fontSize: font18Px(context: context),
                    padding: EdgeInsets.symmetric(
                      horizontal: blockSizeHorizontal(context: context) * 3,
                      vertical: blockSizeHorizontal(context: context) * 2,
                    ),
                  );
                }),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AddProductButton(
                  store: store,
                  model: list[index],
                  width: blockSizeHorizontal(context: context) * 5,
                  height: blockSizeVertical(context: context),
                  fontSize: font18Px(context: context),
                  contextReq: context,
                ),
              ],
            );
          }
        }),
      );
    });
  }

  Container widgetImage(BuildContext context, int index) {
    return Container(
      height: ConstantWidget.getScreenPercentSize(context, 18),
      width: ConstantWidget.getWidthPercentSize(context, 30),
      decoration: BoxDecoration(
        // color: ConstantData.cellColor,
        // shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(font18Px(context: context)),
          bottomLeft: Radius.circular(font18Px(context: context)),
        ),
        // border: Border.all(color: ConstantData.clrBorder),
        // ,
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            ConstantData.productUrl + list[index].productImg,
            errorListener: () =>
                Image.asset('${ConstantData.assetsPath}no_image.png'),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
