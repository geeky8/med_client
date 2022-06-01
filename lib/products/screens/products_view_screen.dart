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

class ProductsViewScreen extends StatelessWidget {
  const ProductsViewScreen({
    Key? key,
    required this.list,
    required this.axis,
    required this.itemCount,
    required this.appBarTitle,
  }) : super(key: key);

  final List<ProductModel> list;
  final Axis axis;
  final int itemCount;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 60);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 60);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);

    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.bgColor,
            title: ConstantWidget.getAppBarText(appBarTitle, context),
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
          body: Observer(builder: (_) {
            final show = list.length;
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
              return Container(
                  // height: height,
                  margin: EdgeInsets.only(bottom: margin),
                  child: ListView.builder(
                      padding: EdgeInsets.only(right: sideMargin),
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   // crossAxisSpacing: 2,
                      //   mainAxisSpacing: 3,
                      // ),
                      // shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: itemCount,
                      scrollDirection: axis,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  blockSizeVertical(context: context) * 1.5),
                          child: InkWell(
                            child: SizedBox(
                              width: width,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: sideMargin,
                                ),
                                decoration: BoxDecoration(
                                    // color: ConstantData.bgColor,
                                    borderRadius: BorderRadius.circular(radius),
                                    border: Border.all(
                                        color: ConstantData.borderColor,
                                        width:
                                            ConstantWidget.getWidthPercentSize(
                                                context, 0.08)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                      )
                                    ]),
                                child: Stack(
                                  children: [
                                    // Align(alignment: Alignment.topRight,
                                    // child:
                                    // Container(
                                    //   padding: EdgeInsets.all(sideMargin/4),
                                    //
                                    //   decoration: BoxDecoration(
                                    //     color: ConstantData.accentColor,
                                    //     borderRadius: BorderRadius.only(topRight: Radius.circular(radius)),
                                    //
                                    //
                                    //
                                    //   ),
                                    //   child: ConstantWidget.getCustomText(
                                    //       (subCategoryModelList[index].offer !=
                                    //           null)
                                    //           ? subCategoryModelList[index].offer
                                    //           : "",
                                    //       Colors.white,
                                    //       // ConstantData.accentColor,
                                    //       1,
                                    //       TextAlign.start,
                                    //       FontWeight.w400,
                                    //       ConstantWidget.getPercentSize(
                                    //           firstHeight, 12)),
                                    //
                                    // ),),
                                    //

                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: EdgeInsets.all(sideMargin / 4),
                                        decoration: BoxDecoration(
                                          color: ConstantData.accentColor,
                                          borderRadius: BorderRadius.only(
                                              topRight:
                                                  Radius.circular(radius)),
                                        ),
                                        child: ConstantWidget.getCustomText(
                                            list[index].percentDiscount,
                                            Colors.white,
                                            // ConstantData.accentColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w400,
                                            ConstantWidget.getPercentSize(
                                                firstHeight, 12)),
                                      ),
                                    ),
                                    // ),),visible:   (subCategoryModelList[index].offer != null || subCategoryModelList[index].offer.isNotEmpty),),

                                    SizedBox(
                                      height: firstHeight,
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: firstHeight,
                                            width: firstHeight,
                                            decoration: BoxDecoration(
                                                color: ConstantData.cellColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(radius),
                                                ),
                                                // ,
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      ConstantData.productUrl +
                                                          list[index]
                                                              .productImg,
                                                    ),
                                                    fit: BoxFit.fill)),
                                          ),
                                          SizedBox(
                                            width: blockSizeHorizontal(
                                                    context: context) *
                                                5,
                                          ),

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: ConstantWidget
                                                        .getPercentSize(
                                                            remainHeight, 8),
                                                  ),
                                                  ConstantWidget.getCustomText(
                                                      list[index].productName,
                                                      ConstantData
                                                          .mainTextColor,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      ConstantWidget
                                                          .getPercentSize(
                                                              remainHeight,
                                                              22)),
                                                  // SizedBox(
                                                  //   height:
                                                  //       ConstantWidget.getPercentSize(
                                                  //           remainHeight, 8),
                                                  // ),
                                                  ConstantWidget.getCustomText(
                                                      list[index]
                                                          .prodSaleTypeDetails,
                                                      Colors.grey,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      ConstantWidget
                                                          .getPercentSize(
                                                              remainHeight,
                                                              14)),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  final _index = store
                                                      .cartModel.productList
                                                      .indexWhere((element) =>
                                                          element.pid ==
                                                          list[index].pid);
                                                  SnackBar _snackBar;
                                                  if (_index == -1) {
                                                    await store.addToCart(
                                                        model: list[index]);
                                                    _snackBar = ConstantWidget
                                                        .customSnackBar(
                                                            text:
                                                                'Added To Cart',
                                                            context: context);
                                                  } else {
                                                    _snackBar = ConstantWidget
                                                        .customSnackBar(
                                                            text:
                                                                'Item Already in Cart',
                                                            context: context);
                                                  }

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(_snackBar);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: blockSizeVertical(
                                                        context: context),
                                                    horizontal:
                                                        blockSizeHorizontal(
                                                                context:
                                                                    context) *
                                                            8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: font18Px(
                                                          context: context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // const Spacer(),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: blockSizeHorizontal(
                                                      context: context)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      ConstantWidget
                                                          .getLineTextView(
                                                              '₹' +
                                                                  list[index]
                                                                      .oldMrp,
                                                              Colors.grey,
                                                              ConstantWidget
                                                                  .getPercentSize(
                                                                      firstHeight,
                                                                      12)),

                                                      // ConstantWidget.getCustomText(
                                                      //     (subCategoryModelList[index]
                                                      //                 .offPrice !=
                                                      //             null)
                                                      //         ? subCategoryModelList[
                                                      //                 index]
                                                      //             .offPrice
                                                      //         : "",
                                                      //     Colors.grey,
                                                      //     1,
                                                      //     TextAlign.start,
                                                      //     FontWeight.w600,
                                                      //     ConstantWidget.getPercentSize(
                                                      //         firstHeight, 12)),
                                                      SizedBox(
                                                        height: ConstantWidget
                                                            .getPercentSize(
                                                                firstHeight, 8),
                                                      ),
                                                      ConstantWidget
                                                          .getCustomText(
                                                              '₹' +
                                                                  list[index]
                                                                      .newMrp,
                                                              ConstantData
                                                                  .mainTextColor,
                                                              1,
                                                              TextAlign.start,
                                                              FontWeight.w700,
                                                              font18Px(
                                                                  context:
                                                                      context)),
                                                      SizedBox(
                                                        height: ConstantWidget
                                                            .getPercentSize(
                                                                firstHeight, 8),
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Align(
                                    //   alignment: Alignment.topCenter,
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //       SizedBox(
                                    //         height: ConstantWidget.getPercentSize(
                                    //             remainHeight, 8),
                                    //       ),
                                    //       ConstantWidget.getCustomText(
                                    //           list[index].productName,
                                    //           ConstantData.mainTextColor,
                                    //           1,
                                    //           TextAlign.start,
                                    //           FontWeight.w600,
                                    //           ConstantWidget.getPercentSize(
                                    //               remainHeight, 22)),
                                    //       SizedBox(
                                    //         height: ConstantWidget.getPercentSize(
                                    //             remainHeight, 8),
                                    //       ),
                                    //       ConstantWidget.getCustomText(
                                    //           list[index].prodSaleTypeDetails,
                                    //           Colors.grey,
                                    //           1,
                                    //           TextAlign.start,
                                    //           FontWeight.w600,
                                    //           ConstantWidget.getPercentSize(
                                    //               remainHeight, 14)),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ProductDetailPage(subCategoryModelList[index])));
                            },
                          ),
                        );
                      }));
            }
          }),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Observer(builder: (_) {
            final adminStatus = loginStore.loginModel.adminStatus;
            return Offstage(
              offstage: adminStatus,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: blockSizeVertical(context: context) * 10),
                child: ConstantWidget.adminStatusbanner(context),
              ),
            );
          }),
        ),
      ],
    );
  }
}
