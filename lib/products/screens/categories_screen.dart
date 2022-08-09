import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:medrpha_customer/products/screens/products_view_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({
    Key? key,
    this.isHome,
  }) : super(key: key);

  final bool? isHome;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 1.7);
    var _crossAxisSpacing = 1;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = ConstantWidget.getScreenPercentSize(context, 11.5);
    // var cellHeight = _width;

    var _aspectRatio = _width / cellHeight;

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();

    final list = store.categories;

    return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: ConstantWidget.customAppBar(
          context: context,
          title: 'CATEGORY',
          isHome: isHome,
        ),
        // appBar: AppBar(
        //   elevation: 0,
        //   centerTitle: true,
        //   backgroundColor: ConstantData.bgColor,
        //   title: ConstantWidget.getAppBarText('Category', context),
        //   leading: Builder(
        //     builder: (BuildContext context) {
        //       return IconButton(
        //         icon: ConstantWidget.getAppBarIcon(),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       );
        //     },
        //   ),
        // ),
        body: SafeArea(
          child: Column(
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
              // AppBar(
              //   elevation: 0,
              //   centerTitle: true,
              //   backgroundColor: ConstantData.bgColor,
              //   title: ConstantWidget.getAppBarText('Category', context),
              //   leading: Builder(
              //     builder: (BuildContext context) {
              //       return IconButton(
              //         icon: ConstantWidget.getAppBarIcon(),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       );
              //     },
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context) * 2,
                  horizontal: blockSizeHorizontal(context: context) * 2,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.01),
                  padding: EdgeInsets.symmetric(horizontal: margin),
                  child: GridView.count(
                    crossAxisCount: _crossAxisCount,
                    shrinkWrap: true,
                    childAspectRatio: _aspectRatio,
                    mainAxisSpacing: (margin / 1.5),
                    crossAxisSpacing: (margin / 1.5),
                    // childAspectRatio: 0.64,
                    primary: false,
                    children: List.generate(list.length, (index) {
                      // z

                      return BackGroundTile(
                        categoryName: list[index].categoryName,
                        cellHeight: cellHeight,
                        colorIndex: 1,
                        catImgUrl: list[index].categoryImgUrl,
                        store: store,
                        loginStore: loginStore,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class BackGroundTile extends StatelessWidget {
  final String categoryName;
  final double cellHeight;
  final int colorIndex;
  final String catImgUrl;
  final ProductsStore store;
  final LoginStore loginStore;

  const BackGroundTile({
    Key? key,
    required this.categoryName,
    required this.cellHeight,
    required this.colorIndex,
    required this.catImgUrl,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize = ConstantWidget.getPercentSize(cellHeight, 70);
    double radius = ConstantWidget.getPercentSize(cellHeight, 10);

    return InkWell(
      child: Container(
        height: cellHeight,
        padding: EdgeInsets.symmetric(
            horizontal: ConstantWidget.getPercentSize(cellHeight, 10)),
        decoration: BoxDecoration(
          color: ConstantData.cellColor,
          borderRadius: BorderRadius.circular(radius),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.all(ConstantWidget.getPercentSize(imageSize, 18)),
              height: imageSize,
              width: imageSize,
              decoration: BoxDecoration(
                color: ConstantData.bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: ConstantData.catImgUrl + catImgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: ConstantWidget.getPercentSize(imageSize, 8),
            ),
            Expanded(
                child: ConstantWidget.getCustomText(
                    categoryName,
                    ConstantData.mainTextColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantWidget.getPercentSize(cellHeight, 15)))
          ],
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Container(
        //       height: imageSize,
        //       width: double.infinity,
        //       margin: EdgeInsets.only(
        //           left: ConstantWidget.getPercentSize(imageSize, 9),
        //           right: ConstantWidget.getPercentSize(imageSize, 9),
        //           top: ConstantWidget.getPercentSize(imageSize, 9)),
        //       padding: EdgeInsets.all(
        //           ConstantWidget.getPercentSize(imageSize, 25)),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.rectangle,
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(radius),
        //         ),
        //
        //           image: DecorationImage(
        //               image: AssetImage(ConstantData.assetsPath + subCategoryModel.image),
        //               fit: BoxFit.cover)
        //
        //       ),
        //
        //     ),
        //
        //     Expanded(child: Container(
        //      height: bottomRemainSize,
        //       child: Center(
        //       child: ConstantWidget.getCustomText(
        //           subCategoryModel.name,
        //           ConstantData.mainTextColor,
        //           1,
        //           TextAlign.center,
        //           FontWeight.w800,
        //           ConstantWidget.getPercentSize(bottomRemainSize, 20)),
        //     ),))
        //
        //   ],
        // ),
      ),
      onTap: () {
        switch (categoryName) {
          case 'Ethical':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.ethicalProductList,
                                axis: Axis.vertical,
                                itemCount: store.ethicalProductList.length,
                                appBarTitle: 'Ethical'),
                          ),
                        )));
            break;
          case 'Generic':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.genericProductList,
                                axis: Axis.vertical,
                                itemCount: store.genericProductList.length,
                                appBarTitle: 'Generic'),
                          ),
                        )));
            break;
          case 'Surgical':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.surgicalProductList,
                                axis: Axis.vertical,
                                itemCount: store.surgicalProductList.length,
                                appBarTitle: 'Surgical'),
                          ),
                        )));
            break;

          case 'Veterinary':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.veterinaryProductList,
                                axis: Axis.vertical,
                                itemCount: store.veterinaryProductList.length,
                                appBarTitle: 'Veterinary'),
                          ),
                        )));
            break;

          case 'Ayurvedic':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.ayurvedicProductList,
                                axis: Axis.vertical,
                                itemCount: store.ayurvedicProductList.length,
                                appBarTitle: 'Ayurvedic'),
                          ),
                        )));
            break;

          case 'General':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.generalProductList,
                                axis: Axis.vertical,
                                itemCount: store.generalProductList.length,
                                appBarTitle: 'General'),
                          ),
                        )));
            break;

          default:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                          value: store,
                          child: Provider.value(
                            value: loginStore,
                            child: ProductsViewScreen(
                                list: store.generalProductList,
                                axis: Axis.vertical,
                                itemCount: store.generalProductList.length,
                                appBarTitle: 'All Prodcuts'),
                          ),
                        )));
            break;
        }

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => SubCategoriesPage()));
      },
    );
  }
}
