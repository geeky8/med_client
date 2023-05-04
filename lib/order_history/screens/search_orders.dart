import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/screens/order_history_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../products/store/products_store.dart';
import '../../signup_login/store/login_store.dart';
import '../../utils/constant_data.dart';

class SearchOrders extends StatelessWidget {
  const SearchOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return WillPopScope(
      onWillPop: () async {
        orderHistoryStore.searchOrders
          ..clear()
          ..addAll(orderHistoryStore.allOrders);
        return true;
      },
      child: Scaffold(
        backgroundColor: ConstantData.bgColor,
        appBar: ConstantWidget.customAppBar(
          context: context,
          title: 'Search Orders',
        ),
        body: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: searchOrders(context),
              ),
              Expanded(
                child: Observer(builder: (context) {
                  if (orderHistoryStore.searchOrders.isEmpty) {
                    return const SizedBox();
                  }
                  return ViewOrdersList(
                    list: orderHistoryStore.searchOrders,
                    store: orderHistoryStore,
                    productsStore: store,
                    loginStore: loginStore,
                    profileStore: profileStore,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchOrders(BuildContext context) {
    final loginStore = context.read<LoginStore>();
    final store = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    double height = ConstantWidget.getScreenPercentSize(context, 14);
    double searchHeight = ConstantWidget.getPercentSize(height, 50);
    double radius = ConstantWidget.getPercentSize(height, 10);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: blockSizeHorizontal(context: context) * 4,
        vertical: blockSizeVertical(context: context) * 2,
      ),
      child: SizedBox(
        width: double.infinity,
        height: searchHeight,
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          ],
          enabled: true,
          style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (value) async {
            if (value.isNotEmpty) {
              final list = orderHistoryStore.allOrders
                  .where((element) => element.orderId.startsWith(value));
              if (list.isNotEmpty) {
                orderHistoryStore.searchOrders
                  ..clear()
                  ..addAll(list);
              } else {
                Fluttertoast.showToast(msg: "Order not found");
              }
            } else {
              orderHistoryStore.searchOrders
                ..clear()
                ..addAll(orderHistoryStore.allOrders);
            }
          },
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'Find Orders',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: font25Px(context: context) * 1.2,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontFamily: ConstantData.fontFamily,
              fontWeight: FontWeight.w300,
              fontSize: font15Px(context: context) * 1.2,
            ),
            filled: true,
            fillColor: Colors.white,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(color: ConstantData.cellColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(color: ConstantData.cellColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(color: ConstantData.cellColor, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
