// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/cart_screen.dart';
import 'package:medrpha_customer/products/screens/categories_screen.dart';
import 'package:medrpha_customer/products/screens/products_view_screen.dart';
import 'package:medrpha_customer/products/screens/search_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/category_list.dart';
import 'package:medrpha_customer/products/utils/products_list.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ProductHomeScreen extends StatelessWidget {
  const ProductHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Constant values
    double height = ConstantWidget.getScreenPercentSize(context, 14);
    double searchHeight = ConstantWidget.getPercentSize(height, 50);
    double radius = ConstantWidget.getPercentSize(height, 10);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double sideMargin = margin * 1.2;

    /// Initalisation of required stores [ProductsStore,LoginStore,ProfileStore,OrderHistoryStore]
    final store = context.read<ProductsStore>();
    final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return Scaffold(
      bottomNavigationBar: Observer(builder: (_) {
        if ((store.cartModel.totalSalePrice != '0' &&
                loginStore.loginModel.adminStatus) ||
            store.message == 'Products not servicable in your selected area!') {
          return Container(
            height: ConstantWidget.getWidthPercentSize(context, 15),
            decoration: BoxDecoration(
              color: ConstantData.accentColor.withOpacity(0.5),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        ConstantWidget.getCustomText(
                          'Total Payable:',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font15Px(context: context) * 1.1,
                        ),
                        SizedBox(
                          width: blockSizeHorizontal(context: context) * 3,
                        ),
                        ConstantWidget.getCustomText(
                          '₹${store.cartModel.totalSalePrice}',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    // flex: 4,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Provider.value(
                                    value: store,
                                    child: Provider.value(
                                      value: loginStore,
                                      child: Provider.value(
                                        value: profileStore,
                                        child: Provider.value(
                                          value: orderHistoryStore,
                                          child: Provider.value(
                                            value: bottomNavigationStore,
                                            child: const CartScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                          child: ConstantWidget.getCustomText(
                            'View in Cart',
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            font15Px(context: context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      body: SafeArea(
        child: Container(
          color: ConstantData.bgColor,
          // height: screenHeight(context: context) / 1.2,
          child: Column(
            // controller: ScrollController(),
            children: [
              ///----------------------------------- Admin Status Banner --------------------------------------------
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

              /// Logo header and cart button
              Padding(
                padding: EdgeInsets.only(
                    top: ConstantWidget.getWidthPercentSize(context, 3)),
                child: Row(
                  children: [
                    SizedBox(
                      height: ConstantWidget.getWidthPercentSize(context, 12),
                      width: ConstantWidget.getWidthPercentSize(context, 45),
                      child: Image.asset(
                        '${ConstantData.assetsPath}med_logo_text.png',
                        // fit: BoxFit.fill,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: margin),
                        margin: EdgeInsets.symmetric(horizontal: sideMargin),
                        child: Row(
                          children: [
                            const Spacer(),
                            InkWell(
                              child: Stack(
                                children: [
                                  /// Cart-Icon
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: blockSizeVertical(
                                                context: context) *
                                            2),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ConstantData.mainTextColor,
                                      size: ConstantWidget.getWidthPercentSize(
                                          context, 5.5),
                                    ),
                                  ),

                                  /// No of items in cart
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: blockSizeHorizontal(
                                              context: context) *
                                          2.5,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(
                                          blockSizeVertical(context: context)),
                                      decoration: BoxDecoration(
                                          color: ConstantData.primaryColor,
                                          shape: BoxShape.circle),
                                      child: Observer(builder: (_) {
                                        final adminStatus =
                                            loginStore.loginModel.adminStatus;
                                        final value =
                                            (store.cartModel.noOfProducts > 10)
                                                ? '9+'
                                                : store.cartModel.noOfProducts
                                                    .toString();
                                        return ConstantWidget.getCustomText(
                                          (adminStatus) ? value : '0',
                                          Colors.white,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w600,
                                          font12Px(context: context) / 1.2,
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Provider.value(
                                        value: store,
                                        child: Provider.value(
                                          value: loginStore,
                                          child: Provider.value(
                                            value: profileStore,
                                            child: Provider.value(
                                              value: orderHistoryStore,
                                              child: Provider.value(
                                                value: bottomNavigationStore,
                                                child: const CartScreen(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   // height: height,
              //   margin: EdgeInsets.symmetric(horizontal: margin),
              //   padding: EdgeInsets.all((margin * 1.2)),

              //   decoration: BoxDecoration(
              //     color: ConstantData.cellColor,
              //     borderRadius: BorderRadius.all(Radius.circular(radius)),
              //   ),

              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           ConstantWidget.getCustomText(
              //             "Hey,",
              //             ConstantData.mainTextColor,
              //             1,
              //             TextAlign.start,
              //             FontWeight.w600,
              //             font18Px(context: context),
              //           ),
              //           const SizedBox(
              //             width: 0.5,
              //           ),
              //           ConstantWidget.getCustomText(
              //             "Welcome",
              //             Colors.orange,
              //             1,
              //             TextAlign.start,
              //             FontWeight.w600,
              //             font18Px(context: context),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: (margin / 2.5),
              //       ),
              //       ConstantWidget.getCustomText(
              //         "Can I help you something?",
              //         ConstantData.textColor,
              //         1,
              //         TextAlign.start,
              //         FontWeight.w200,
              //         font15Px(context: context) * 1.2,
              //       ),
              //       SizedBox(
              //         height: ((margin / 1.2)),
              //       ),
              //       InkWell(
              //         child: SizedBox(
              //           width: double.infinity,
              //           height: searchHeight,
              //           child: TextField(
              //             style: TextStyle(
              //               fontFamily: ConstantData.fontFamily,
              //               fontWeight: FontWeight.w400,
              //             ),
              //             onChanged: (string) {},
              //             maxLines: 1,
              //             enabled: true,
              //             textAlignVertical: TextAlignVertical.center,
              //             textAlign: TextAlign.left,
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.zero,
              //               hintText: 'Search....',
              //               // prefixIcon: Icon(Icons.search),

              //               prefixIcon: Icon(
              //                 Icons.search,
              //                 color: Colors.grey,
              //                 size: font18Px(context: context) * 1.2,
              //               ),
              //               hintStyle: TextStyle(
              //                 color: Colors.grey,
              //                 fontFamily: ConstantData.fontFamily,
              //                 fontWeight: FontWeight.w400,
              //                 fontSize: font15Px(context: context) * 1.2,
              //               ),
              //               filled: true,
              //               fillColor: Colors.white,
              //               disabledBorder: OutlineInputBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(radius)),
              //                 borderSide: const BorderSide(
              //                     color: Colors.white, width: 2),
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(radius)),
              //                 borderSide: const BorderSide(
              //                     color: Colors.white, width: 2),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(radius)),
              //                 borderSide: const BorderSide(
              //                     color: Colors.white, width: 2),
              //               ),
              //             ),
              //           ),
              //         ),
              //         onTap: () {},
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: blockSizeVertical(context: context),
              ),

              ///----------------------------------- Categories,Search-bar and Products ListView --------------------------------------------
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await loginStore.getUserStatus();
                    await store.init();
                  },
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ///----------------------------------- Search bar --------------------------------------------
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                blockSizeHorizontal(context: context) * 4,
                            vertical: blockSizeVertical(context: context) * 2,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: searchHeight,
                            child: InkWell(
                              onTap: () {
                                // store.searchController =
                                //     TextEditingController(text: '');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Provider.value(
                                        value: store,
                                        child: Provider.value(
                                            value: loginStore,
                                            child: Provider.value(
                                                value: profileStore,
                                                child: Provider.value(
                                                    value: orderHistoryStore,
                                                    child:
                                                        const SearchScreen())))),
                                  ),
                                );
                                // FocusScope.of(context)
                              },
                              child: TextFormField(
                                enabled: false,
                                style: TextStyle(
                                  fontFamily: ConstantData.fontFamily,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (value) async {
                                  await store.getSearchedResults(term: value);
                                },
                                // onFieldSubmitted: (value) async {
                                //   await store.getSearchedResults(term: value);
                                // },
                                maxLines: 1,
                                // controller: store.searchController,
                                // enabled: false,
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(radius)),
                                    borderSide: BorderSide(
                                        color: ConstantData.cellColor,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(radius)),
                                    borderSide: BorderSide(
                                        color: ConstantData.cellColor,
                                        width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(radius)),
                                    borderSide: BorderSide(
                                        color: ConstantData.cellColor,
                                        width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: sideMargin, vertical: sideMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstantWidget.getCustomTextWithoutAlign(
                              'Categories',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context),
                            ),
                            const Spacer(),
                            InkWell(
                              child: ConstantWidget.getCustomTextWithoutAlign(
                                  'View All',
                                  ConstantData.primaryColor,
                                  FontWeight.w600,
                                  font18Px(context: context)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Provider.value(
                                      value: loginStore,
                                      child: Provider.value(
                                        value: store,
                                        child: const CategoriesListScreen(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Observer(builder: (_) {
                        final list = store.categories;
                        final state = store.catState;

                        switch (state) {
                          case StoreState.LOADING:
                            // return LoadingAnimationWidget.dotsTriangle(
                            //   color: ConstantData.accentColor,
                            //   size: ConstantWidget.getScreenPercentSize(
                            //       context, 7),
                            // );
                            return SizedBox(
                              height: ConstantWidget.getWidthPercentSize(
                                  context, 10),
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 10),
                              child: const CircularProgressIndicator(),
                            );

                          case StoreState.SUCCESS:
                            return CategoryList(
                              list: list,
                              sideMargin: sideMargin,
                              store: store,
                              loginStore: loginStore,
                            );
                          case StoreState.ERROR:
                            return Image.asset(
                                '${ConstantData.assetsPath}splash.jpg');

                          case StoreState.EMPTY:
                            return ConstantWidget.errorWidget(
                              context: context,
                              height: 10,
                              width: 6,
                            );
                        }
                      }),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 2),
                      ),

                      ///----------------------------------- Products --------------------------------------------
                      StickyHeader(
                        header: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: sideMargin, vertical: sideMargin),
                          decoration:
                              BoxDecoration(color: ConstantData.bgColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Observer(builder: (_) {
                                final categoryType = store.categoriesType;
                                return ConstantWidget.getCustomTextWithoutAlign(
                                  '${categoryType.categoryString()}',
                                  ConstantData.mainTextColor,
                                  FontWeight.w600,
                                  font22Px(context: context),
                                );
                              }),
                              const Spacer(),
                              Observer(builder: (_) {
                                final category = store.categoriesType;
                                switch (category) {
                                  case CategoriesType.ETHICAL:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'Ethical',
                                      list: store.ethicalProductList,
                                    );
                                  case CategoriesType.GENERIC:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'Generic',
                                      list: store.genericProductList,
                                    );
                                  case CategoriesType.SURGICAL:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'Surgical',
                                      list: store.surgicalProductList,
                                    );
                                  case CategoriesType.VETERINARY:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'Veterinary',
                                      list: store.veterinaryProductList,
                                    );

                                  case CategoriesType.AYURVEDIC:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'Ayurvedic',
                                      list: store.ayurvedicProductList,
                                    );
                                  case CategoriesType.GENERAL:
                                    return ViewAllToggle(
                                      loginStore: loginStore,
                                      store: store,
                                      label: 'General',
                                      list: store.generalProductList,
                                    );
                                }
                              })
                            ],
                          ),
                        ),
                        content: Container(
                          child: Observer(builder: (_) {
                            final category = store.categoriesType;
                            switch (category) {
                              case CategoriesType.ETHICAL:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.ethicalProductList,
                                  state: store.homeState,
                                );
                              case CategoriesType.GENERIC:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.genericProductList,
                                  state: store.homeState,
                                );
                              case CategoriesType.SURGICAL:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.surgicalProductList,
                                  state: store.homeState,
                                );

                              case CategoriesType.VETERINARY:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.veterinaryProductList,
                                  state: store.homeState,
                                );

                              case CategoriesType.AYURVEDIC:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.ayurvedicProductList,
                                  state: store.homeState,
                                );

                              case CategoriesType.GENERAL:
                                return CategoryProducts(
                                  store: store,
                                  loginStore: loginStore,
                                  list: store.generalProductList,
                                  state: store.homeState,
                                );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // });
  }
}

class ViewAllToggle extends StatelessWidget {
  /// Button to view all products based on [ProductModel]
  const ViewAllToggle({
    Key? key,
    required this.loginStore,
    required this.store,
    required this.label,
    required this.list,
  }) : super(key: key);

  final LoginStore loginStore;
  final ProductsStore store;
  final List<ProductModel> list;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ConstantWidget.getCustomTextWithoutAlign(
        'View All',
        ConstantData.primaryColor,
        FontWeight.w600,
        font18Px(context: context),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Provider.value(
                      value: loginStore,
                      child: Provider.value(
                        value: store,
                        child: ProductsViewScreen(
                          list: list,
                          axis: Axis.vertical,
                          itemCount: list.length,
                          appBarTitle: label,
                        ),
                      ),
                    )));
      },
    );
  }
}
