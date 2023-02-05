import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/product_view_list.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
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

    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      appBar: ConstantWidget.customAppBar(
          context: context, title: appBarTitle.toUpperCase()),
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
            Observer(builder: (_) {
              final show = list.length;
              if (show == 0) {
                return Expanded(
                  child: ConstantWidget.errorWidget(
                    context: context,
                    height: 20,
                    width: 15,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: margin),
                    child: ProductViewList(
                      loginStore: loginStore,
                      orderHistoryStore: orderHistoryStore,
                      profileStore: profileStore,
                      bottomNavigationStore: bottomNavigationStore,
                      list: list,
                      store: store,
                    ),
                  ),
                );
              }
            }),
            Observer(builder: (_) {
              if (store.paginationState == StoreState.LOADING) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: blockSizeVertical(context: context)),
                  child: const CircularProgressIndicator(),
                );
              }
              return const SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
