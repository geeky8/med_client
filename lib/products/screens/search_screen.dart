import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/product_view_list.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    double height = ConstantWidget.getScreenPercentSize(context, 14);
    double radius = ConstantWidget.getPercentSize(height, 10);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    final controller = TextEditingController();

    String? termValue;

    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      appBar: ConstantWidget.customAppBar(
        context: context,
        title: 'Products',
        //TODO: Add Cart icons everywhere possible for wasy navigatiom.
      ),
      body: Observer(builder: (_) {
        return SafeArea(
          child: Column(
            children: [
              Observer(builder: (_) {
                final adminStatus = loginStore.loginModel.adminStatus;
                return Offstage(
                  offstage: adminStatus,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        ConstantWidget.adminStatusbanner(context),
                      ],
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context) * 2,
                ),
                child: Container(
                  padding: EdgeInsets.all((margin * 1.2)),
                  child: TextFormField(
                    controller: controller,
                    enabled: true,
                    autofocus: false,
                    style: TextStyle(
                      fontFamily: ConstantData.fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (value) async {
                      await store.getSearchedResults(term: value);
                      // termValue = value;
                    },
                    // onEditingComplete: () async {
                    //   await store.getSearchedResults(
                    //     term: controller.text.trim(),
                    //   );
                    //   // termValue = value;
                    // },
                    // onTapOutside: (data) {
                    //   debugPrint(data.position.toString());
                    //   store.searchList.clear();
                    // },
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Find Products',
                      // prefixIcon: Icon(Icons.search),

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
                        borderSide:
                            BorderSide(color: ConstantData.cellColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(radius)),
                        borderSide:
                            BorderSide(color: ConstantData.cellColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(radius)),
                        borderSide:
                            BorderSide(color: ConstantData.cellColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              Observer(builder: (_) {
                final state = store.searchState;

                print('Search state $state');

                final list = store.searchList;

                switch (state) {
                  case StoreState.LOADING:
                    return const SizedBox(
                      child: CircularProgressIndicator(),
                    );
                  case StoreState.SUCCESS:
                    return Expanded(
                      child: ProductViewList(
                        loginStore: loginStore,
                        orderHistoryStore: orderHistoryStore,
                        bottomNavigationStore: bottomNavigationStore,
                        profileStore: profileStore,
                        list: list,
                        store: store,
                      ),
                    );
                  case StoreState.ERROR:
                    return Center(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            '${ConstantData.assetsPath}med_logo_text.png',
                            height: ConstantWidget.getScreenPercentSize(
                                context, 15),
                            width:
                                ConstantWidget.getWidthPercentSize(context, 30),
                          ),
                          SizedBox(
                            height: blockSizeVertical(context: context) * 2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ConstantWidget.getWidthPercentSize(
                                  context, 10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ConstantWidget.getCustomText(
                                    store.message,
                                    ConstantData.mainTextColor,
                                    3,
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
                  case StoreState.EMPTY:
                    return Expanded(
                      child: ConstantWidget.errorWidget(
                        context: context,
                        height: 20,
                        width: 25,
                      ),
                    );
                }
              }),
              // Observer(builder: (_) {
              //   if (store.paginationState == StoreState.LOADING) {
              //     return Padding(
              //       padding: EdgeInsets.symmetric(
              //           vertical: blockSizeVertical(context: context)),
              //       child: const CircularProgressIndicator(),
              //     );
              //   }
              //   return const SizedBox();
              // }),
            ],
          ),
        );
      }),
    );
  }
}
