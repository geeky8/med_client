import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class ProductsDetailScreen extends StatelessWidget {
  const ProductsDetailScreen({
    Key? key,
    required this.model,
    required this.modelIndex,
  }) : super(key: key);

  final ProductModel model;
  final int modelIndex;

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 45);
    double secHeight = ConstantWidget.getScreenPercentSize(context, 39);
    double subHeight = ConstantWidget.getScreenPercentSize(context, 24.5);
    double defMargin = (subHeight / 8);

    double radius = ConstantWidget.getScreenPercentSize(context, 6);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();

    return Scaffold(
        backgroundColor: ConstantData.bgColor,
        bottomNavigationBar: Observer(builder: (_) {
          final adminStatus = loginStore.loginModel.adminStatus;
          if (adminStatus) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: blockSizeHorizontal(context: context) * 2,
                      right: blockSizeHorizontal(context: context) * 3,
                    ),
                    child: InkWell(
                        onTap: () async {
                          final _index = store.cartModel.productList.indexWhere(
                              (element) => element.pid == model.pid);
                          SnackBar _snackBar;
                          if (_index == -1) {
                            await store.addToCart(model: model);
                            _snackBar = ConstantWidget.customSnackBar(
                                text: 'Added To Cart', context: context);
                          } else {
                            _snackBar = ConstantWidget.customSnackBar(
                                text: 'Item Already in Cart', context: context);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  blockSizeVertical(context: context) * 2.3),
                          decoration: BoxDecoration(
                            color: ConstantData.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConstantWidget.getCustomText(
                            'Add',
                            ConstantData.bgColor,
                            1,
                            TextAlign.center,
                            FontWeight.w500,
                            font18Px(context: context) * 1.1,
                          ),
                        )),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        }),
        body: Observer(builder: (_) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: defMargin),
                color: ConstantData.bgColor,
                child: Stack(
                  children: [
                    SizedBox(
                      height: height,
                      // padding: EdgeInsets.only(: margin),

                      // decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: AssetImage(
                      //             ConstantData.assetsPath + sModel.image),
                      //         fit: BoxFit.cover)),
                      child: Stack(
                        children: [
                          // FutureBuilder<Color>(
                          //     future: _updatePaletteGenerator(sliderList[position]),
                          //     //This function return color from Sqlite DB Asynchronously
                          //     builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                          //       Color color;
                          //       if (snapshot.hasData) {
                          //         color = snapshot.data;
                          //       } else {
                          //         color = ConstantData.cellColor;
                          //       }
                          //
                          //       return   Container(
                          //         height:double.infinity,
                          //         width: double.infinity,
                          //         color: color,
                          //       );
                          //     }),

                          Container(
                              height: ConstantWidget.getScreenPercentSize(
                                  context, 40),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        ConstantData.productUrl +
                                            model.productImg,
                                      ),
                                      fit: BoxFit.cover))
                              // child: PageView.builder(
                              //   controller: controller,
                              //   onPageChanged: _onPageViewChange,
                              //   itemBuilder: (context, position) {
                              //   ;})  return Container(
                              //         decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //                 image: AssetImage(
                              //                     ConstantData.assetsPath +
                              //                         sliderList[position]),
                              //                 fit: BoxFit.cover)));
                              //   },
                              //   // itemCount: sliderList.length,
                              // ),
                              ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: (defMargin / 2),
                                vertical: (margin * 2)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: ConstantWidget.getWidthPercentSize(
                                      context, 2),
                                ),
                                Material(
                                  child: InkWell(
                                    child: Icon(
                                      Icons.keyboard_backspace,
                                      color: ConstantData.mainTextColor,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  color: Colors.transparent,
                                ),
                                // const Spacer(),
                                // InkWell(
                                //   child: Container(
                                //     height: closeSize,
                                //     width: closeSize,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.rectangle,
                                //       color: Colors.redAccent,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(radius),
                                //       ),
                                //     ),
                                //     child: Center(
                                //       child: Icon(
                                //         (sModel.isFav == 0)
                                //             ? Icons.favorite_border
                                //             : Icons.favorite,
                                //         color: Colors.white,
                                //         size: ConstantWidget.getPercentSize(
                                //             closeSize, 50),
                                //       ),
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     setState(() {
                                //       if (sModel.isFav == 1) {
                                //         sModel.isFav = 0;
                                //       } else {
                                //         sModel.isFav = 1;
                                //       }
                                //     });
                                //   },
                                // ),
                                SizedBox(
                                  width: ConstantWidget.getWidthPercentSize(
                                      context, 2),
                                ),
                              ],
                            ),
                          ),

                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Container(
                          //     margin: EdgeInsets.all(defMargin),
                          //     padding: EdgeInsets.only(bottom: defMargin * 1.5),
                          //     child: SmoothPageIndicator(
                          //       count: sliderList.length,
                          //       effect: WormEffect(
                          //           activeDotColor: ConstantData.cellColor,
                          //           dotColor: ConstantData.cellColor
                          //               .withOpacity(0.5)),
                          //       controller: controller, // your preferred effect
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: secHeight),
                      decoration: BoxDecoration(
                          color: ConstantData.bgColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              topRight: Radius.circular(radius))),
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
                                                model.productName,
                                                ConstantData.mainTextColor,
                                                2,
                                                TextAlign.start,
                                                FontWeight.bold,
                                                font25Px(context: context)),
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
                                                        FontWeight.bold,
                                                        font18Px(
                                                            context: context),
                                                      ),
                                                      ConstantWidget.getCustomText(
                                                          model.quantity +
                                                              ' units',
                                                          ConstantData
                                                              .mainTextColor,
                                                          2,
                                                          TextAlign.start,
                                                          FontWeight.w500,
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
                                                      context, 2),
                                            ),
                                          ],
                                        ),

                                        ConstantWidget.getSpaceTextWidget(
                                          model.description,
                                          ConstantData.textColor,
                                          TextAlign.start,
                                          FontWeight.w400,
                                          font18Px(context: context),
                                        ),

                                        SizedBox(
                                          height: (margin),
                                        ),
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
                                                font18Px(context: context)),
                                            SizedBox(
                                              width: blockSizeHorizontal(
                                                      context: context) *
                                                  4,
                                            ),
                                            ConstantWidget.getCustomText(
                                                model.expiryDate,
                                                ConstantData.textColor,
                                                2,
                                                TextAlign.start,
                                                FontWeight.w500,
                                                font18Px(context: context)),
                                          ],
                                        ),

                                        // ),

                                        SizedBox(
                                          height: ((margin)),
                                        ),

                                        Observer(builder: (_) {
                                          final adminStatus =
                                              loginStore.loginModel.adminStatus;
                                          if (adminStatus) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ConstantWidget.getCustomText(
                                                    '₹' + model.newMrp,
                                                    ConstantData.mainTextColor,
                                                    2,
                                                    TextAlign.start,
                                                    FontWeight.bold,
                                                    font22Px(context: context)),
                                                SizedBox(
                                                  width: ((margin) / 4),
                                                ),
                                                // ConstantWidget.getCustomText(
                                                //     (sModel.offPrice != null)
                                                //         ? sModel.offPrice
                                                //         : "",
                                                //     Colors.grey,
                                                //     2,
                                                //     TextAlign.start,
                                                //     FontWeight.w500,
                                                //     ConstantWidget
                                                //         .getScreenPercentSize(
                                                //             context, 2)),

                                                ConstantWidget.getLineTextView(
                                                    '₹' + model.oldMrp,
                                                    Colors.grey,
                                                    font18Px(context: context)),

                                                Expanded(
                                                    child: ConstantWidget
                                                        .getCustomText(
                                                            model
                                                                .percentDiscount,
                                                            ConstantData
                                                                .accentColor,
                                                            2,
                                                            TextAlign.end,
                                                            FontWeight.bold,
                                                            ConstantWidget
                                                                .getScreenPercentSize(
                                                                    context,
                                                                    2)))
                                              ],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        })
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Padding(
                          //         padding: EdgeInsets.only(
                          //             left: margin, bottom: (margin)),
                          //         child: ConstantWidget.getTextWidget(
                          //             S.of(context).otherProduct,
                          //             ConstantData.mainTextColor,
                          //             TextAlign.start,
                          //             FontWeight.w800,
                          //             ConstantWidget.getScreenPercentSize(
                          //                 context, 2.5)),
                          //       ),
                          //       // trendingList(),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: blockSizeVertical(context: context) * 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: ConstantWidget.getScreenPercentSize(
                                      context, 1),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: margin),
                                  child: ConstantWidget.getTextWidget(
                                      'More Prodcuts',
                                      ConstantData.mainTextColor,
                                      TextAlign.start,
                                      FontWeight.w800,
                                      ConstantWidget.getScreenPercentSize(
                                          context, 2.5)),
                                ),
                                SizedBox(
                                  height: (height / 15),
                                ),
                                Observer(builder: (_) {
                                  final category = model.category;

                                  switch (category) {
                                    case 'Ethical':
                                      final list = store.ethicalProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );
                                    case 'Generic':
                                      final list = store.genericProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );
                                    case 'Surgical':
                                      final list = store.surgicalProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );

                                    case 'Veterinary':
                                      final list = store.veterinaryProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );

                                    case 'Ayurvedic':
                                      final list = store.ethicalProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );

                                    case 'General':
                                      final list = store.ethicalProductList;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
                                        store: store,
                                        loginStore: loginStore,
                                      );

                                    default:
                                      final list = store.allProducts;
                                      // print(model.category);
                                      list.shuffle();
                                      return ProductsList(
                                        list: list,
                                        axis: Axis.horizontal,
                                        itemCount: 7,
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
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final IconData icon;
  // final Function function;

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 2.5);

    return Container(
      height: height,
      // margin: EdgeInsets.symmetric(horizontal: ConstantWidget.getPercentSize(height, 30)),
      width: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 1.5)),
      child: Icon(
        icon,
        size: blockSizeVertical(context: context) * 2,
        color: Colors.grey,
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
                    FontWeight.bold,
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
                        await store.plusMinusCartManual(
                            model: model, value: value);

                        Navigator.of(context).pop();
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
                                  color: ConstantData.mainTextColor,
                                  width: 1.5))),
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
