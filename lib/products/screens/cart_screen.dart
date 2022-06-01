import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
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
    double radius = ConstantWidget.getScreenPercentSize(context, 4);
    double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double padding = ConstantWidget.getScreenPercentSize(context, 1.5);
    double bottomHeight = ConstantWidget.getScreenPercentSize(context, 6);

    double subRadius = ConstantWidget.getPercentSize(bottomHeight, 10);

    final store = context.read<ProductsStore>();

    return WillPopScope(
      child: Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: AppBar(
          backgroundColor: ConstantData.bgColor,
          elevation: 0,
          centerTitle: true,
          title: ConstantWidget.getAppBarText('Cart', context),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: ConstantWidget.getAppBarIcon(),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: Container(
          child: Observer(builder: (_) {
            final show = store.cartModel.productList.length;
            if (show == 0) {
              return Center(
                child: ConstantWidget.errorWidget(
                  context: context,
                  height: 20,
                  width: 15,
                  fontSize: font18Px(context: context),
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: leftMargin,
                          right: leftMargin,
                          bottom: MediaQuery.of(context).size.width * 0.01),
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
                    flex: 1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: leftMargin),
                    decoration: BoxDecoration(
                      color: ConstantData.viewColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          topRight: Radius.circular(radius)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: leftMargin,
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: defMargin),
                            height: ConstantWidget.getScreenPercentSize(
                                context, 0.5),
                            width:
                                ConstantWidget.getWidthPercentSize(context, 30),
                            color: Colors.grey,
                          ),
                        ),
                        // getRoWCell('Sub-Total', ".10"),
                        Padding(
                          padding:
                              EdgeInsets.only(top: padding, bottom: padding),
                          child: getRoWCell('Total Items',
                              store.cartModel.noOfProducts.toString(), context),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: padding),
                        //   child: getRoWCell('Tax', ".50", context),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ConstantWidget.getCustomText(
                                  'Total',
                                  ConstantData.mainTextColor,
                                  1,
                                  TextAlign.start,
                                  FontWeight.bold,
                                  font22Px(context: context)),
                              flex: 1,
                            ),
                            Expanded(
                              child: ConstantWidget.getCustomText(
                                  '₹' +
                                      store.cartModel.totalSalePrice.toString(),
                                  ConstantData.mainTextColor,
                                  1,
                                  TextAlign.end,
                                  FontWeight.w800,
                                  font22Px(context: context)),
                              flex: 1,
                            )
                          ],
                        ),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 2,
                        ),
                        InkWell(
                          child: Container(
                            height: bottomHeight,
                            margin: EdgeInsets.symmetric(
                                vertical: ConstantWidget.getPercentSize(
                                    bottomHeight, 25)),
                            decoration: BoxDecoration(
                              color: ConstantData.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(subRadius)),
                            ),
                            child: Center(
                              child: ConstantWidget.getTextWidget(
                                  'Continue',
                                  Colors.white,
                                  TextAlign.start,
                                  FontWeight.bold,
                                  font18Px(context: context)),
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => CheckOutPage(),
                            //     ));
                          },
                        )
                      ],
                    ),
                  )
                ],
              );
            }
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
          child: ConstantWidget.getCustomText(s, ConstantData.textColor, 1,
              TextAlign.start, FontWeight.w600, font18Px(context: context)),
          flex: 1,
        ),
        Expanded(
          child: ConstantWidget.getCustomText(s1, ConstantData.textColor, 1,
              TextAlign.end, FontWeight.w600, font18Px(context: context)),
          flex: 1,
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
    double imageSize = ConstantWidget.getPercentSize(height, 80);
    double margin = ConstantWidget.getScreenPercentSize(context, 1.5);
    double radius = ConstantWidget.getScreenPercentSize(context, 1.5);

    // setThemePosition();
    return Observer(builder: (_) {
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
                  color: ConstantData.bgColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        ConstantData.productUrl + model.productImg),
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
                        ConstantWidget.getCustomText(
                            (model.productName.length > 12)
                                ? model.productName.substring(0, 12) + '...'
                                : model.productName,
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.start,
                            FontWeight.w500,
                            font18Px(context: context)),
                        SizedBox(
                          width: ConstantWidget.getPercentSize(height, 7),
                        ),
                        ConstantWidget.getCustomText(
                            model.company,
                            Colors.grey,
                            1,
                            TextAlign.start,
                            FontWeight.w500,
                            font15Px(context: context)),
                        SizedBox(
                          height:
                              ConstantWidget.getWidthPercentSize(context, 1.2),
                        ),

                        ConstantWidget.getLineTextView('₹' + model.oldMrp,
                            Colors.grey, font15Px(context: context)),

                        SizedBox(
                          height:
                              ConstantWidget.getWidthPercentSize(context, 1.2),
                        ),

                        ConstantWidget.getCustomText(
                            '₹' + model.newMrp,
                            ConstantData.accentColor,
                            1,
                            TextAlign.start,
                            FontWeight.w800,
                            font18Px(context: context)),

                        //
                        // ConstantWidget.getCustomText(
                        //     subCategoryModel.offPrice,
                        //     Colors.grey,
                        //     1,
                        //     TextAlign.start,
                        //     FontWeight.w500,
                        //     ConstantWidget.getPercentSize(height, 10)),

                        // new Spacer(),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     ConstantWidget.getCustomText(
                        //         subCategoryModel.price,
                        //         ConstantData.accentColor,
                        //         1,
                        //         TextAlign.start,
                        //         FontWeight.w800,
                        //         ConstantWidget.getPercentSize(height, 15)),
                        //     SizedBox(
                        //       width: ConstantWidget.getWidthPercentSize(
                        //           context, 1.2),
                        //     ),
                        //     ConstantWidget.getCustomText(
                        //         subCategoryModel.offPrice,
                        //         Colors.grey,
                        //         1,
                        //         TextAlign.start,
                        //         FontWeight.w500,
                        //         ConstantWidget.getPercentSize(height, 10)),
                        //   ],
                        // ),
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
                                  right: blockSizeHorizontal(context: context) *
                                      2),
                              child: ConstantWidget.getCustomText(
                                '₹' + model.subTotal,
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.bold,
                                font18Px(context: context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     ConstantWidget.getCustomText(
                          //       'X',
                          //       Colors.black38,
                          //       1,
                          //       TextAlign.center,
                          //       FontWeight.bold,
                          //       font18Px(context: context),
                          //     ),
                          //     ConstantWidget.getCustomText(
                          // (model.cartQuantity == '')
                          //     ? '0'
                          //     : model.cartQuantity,
                          //       Colors.black38,
                          //       1,
                          //       TextAlign.center,
                          //       FontWeight.bold,
                          //       font18Px(context: context),
                          //     ),
                          //   ],
                          // ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      blockSizeHorizontal(context: context) * 2,
                                  bottom:
                                      blockSizeVertical(context: context) * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ConstantWidget.getButtonWidget(
                                  //     context, 'Remove', ConstantData.primaryColor),
                                  InkWell(
                                    onTap: () async {
                                      await store.removeFromCart(model: model);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: blockSizeVertical(
                                              context: context),
                                          horizontal: blockSizeHorizontal(
                                                  context: context) *
                                              3),
                                      decoration: BoxDecoration(
                                        color: ConstantData.primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ConstantWidget.getCustomText(
                                        'Remove',
                                        ConstantData.bgColor,
                                        2,
                                        TextAlign.center,
                                        FontWeight.bold,
                                        font15Px(context: context),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ConstantWidget.getScreenPercentSize(
                                        context, 3),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Observer(builder: (_) {
                                        return InkWell(
                                          onTap: () async {
                                            // int _currQty = model.cartQuantity - 1;
                                            // // print(model.cartQuantity + '1');
                                            // final currModel = model.copyWith(
                                            //     cartQuantity: _currQty);
                                            // // print(currModel.cartQuantity + '2');
                                            // await store.plusMinusToCart(
                                            //   model: currModel,
                                            // );
                                            await store.minusToCart(
                                                model: model);
                                          },
                                          child: const PlusMinusButton(
                                            icon: CupertinoIcons.minus,
                                          ),
                                        );
                                      }),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(12)),
                                              ),
                                              builder: (_) => CustomQuantity(
                                                    model: model,
                                                    store: store,
                                                    // index: modelIndex,
                                                  ));
                                        },
                                        child: Observer(builder: (_) {
                                          // final index = store.ethicalProductList
                                          //     .indexWhere((element) =>
                                          //         element.pid == model.pid);
                                          final category = model.category;
                                          ProductModel currModel;
                                          switch (category) {
                                            case 'Ethical':
                                              final _index = store
                                                  .ethicalProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel = store
                                                  .ethicalProductList[_index];
                                              break;
                                            case 'Generic':
                                              final _index = store
                                                  .genericProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel = store
                                                  .genericProductList[_index];
                                              break;
                                            case 'Surgical':
                                              final _index = store
                                                  .surgicalProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel = store
                                                  .surgicalProductList[_index];
                                              break;
                                            case 'Veterinary':
                                              final _index = store
                                                  .veterinaryProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel =
                                                  store.veterinaryProductList[
                                                      _index];
                                              break;

                                            case 'Ayurvedic':
                                              final _index = store
                                                  .ayurvedicProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel = store
                                                  .ayurvedicProductList[_index];
                                              break;

                                            case 'General':
                                              final _index = store
                                                  .generalProductList
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel = store
                                                  .generalProductList[_index];
                                              break;

                                            default:
                                              final _index = store.allProducts
                                                  .indexWhere((element) =>
                                                      element.pid == model.pid);
                                              currModel =
                                                  store.allProducts[_index];
                                              break;
                                          }

                                          currModel.cartQuantity;

                                          // print(currModel.cartQuantity);
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: blockSizeHorizontal(
                                                        context: context) *
                                                    3),
                                            child: ConstantWidget.getCustomText(
                                                '${currModel.cartQuantity}',
                                                ConstantData.mainTextColor,
                                                2,
                                                TextAlign.center,
                                                FontWeight.w500,
                                                font18Px(context: context)),
                                          );
                                        }),
                                      ),
                                      // SizedBox(
                                      //     width: blockSizeHorizontal(
                                      //             context: context) *
                                      //         10,
                                      //     child: const TextField()),

                                      InkWell(
                                        onTap: () async {
                                          // int _qty = model.cartQuantity + 1;
                                          // final _currModel =
                                          //     model.copyWith(cartQuantity: _qty);
                                          await store.plusToCart(model: model);
                                        },
                                        child: const PlusMinusButton(
                                          icon: CupertinoIcons.plus,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // getCartButton(Icons.add, () {
                                  //   setState(() {
                                  //     subCategoryModel.quantity++;
                                  //   });
                                  // }),
                                  SizedBox(
                                    width: ConstantWidget.getWidthPercentSize(
                                        context, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: ConstantWidget.getWidthPercentSize(context, 2),
                    // ),

                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       ConstantWidget.getCustomText(
                    //         'Sub-Total:',
                    //         ConstantData.mainTextColor,
                    //         1,
                    //         TextAlign.center,
                    //         FontWeight.w500,
                    //         font18Px(context: context),
                    //       ),
                    //       ConstantWidget.getCustomText(
                    //         '₹' + model.subTotal,
                    //         ConstantData.mainTextColor,
                    //         1,
                    //         TextAlign.center,
                    //         FontWeight.w600,
                    //         font18Px(context: context),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
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
