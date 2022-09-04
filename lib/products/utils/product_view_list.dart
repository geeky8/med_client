import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  }) : super(key: key);

  final LoginStore loginStore;
  final List<ProductModel> list;
  final ProductsStore store;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 60);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 60);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);
    return ListView.builder(
        padding: EdgeInsets.only(right: sideMargin),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: blockSizeVertical(context: context) * 1.5),
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
                        final adminStatus = loginStore.loginModel.adminStatus;
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
                              width: blockSizeHorizontal(context: context) * 5,
                            ),

                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: ConstantWidget.getPercentSize(
                                            remainHeight, 8),
                                      ),
                                      //-----> Product Name
                                      ConstantWidget.getCustomText(
                                        list[index].productName,
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w600,
                                        font18Px(context: context),
                                      ),
                                      SizedBox(
                                        height:
                                            blockSizeVertical(context: context),
                                      ),

                                      //-----> Product description
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ConstantWidget.getCustomText(
                                                list[index].description,
                                                Colors.grey,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w600,
                                                font12Px(context: context)),
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
                                                element.pid == list[index].pid);

                                        if (list[index].cartQuantity! >= 1 &&
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
                                                fontSize:
                                                    font12Px(context: context),
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
                                              height:
                                                  ConstantWidget.getPercentSize(
                                                      firstHeight, 8),
                                            ),
                                            ConstantWidget.getCustomText(
                                              '₹${list[index].newMrp}',
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w600,
                                              font15Px(context: context) * 1.1,
                                            ),
                                            SizedBox(
                                              height:
                                                  ConstantWidget.getPercentSize(
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Provider.value(
                            value: store,
                            child: Provider.value(
                              value: loginStore,
                              child: ProductsDetailScreen(
                                model: list[index],
                                // modelIndex: index,
                                // list: list,
                              ),
                            ))));
              },
            ),
          );
        });
  }
}
