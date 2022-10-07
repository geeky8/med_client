// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/products/utils/products_list.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class ProductsDetailScreen extends StatefulWidget {
  const ProductsDetailScreen({
    Key? key,
    required this.model,
    // required this.modelIndex,
    // required this.list,
  }) : super(key: key);

  final ProductModel model;

  @override
  State<ProductsDetailScreen> createState() => _ProductsDetailScreenState();
}

class _ProductsDetailScreenState extends State<ProductsDetailScreen> {
  // final int modelIndex;
  @override
  Widget build(BuildContext context) {
    double subHeight = ConstantWidget.getScreenPercentSize(context, 24.5);
    double defMargin = (subHeight / 8);
    double radius = ConstantWidget.getScreenPercentSize(context, 6);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();

    return Scaffold(
        backgroundColor: ConstantData.bgColor,
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
                      Stack(
                        children: [
                          Container(
                            height: ConstantWidget.getScreenPercentSize(
                              context,
                              35,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  ConstantData.productUrl +
                                      widget.model.productImg,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: (defMargin / 2),
                              vertical: (margin),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: ConstantWidget.getWidthPercentSize(
                                    context,
                                    2,
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.keyboard_backspace,
                                      color: ConstantData.bgColor,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: ConstantWidget.getWidthPercentSize(
                                    context,
                                    2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        // margin: EdgeInsets.only(
                        //   top: blockSizeVertical(context: context) * 2,
                        // ),
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
                            Container(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Expanded(
                                          //   child:
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ConstantWidget.getCustomText(
                                                widget.model.productName,
                                                ConstantData.mainTextColor,
                                                2,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                font22Px(context: context) *
                                                    1.2,
                                              ),
                                              const Spacer(),
                                              Observer(builder: (_) {
                                                final adminStatus = loginStore
                                                    .loginModel.adminStatus;
                                                // if (adminStatus) {
                                                return Offstage(
                                                  offstage: !adminStatus,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: blockSizeVertical(
                                                            context: context)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ConstantWidget
                                                            .getCustomText(
                                                          'Avl.Qty:',
                                                          ConstantData
                                                              .mainTextColor,
                                                          2,
                                                          TextAlign.center,
                                                          FontWeight.w600,
                                                          font18Px(
                                                              context: context),
                                                        ),
                                                        ConstantWidget.getCustomText(
                                                            '${widget.model.quantity} units',
                                                            ConstantData
                                                                .mainTextColor,
                                                            2,
                                                            TextAlign.start,
                                                            FontWeight.w600,
                                                            ConstantWidget
                                                                .getScreenPercentSize(
                                                                    context,
                                                                    1.8)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                                // } else {
                                                //   return const SizedBox();
                                                // }
                                              }),
                                              SizedBox(
                                                width: ConstantWidget
                                                    .getScreenPercentSize(
                                                  context,
                                                  2,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: blockSizeVertical(
                                                      context: context) *
                                                  2,
                                            ),
                                            child: ConstantWidget
                                                .getSpaceTextWidget(
                                              widget.model.description,
                                              ConstantData.textColor,
                                              TextAlign.start,
                                              FontWeight.w400,
                                              font18Px(context: context),
                                            ),
                                          ),

                                          // SizedBox(
                                          //   height: (margin),
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ConstantWidget.getCustomText(
                                                "Expiry Date :",
                                                ConstantData.textColor,
                                                2,
                                                TextAlign.start,
                                                FontWeight.w500,
                                                font18Px(context: context),
                                              ),
                                              SizedBox(
                                                width: blockSizeHorizontal(
                                                        context: context) *
                                                    4,
                                              ),
                                              ConstantWidget.getCustomText(
                                                  widget.model.expiryDate,
                                                  ConstantData.textColor,
                                                  2,
                                                  TextAlign.start,
                                                  FontWeight.w600,
                                                  font18Px(context: context)),
                                            ],
                                          ),

                                          // ),

                                          SizedBox(
                                            height: ((margin)),
                                          ),

                                          Observer(builder: (_) {
                                            final adminStatus = loginStore
                                                .loginModel.adminStatus;
                                            if (adminStatus) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ConstantWidget.getCustomText(
                                                      '₹${widget.model.newMrp}',
                                                      ConstantData
                                                          .mainTextColor,
                                                      2,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      font22Px(
                                                          context: context)),
                                                  SizedBox(
                                                    width: ((margin) / 4),
                                                  ),
                                                  ConstantWidget.getLineTextView(
                                                      '₹${widget.model.oldMrp}',
                                                      Colors.grey,
                                                      font18Px(
                                                          context: context)),
                                                  Expanded(
                                                    child: ConstantWidget
                                                        .getCustomText(
                                                      widget.model
                                                          .percentDiscount,
                                                      ConstantData.accentColor,
                                                      2,
                                                      TextAlign.end,
                                                      FontWeight.w600,
                                                      ConstantWidget
                                                          .getScreenPercentSize(
                                                              context, 2),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    blockSizeHorizontal(context: context) * 4,
                                vertical:
                                    blockSizeVertical(context: context) * 2,
                              ),
                              child: Observer(builder: (_) {
                                final adminStatus =
                                    loginStore.loginModel.adminStatus;

                                return Offstage(
                                  offstage: !adminStatus,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: blockSizeHorizontal(
                                            context: context),
                                        bottom:
                                            blockSizeVertical(context: context),
                                      ),
                                      child: Observer(builder: (_) {
                                        final index = store
                                            .cartModel.productList
                                            .indexWhere(
                                          (element) =>
                                              element.pid == widget.model.pid,
                                        );
                                        if (index != -1) {
                                          return Row(
                                            children: [
                                              PlusMinusWidget(
                                                model: widget.model,
                                                store: store,
                                                iconSize: ConstantWidget
                                                    .getWidthPercentSize(
                                                  context,
                                                  3,
                                                ),
                                                fontSize:
                                                    font22Px(context: context),
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                child: RemoveButton(
                                                  store: store,
                                                  model: widget.model,
                                                  width: ConstantWidget
                                                      .getWidthPercentSize(
                                                          context, 10),
                                                  height: blockSizeVertical(
                                                      context: context),
                                                  fontSize: font18Px(
                                                          context: context) *
                                                      1.1,
                                                  isDetailPage: true,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return Row(
                                          children: [
                                            AddProductButton(
                                              store: store,
                                              model: widget.model,
                                              width: ConstantWidget
                                                  .getWidthPercentSize(
                                                      context, 10),
                                              height: blockSizeVertical(
                                                      context: context) *
                                                  2,
                                              fontSize:
                                                  font18Px(context: context) *
                                                      1.1,
                                              contextReq: context,
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                Container(
                  width: screenWidth(context: context),
                  // height: ConstantWidget.getScreenPercentSize(
                  //   context,
                  //   50,
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: margin),
                        child: ConstantWidget.getTextWidget(
                          'More Prodcuts',
                          ConstantData.mainTextColor,
                          TextAlign.start,
                          FontWeight.w600,
                          font22Px(context: context),
                        ),
                      ),
                      SizedBox(
                        height: blockSizeVertical(context: context) * 2,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Observer(builder: (_) {
                              final category =
                                  categoriesfromValue(widget.model.category);

                              switch (category) {
                                case CategoriesType.ETHICAL:
                                  final list = store.ethicalProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                                case CategoriesType.GENERIC:
                                  final list = store.genericProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                                case CategoriesType.SURGICAL:
                                  final list = store.surgicalProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                                case CategoriesType.VETERINARY:
                                  final list = store.veterinaryProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                                case CategoriesType.AYURVEDIC:
                                  final list = store.ayurvedicProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                                case CategoriesType.GENERAL:
                                  final list = store.generalProductList;

                                  return MoreProductsList(
                                    list: list,
                                    store: store,
                                    loginStore: loginStore,
                                  );
                              }

                              // return ListView.builder(
                              //   itemCount: 7,
                              //   scrollDirection: Axis.horizontal,
                              //   padding: EdgeInsets.zero,
                              //   shrinkWrap: true,
                              //   physics: const BouncingScrollPhysics(),
                              //   itemBuilder: (context, index) {
                              //     return ProductsList(list: list, axis: axis, itemCount: itemCount, store: store);
                              //   },
                              // );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }
}

class MoreProductsList extends StatelessWidget {
  const MoreProductsList({
    Key? key,
    required this.list,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  final List<ProductModel> list;
  final ProductsStore store;
  final LoginStore loginStore;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 50);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 48);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);
    return Container(
      width: screenWidth(context: context),
      height: ConstantWidget.getScreenPercentSize(context, 24),
      child: ListView.builder(
        // gridDelegate:
        //     const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.only(
          left: blockSizeHorizontal(context: context) * 5,
          right: blockSizeHorizontal(context: context) * 3,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 7,
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
