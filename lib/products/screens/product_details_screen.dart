// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:medrpha_customer/products/screens/cart_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/products/utils/products_list.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

import '../utils/product_card.dart';

class ProductsDetailScreen extends StatefulWidget {
  const ProductsDetailScreen({
    Key? key,
    required this.model,
    // required this.store,
    // required this.modelIndex,
    // required this.list,
  }) : super(key: key);

  final ProductModel model;
  // final ProductsStore store;

  @override
  State<ProductsDetailScreen> createState() => _ProductsDetailScreenState();
}

class _ProductsDetailScreenState extends State<ProductsDetailScreen> {
  @override
  void initState() {
    // _func();
    debugPrint('----- details avl qty ---- ${widget.model.quantity}');
    super.initState();
  }

  // _func() async {
  //   await widget.store.getRecommendations(model: widget.model);
  // }

  // final int modelIndex;
  @override
  Widget build(BuildContext context) {
    double subHeight = ConstantWidget.getScreenPercentSize(context, 24.5);
    double defMargin = (subHeight / 8);
    double radius = ConstantWidget.getScreenPercentSize(context, 6);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: AppBar(
          backgroundColor: ConstantData.bgColor,
          elevation: 0,
          leading: InkWell(
            child: Icon(
              Icons.keyboard_backspace,
              color: ConstantData.mainTextColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: blockSizeHorizontal(context: context) * 4,
              ),
              child: InkWell(
                child: Stack(
                  children: [
                    /// Cart-Icon
                    Padding(
                      padding: EdgeInsets.only(
                        top: blockSizeVertical(context: context) * 3,
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: ConstantData.mainTextColor,
                        size: ConstantWidget.getWidthPercentSize(context, 5.5),
                      ),
                    ),

                    /// No of items in cart
                    Padding(
                      padding: EdgeInsets.only(
                        left: blockSizeHorizontal(context: context) * 2.5,
                        bottom: blockSizeVertical(context: context) * 3,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.all(blockSizeVertical(context: context)),
                        decoration: BoxDecoration(
                            color: ConstantData.primaryColor,
                            shape: BoxShape.circle),
                        child: Observer(builder: (_) {
                          final adminStatus = loginStore.loginModel.adminStatus;
                          final value = (store.cartModel.productList.length >
                                  10)
                              ? '9+'
                              : store.cartModel.productList.length.toString();
                          return ConstantWidget.getCustomText(
                            (adminStatus) ? value : '0',
                            Colors.white,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            font12Px(context: context) / 1.2,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: Provider.value(
                              value: profileStore,
                              child: Provider.value(
                                value: orderHistoryStore,
                                child: Provider.value(
                                  value: bottomNavigationStore,
                                  child: const CartScreen(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(
        //     bottom: blockSizeVertical(context: context) * 5,
        //   ),
        //   child: Observer(builder: (_) {
        //     return Container(
        //       padding:
        //           EdgeInsets.all(blockSizeVertical(context: context) / 1.5),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: (!store.micIsListening)
        //             ? ConstantData.primaryColor
        //             : ConstantData.color1,
        //       ),
        //       child: IconButton(
        //         onPressed: () async {
        //           debugPrint('------ listenin--- ');
        //           if (store.micEnabled && store.speechToText.isNotListening) {
        //             await store.startListening(model: widget.model);
        //             setState(() {});
        //           } else if (store.micEnabled &&
        //               !store.speechToText.isNotListening) {
        //             await store.stopListening();
        //             setState(() {});
        //           } else {
        //             await store.intializeMic();
        //           }
        //           setState(() {});
        //         },
        //         icon: Icon(
        //           (!store.micIsListening) ? Icons.mic : Icons.stop,
        //           size: blockSizeVertical(context: context) * 3,
        //           color: ConstantData.bgColor,
        //         ),
        //       ),
        //     );
        //   }),
        // ),
        body: SafeArea(
          child: Observer(builder: (_) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: blockSizeVertical(context: context) * 2,
              ),
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
                Container(
                  margin: EdgeInsets.only(bottom: defMargin),
                  color: ConstantData.bgColor,
                  child: Column(
                    children: [
                      imageWidget(context),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ConstantData.bgColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            productWidget(margin, context, loginStore),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: cartWidget(context, loginStore, store),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Observer(builder: (_) {
                  if (store.recommedLoading == StoreState.LOADING) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidget.getTextWidget(
                          'Recommendations',
                          ConstantData.mainTextColor,
                          TextAlign.start,
                          FontWeight.w600,
                          font22Px(context: context) * 1.1,
                        ),
                        SizedBox(
                          width: blockSizeHorizontal(context: context) * 3,
                        ),
                        CircularProgressIndicator(
                          color: ConstantData.primaryColor,
                        ),
                      ],
                    );
                  }

                  return Offstage(
                    offstage: (store.recommend.isEmpty),
                    child: Container(
                      width: screenWidth(context: context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: margin),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstantWidget.getTextWidget(
                                  'Recommended',
                                  ConstantData.mainTextColor,
                                  TextAlign.start,
                                  FontWeight.w600,
                                  font22Px(context: context) * 1.1,
                                ),
                                SizedBox(
                                    height:
                                        blockSizeVertical(context: context)),
                                ConstantWidget.getTextWidget(
                                  'Add them to your basket to secure more (discount %)',
                                  ConstantData.color1,
                                  TextAlign.start,
                                  FontWeight.w600,
                                  font18Px(context: context),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context) * 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Observer(builder: (_) {
                                  final category = categoriesfromValue(
                                      widget.model.category);
                                  final list = store.recommend;
                                  switch (category) {
                                    case CategoriesType.ETHICAL:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.GENERIC:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.SURGICAL:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.VETERINARY:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.AYURVEDIC:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.GENERAL:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                    case CategoriesType.VACCINE:
                                      return MoreProductsList(
                                        list: list,
                                        store: store,
                                        loginStore: loginStore,
                                        orderHistoryStore: orderHistoryStore,
                                        bottomNavigationStore:
                                            bottomNavigationStore,
                                        profileStore: profileStore,
                                      );
                                  }
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ));
  }

  Container productWidget(
      double margin, BuildContext context, LoginStore loginStore) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      padding: EdgeInsets.symmetric(vertical: (margin)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (margin),
          ),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidget.getCustomText(
                    '(${widget.model.category})',
                    ConstantData.mainTextColor,
                    2,
                    TextAlign.start,
                    FontWeight.w600,
                    font18Px(context: context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ConstantWidget.getCustomText(
                          widget.model.productName,
                          ConstantData.mainTextColor,
                          2,
                          TextAlign.start,
                          FontWeight.w600,
                          font25Px(context: context),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: Observer(builder: (_) {
                          final adminStatus = loginStore.loginModel.adminStatus;
                          // if (adminStatus) {
                          return Offstage(
                            offstage: !adminStatus,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ConstantData.mainTextColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                  font18Px(context: context),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: blockSizeVertical(context: context),
                                horizontal:
                                    blockSizeHorizontal(context: context) * 2,
                              ),
                              child: Row(
                                children: [
                                  ConstantWidget.getCustomText(
                                    'Avl Qty : ',
                                    ConstantData.mainTextColor,
                                    2,
                                    TextAlign.center,
                                    FontWeight.w600,
                                    font18Px(context: context),
                                  ),
                                  Expanded(
                                    child: ConstantWidget.getCustomText(
                                        ' ${widget.model.quantity} units',
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w600,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 1.8)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: blockSizeVertical(context: context),
                    ),
                    child: ConstantWidget.getCustomText(
                      'by ${widget.model.company}',
                      ConstantData.mainTextColor,
                      2,
                      TextAlign.start,
                      FontWeight.w500,
                      font22Px(context: context),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: blockSizeVertical(context: context) * 2,
                    ),
                    child: (widget.model.description != '')
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ConstantWidget.getSpaceTextWidget(
                                  widget.model.description,
                                  Colors.black38,
                                  TextAlign.start,
                                  FontWeight.w500,
                                  font18Px(context: context),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),

                  // SizedBox(
                  //   height: (margin),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: blockSizeHorizontal(context: context),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstantWidget.getCustomText(
                          "Expires by ${widget.model.expiryDate}",
                          ConstantData.textColor,
                          2,
                          TextAlign.start,
                          FontWeight.w500,
                          font18Px(context: context) * 1.18,
                        ),
                      ],
                    ),
                  ),

                  // ),

                  SizedBox(
                    height: ((margin)),
                  ),

                  pricesWidget(loginStore, context, margin),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Observer pricesWidget(
      LoginStore loginStore, BuildContext context, double margin) {
    return Observer(builder: (_) {
      final adminStatus = loginStore.loginModel.adminStatus;
      if (adminStatus) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: blockSizeHorizontal(context: context) * 4,
            vertical: blockSizeVertical(context: context) * 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: ConstantData.mainTextColor, width: 1),
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ConstantWidget.getLineTextView(
                    'MRP : ₹${widget.model.oldMrp}',
                    Colors.grey,
                    font18Px(context: context),
                  ),
                  SizedBox(
                    width: ((margin) / 4),
                  ),
                  ConstantWidget.getCustomText(
                    '₹${widget.model.newMrp}',
                    ConstantData.primaryColor,
                    2,
                    TextAlign.start,
                    FontWeight.w600,
                    font22Px(context: context) * 1.1,
                  ),
                ],
              ),
              ConstantWidget.getCustomText(
                widget.model.percentDiscount,
                ConstantData.color1,
                2,
                TextAlign.end,
                FontWeight.w600,
                ConstantWidget.getScreenPercentSize(context, 2),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Padding cartWidget(
      BuildContext context, LoginStore loginStore, ProductsStore store) {
    return Padding(
      padding: EdgeInsets.only(
        left: blockSizeHorizontal(context: context) * 4,
        right: blockSizeHorizontal(context: context) * 4,
        top: blockSizeVertical(context: context) * 2,
      ),
      child: Observer(builder: (_) {
        return Offstage(
          offstage: !loginStore.loginModel.adminStatus,
          child: Observer(builder: (_) {
            final index = store.cartModel.productList.indexWhere(
              (element) => element.pid == widget.model.pid,
            );

            ProductModel model = widget.model;

            switch (categoriesfromValue(model.category)) {
              case CategoriesType.ETHICAL:
                model = (store.ethicalProducts.containsKey(widget.model.pid)
                    ? store.ethicalProducts[model.pid]
                    : widget.model)!;

                break;
              case CategoriesType.GENERIC:
                model = store.genericProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
              case CategoriesType.SURGICAL:
                model = store.surgicalProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
              case CategoriesType.VETERINARY:
                model = store.veterinaryProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
              case CategoriesType.AYURVEDIC:
                model = store.ayurvedicProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
              case CategoriesType.GENERAL:
                model = store.generalProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
              case CategoriesType.VACCINE:
                model = store.vaccineProductList
                    .firstWhere((element) => element.pid == model.pid);
                break;
            }

            if (index != -1) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RemoveButton(
                    store: store,
                    model: model,
                    width: ConstantWidget.getWidthPercentSize(context, 10),
                    height: blockSizeVertical(context: context),
                    fontSize: font18Px(context: context) * 1.1,
                    isDetailPage: true,
                  ),
                  // const Spacer(),
                  Observer(builder: (_) {
                    return CartQuantityWidget(
                      // model: _updateProduct(),
                      model: model,
                      store: store,
                      fontSize: font22Px(context: context),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getWidthPercentSize(context, 20),
                        vertical: blockSizeVertical(context: context) * 1.5,
                      ),
                    );
                  }),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: AddProductButton(
                    store: store,
                    model: model,
                    isDetailScreen: true,
                    width: ConstantWidget.getWidthPercentSize(context, 10),
                    height: blockSizeVertical(context: context) * 2,
                    fontSize: font18Px(context: context) * 1.1,
                    contextReq: context,
                    // detailScreenFunc: (),
                  ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }

  Padding imageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeHorizontal(context: context) * 4,
        vertical: blockSizeVertical(context: context) * 2,
      ),
      child: Container(
        height: ConstantWidget.getScreenPercentSize(
          context,
          35,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              ConstantData.productUrl + widget.model.productImg,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(font22Px(context: context)),
          border: Border.all(
            color: ConstantData.clrBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: ConstantData.clrBorder,
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class MoreProductsList extends StatelessWidget {
  const MoreProductsList({
    Key? key,
    required this.list,
    required this.store,
    required this.loginStore,
    required this.bottomNavigationStore,
    required this.orderHistoryStore,
    required this.profileStore,
  }) : super(key: key);

  final List<ProductModel> list;
  final ProductsStore store;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;
  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 45);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 80);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);
    return Container(
      width: screenWidth(context: context),
      height: ConstantWidget.getScreenPercentSize(context, 32),
      child: ListView.builder(
        // gridDelegate:
        //     const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.only(
          left: blockSizeHorizontal(context: context) * 5,
          right: blockSizeHorizontal(context: context) * 3,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                right: blockSizeHorizontal(context: context) * 3),
            child: ProductsCard(
              store: store,
              loginStore: loginStore,
              list: list,
              width: width,
              firstHeight: firstHeight,
              radius: radius,
              sideMargin: sideMargin,
              remainHeight: remainHeight,
              index: index,
              bottomNavigationStore: bottomNavigationStore,
              profileStore: profileStore,
              orderHistoryStore: orderHistoryStore,
              // isMoreProducts: true,
            ),
          );
        },
      ),
    );
  }
}

class CustomQuantity extends StatelessWidget {
  const CustomQuantity({
    Key? key,
    required this.model,
    required this.store,
    // required this.index,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  // final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(blockSizeHorizontal(context: context) * 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getCustomText(
                    'Input Quantity : ',
                    ConstantData.mainTextColor,
                    2,
                    TextAlign.center,
                    FontWeight.w600,
                    font22Px(context: context)),
                SizedBox(
                  height: blockSizeVertical(context: context) * 3,
                ),
                Observer(builder: (_) {
                  return SizedBox(
                    width: blockSizeVertical(context: context) * 15,
                    height: blockSizeVertical(context: context) * 5,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) async {
                        // final index = store.allProducts
                        //     .indexWhere((element) => element == model);
                        await store.updateCartQunatity(
                          model: model,
                          value: value,
                          context: context,
                        );

                        Navigator.of(context).pop();
                      },
                      onChanged: (value) {
                        model.copyWith(cartQuantity: int.parse(value));
                      },
                      initialValue: '${model.cartQuantity}',
                      decoration: InputDecoration(
                        hintText: '${model.cartQuantity}',
                        hintStyle: TextStyle(
                            fontSize: font18Px(context: context),
                            color: ConstantData.mainTextColor),
                        labelText: 'Qunatity',
                        labelStyle: TextStyle(
                            fontSize: font18Px(context: context),
                            color: ConstantData.mainTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ConstantData.mainTextColor, width: 1.5),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
