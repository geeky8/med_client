import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/product_view_list.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
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

    // double sideMargin = margin * 1.2;
    // double firstHeight = ConstantWidget.getPercentSize(height, 60);
    // double remainHeight = height - firstHeight;

    // double radius = ConstantWidget.getPercentSize(height, 5);

    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();

    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      appBar: ConstantWidget.customAppBar(
          context: context, title: appBarTitle.toUpperCase()),
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   backgroundColor: ConstantData.bgColor,
      //   title: ConstantWidget.getAppBarText(appBarTitle, context),
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
            //   title: ConstantWidget.getAppBarText(appBarTitle, context),
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

            Observer(builder: (_) {
              final show = list.length;
              if (show == 0) {
                return Expanded(
                  child: ConstantWidget.errorWidget(
                    context: context,
                    height: 20,
                    width: 15,
                    // fontSize: font18Px(context: context),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                    // height: ConstantWidget.getScreenPercentSize(context, 78),
                    margin: EdgeInsets.only(bottom: margin),
                    child: ProductViewList(
                      loginStore: loginStore,
                      list: list,
                      store: store,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
