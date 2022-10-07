// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/add_subtract_widget.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class ProductViewList extends StatelessWidget {
  const ProductViewList({
    Key? key,
    required this.loginStore,
    required this.list,
    required this.store,
    this.termValue,
    this.control,
  }) : super(key: key);

  final LoginStore loginStore;
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
      // print('scrollpositon------------${scrollController.positions.last}');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        store.paginationState = StoreState.LOADING;
        await getPaginatedResults();
        store.paginationState = StoreState.SUCCESS;
      }
    });

    double radius = ConstantWidget.getPercentSize(height, 5);
    return (list.isNotEmpty)
        ? ListView.builder(
            padding: EdgeInsets.only(right: sideMargin),
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: blockSizeVertical(context: context) * 1.5),
                child: InkWell(
                  onTap: () async {
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
                            child: ProductsDetailScreen(
                              model: model,
                              // modelIndex: index,
                              // list: list,
                            ),
                          ),
                        ),
                      ),
                    );
                    // }
                  },
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
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 0.08)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                            )
                          ]),
                      child: Stack(
                        children: [
                          //-----> Discount percent
                          Observer(builder: (_) {
                            print(
                                '----prod image --------${list[index].productImg}');
                            final adminStatus =
                                loginStore.loginModel.adminStatus;
                            return Offstage(
                              offstage: !adminStatus,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(sideMargin / 4),
                                  decoration: BoxDecoration(
                                    color: ConstantData.accentColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(radius)),
                                  ),
                                  child: ConstantWidget.getCustomText(
                                    list[index].percentDiscount,
                                    Colors.white,
                                    // ConstantData.accentColor,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w400,
                                    font15Px(context: context),
                                  ),
                                ),
                              ),
                            );
                          }),
                          // ),),visible:   (subCategoryModelList[index].offer != null || subCategoryModelList[index].offer.isNotEmpty),),

                          SizedBox(
                            height: firstHeight,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              //----> Image
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
                                        image: CachedNetworkImageProvider(
                                          ConstantData.productUrl +
                                              list[index].productImg,
                                        ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      blockSizeHorizontal(context: context) * 5,
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height:
                                                ConstantWidget.getPercentSize(
                                                    remainHeight, 8),
                                          ),
                                          //-----> Product Name
                                          ConstantWidget.getCustomText(
                                            list[index].productName,
                                            ConstantData.mainTextColor,
                                            3,
                                            TextAlign.start,
                                            FontWeight.w600,
                                            font18Px(context: context),
                                          ),
                                          SizedBox(
                                            height: blockSizeVertical(
                                                context: context),
                                          ),

                                          //-----> Product description
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ConstantWidget
                                                    .getCustomText(
                                                        list[index].description,
                                                        Colors.grey,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w600,
                                                        font12Px(
                                                            context: context)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      //----> Add,Remove buttons
                                      Observer(builder: (_) {
                                        final adminStatus =
                                            loginStore.loginModel.adminStatus;

                                        return Offstage(
                                          offstage: !adminStatus,
                                          child: Observer(builder: (_) {
                                            final _index = store
                                                .cartModel.productList
                                                .indexWhere((element) =>
                                                    element.pid ==
                                                    list[index].pid);

                                            if (list[index].cartQuantity! >=
                                                    1 &&
                                                _index != -1) {
                                              return Row(
                                                children: [
                                                  PlusMinusWidget(
                                                    model: list[index],
                                                    store: store,
                                                  ),
                                                  SizedBox(
                                                    width: blockSizeHorizontal(
                                                            context: context) *
                                                        2,
                                                  ),
                                                  RemoveButton(
                                                    store: store,
                                                    model: list[index],
                                                    width: width,
                                                    height: height,
                                                    fontSize: font12Px(
                                                        context: context),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return AddProductButton(
                                                store: store,
                                                model: list[index],
                                                width: blockSizeHorizontal(
                                                        context: context) *
                                                    5,
                                                height: blockSizeVertical(
                                                    context: context),
                                                fontSize:
                                                    font18Px(context: context),
                                                contextReq: context,
                                              );
                                            }
                                          }),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                // const Spacer(),
                                //----> MRP widgets
                                Observer(builder: (_) {
                                  final adminStatus =
                                      loginStore.loginModel.adminStatus;

                                  return Expanded(
                                    child: Offstage(
                                      offstage: !adminStatus,
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
                                                ConstantWidget.getLineTextView(
                                                  '₹${list[index].oldMrp}',
                                                  Colors.grey,
                                                  font15Px(context: context),
                                                ),
                                                SizedBox(
                                                  height: ConstantWidget
                                                      .getPercentSize(
                                                          firstHeight, 8),
                                                ),
                                                ConstantWidget.getCustomText(
                                                  '₹${list[index].newMrp}',
                                                  ConstantData.mainTextColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w600,
                                                  font15Px(context: context) *
                                                      1.1,
                                                ),
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
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  '${ConstantData.assetsPath}med_logo.png',
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
}
