import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/api_service.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';

import 'package:medrpha_customer/products/screens/products_view_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
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
    var crossAxisSpacing = 1;
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = 2;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    var cellHeight = ConstantWidget.getScreenPercentSize(context, 11.5);
    // var cellHeight = _width;

    var aspectRatio = width / cellHeight;

    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    final list = store.categories;

    return Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: ConstantWidget.customAppBar(
          context: context,
          title: 'CATEGORY',
          isHome: isHome,
        ),
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
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: (margin / 1.5),
                    crossAxisSpacing: (margin / 1.5),
                    // childAspectRatio: 0.64,
                    primary: false,
                    children: List.generate(list.length, (index) {
                      return BackGroundTile(
                        categoryName: list[index].categoryName,
                        orderHistoryStore: orderHistoryStore,
                        bottomNavigationStore: bottomNavigationStore,
                        profileStore: profileStore,
                        cellHeight: cellHeight,
                        colorIndex: 1,
                        catUrl: list[index].categoryImgUrl,
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
  final String catUrl;
  final ProductsStore store;
  final LoginStore loginStore;
  final ProfileStore profileStore;
  final OrderHistoryStore orderHistoryStore;
  final BottomNavigationStore bottomNavigationStore;

  const BackGroundTile({
    Key? key,
    required this.categoryName,
    required this.cellHeight,
    required this.colorIndex,
    required this.catUrl,
    required this.store,
    required this.loginStore,
    required this.profileStore,
    required this.orderHistoryStore,
    required this.bottomNavigationStore,
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
                  imageUrl: catImgUrl + catUrl,
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
                    FontWeight.w600,
                    ConstantWidget.getPercentSize(cellHeight, 15)))
          ],
        ),
      ),
      onTap: () {
        switch (categoriesfromValue(categoryName)) {
          case CategoriesType.ETHICAL:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.ethicalProductList,
                    axis: Axis.vertical,
                    itemCount: store.ethicalProductList.length,
                    appBarTitle: 'Ethical',
                  ),
                ),
              ),
            );
            break;
          case CategoriesType.GENERIC:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.genericProductList,
                    axis: Axis.vertical,
                    itemCount: store.genericProductList.length,
                    appBarTitle: 'Generic',
                  ),
                ),
              ),
            );
            break;
          case CategoriesType.SURGICAL:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.surgicalProductList,
                    axis: Axis.vertical,
                    itemCount: store.surgicalProductList.length,
                    appBarTitle: 'Surgical',
                  ),
                ),
              ),
            );
            break;

          case CategoriesType.VETERINARY:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.veterinaryProductList,
                    axis: Axis.vertical,
                    itemCount: store.veterinaryProductList.length,
                    appBarTitle: 'Veterinary',
                  ),
                ),
              ),
            );
            break;

          case CategoriesType.AYURVEDIC:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.ayurvedicProductList,
                    axis: Axis.vertical,
                    itemCount: store.ayurvedicProductList.length,
                    appBarTitle: 'Ayurvedic',
                  ),
                ),
              ),
            );
            break;

          case CategoriesType.GENERAL:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.generalProductList,
                    axis: Axis.vertical,
                    itemCount: store.generalProductList.length,
                    appBarTitle: 'General',
                  ),
                ),
              ),
            );
            break;

          case CategoriesType.VACCINE:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.vaccineProductList,
                    axis: Axis.vertical,
                    itemCount: store.vaccineProductList.length,
                    appBarTitle: 'Vaccine',
                  ),
                ),
              ),
            );
            break;

          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: loginStore),
                    Provider.value(value: profileStore),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: bottomNavigationStore),
                  ],
                  child: ProductsViewScreen(
                    list: store.generalProductList,
                    axis: Axis.vertical,
                    itemCount: store.generalProductList.length,
                    appBarTitle: 'All Prodcuts',
                  ),
                ),
              ),
            );
            break;
        }
      },
    );
  }
}
