// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    final scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        store.paginationState = StoreState.LOADING;
        final category = store.categoriesType;
        switch (category) {
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
          case CategoriesType.VACCINE:
            store.vaccinePageIndex++;
            debugPrint('---- page index------${store..vaccinePageIndex}');
            await store.getVaccineProducts(
              load: true,
            );
            break;
        }
        store.paginationState = StoreState.SUCCESS;
      }
    });

    return Scaffold(
      bottomNavigationBar: Observer(builder: (_) {
        if (((store.cartModel.productList.isNotEmpty) &&
                loginStore.loginModel.adminStatus) ||
            store.message == 'Products not servicable in your selected area!') {
          return Container(
            height: ConstantWidget.getWidthPercentSize(context, 15),
            decoration: BoxDecoration(
              color: ConstantData.color1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(font18Px(context: context)),
                topRight: Radius.circular(font18Px(context: context)),
              ),
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
                          'Payable:',
                          ConstantData.bgColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font15Px(context: context) * 1.2,
                        ),
                        SizedBox(
                          width: blockSizeHorizontal(context: context) * 3,
                        ),
                        ConstantWidget.getCustomText(
                          '₹${double.parse(store.cartModel.totalSalePrice).toStringAsFixed(2)}',
                          ConstantData.bgColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context) * 1.1,
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
                            'Go to Cart',
                            ConstantData.bgColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            font15Px(context: context) * 1.2,
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
      // floatingActionButton: Observer(builder: (_) {
      //   return Container(
      //     padding: EdgeInsets.all(blockSizeVertical(context: context) / 1.5),
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: (!store.micIsListening)
      //           ? ConstantData.primaryColor
      //           : ConstantData.color1,
      //     ),
      //     child: IconButton(
      //       onPressed: () async {
      //         debugPrint('------ listenin--- ');
      //         if (store.micEnabled && store.speechToText.isNotListening) {
      //           await store.startListening(context: context);
      //           // setState(() {});
      //         } else if (store.micEnabled &&
      //             !store.speechToText.isNotListening) {
      //           await store.stopListening();
      //           // setState(() {});
      //         } else {
      //           await store.intializeMic();
      //         }
      //         // setState(() {});
      //       },
      //       icon: Icon(
      //         (!store.micIsListening) ? Icons.mic : Icons.stop,
      //         size: blockSizeVertical(context: context) * 3,
      //         color: ConstantData.bgColor,
      //       ),
      //     ),
      //   );
      // }),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: ConstantData.bgColor,
              child: Column(
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  blockSizeHorizontal(context: context) * 4),
                          child: SizedBox(
                            height:
                                ConstantWidget.getWidthPercentSize(context, 12),
                            width:
                                ConstantWidget.getWidthPercentSize(context, 45),
                            child: Image.asset(
                              '${ConstantData.assetsPath}med_logo_text.png',
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: margin),
                            margin:
                                EdgeInsets.symmetric(horizontal: sideMargin),
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
                                          size: ConstantWidget
                                              .getWidthPercentSize(
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
                                              blockSizeVertical(
                                                  context: context)),
                                          decoration: BoxDecoration(
                                              color: ConstantData.primaryColor,
                                              shape: BoxShape.circle),
                                          child: Observer(builder: (_) {
                                            final adminStatus = loginStore
                                                .loginModel.adminStatus;
                                            final value = (store.cartModel
                                                        .productList.length >
                                                    10)
                                                ? '9+'
                                                : store.cartModel.productList
                                                    .length
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
                                                    value:
                                                        bottomNavigationStore,
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
                        controller: scrollController,
                        children: [
                          ///----------------------------------- Search bar --------------------------------------------
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    blockSizeHorizontal(context: context) * 4,
                                vertical:
                                    blockSizeVertical(context: context) * 2,
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
                                                child: Provider.value(
                                                  value: bottomNavigationStore,
                                                  child: const SearchScreen(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                                      await store.getSearchedResults(
                                          term: value);
                                    },
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
                                        fontSize:
                                            font15Px(context: context) * 1.2,
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
                                  child:
                                      ConstantWidget.getCustomTextWithoutAlign(
                                          'View All',
                                          ConstantData.primaryColor,
                                          FontWeight.w600,
                                          font18Px(context: context)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MultiProvider(providers: [
                                          Provider.value(value: store),
                                          Provider.value(value: loginStore),
                                          Provider.value(
                                              value: bottomNavigationStore),
                                          Provider.value(
                                              value: orderHistoryStore),
                                          Provider.value(value: profileStore),
                                        ], child: const CategoriesListScreen()),
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
                                return const LinearProgressIndicator();

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
                            height:
                                ConstantWidget.getScreenPercentSize(context, 2),
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
                                    return ConstantWidget
                                        .getCustomTextWithoutAlign(
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
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'Ethical',
                                          list: store.ethicalProductList,
                                        );
                                      case CategoriesType.GENERIC:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'Generic',
                                          list: store.genericProductList,
                                        );
                                      case CategoriesType.SURGICAL:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'Surgical',
                                          list: store.surgicalProductList,
                                        );
                                      case CategoriesType.VETERINARY:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'Veterinary',
                                          list: store.veterinaryProductList,
                                        );

                                      case CategoriesType.AYURVEDIC:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          store: store,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          label: 'Ayurvedic',
                                          list: store.ayurvedicProductList,
                                        );
                                      case CategoriesType.GENERAL:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'General',
                                          list: store.generalProductList,
                                        );
                                      case CategoriesType.VACCINE:
                                        return ViewAllToggle(
                                          loginStore: loginStore,
                                          orderHistoryStore: orderHistoryStore,
                                          profileStore: profileStore,
                                          bottomNavigationStore:
                                              bottomNavigationStore,
                                          store: store,
                                          label: 'Vaccine',
                                          list: store.vaccineProductList,
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
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );
                                  case CategoriesType.GENERIC:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.genericProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );
                                  case CategoriesType.SURGICAL:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.surgicalProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );

                                  case CategoriesType.VETERINARY:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.veterinaryProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );

                                  case CategoriesType.AYURVEDIC:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.ayurvedicProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );

                                  case CategoriesType.GENERAL:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.generalProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );
                                  case CategoriesType.VACCINE:
                                    return CategoryProducts(
                                      store: store,
                                      loginStore: loginStore,
                                      list: store.vaccineProductList,
                                      state: store.homeState,
                                      profileStore: profileStore,
                                      orderHistoryStore: orderHistoryStore,
                                      bottomNavigationStore:
                                          bottomNavigationStore,
                                    );
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Pagination Loader
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
          ),
          if (store.checkoutState == StoreState.LOADING)
            Container(
              height: screenHeight(context: context),
              width: screenWidth(context: context),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
              ),
              child: Center(
                child: ConstantWidget.loadingWidget(
                  size: blockSizeVertical(context: context) * 5,
                ),
              ),
            ),
        ],
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
    required this.bottomNavigationStore,
    required this.orderHistoryStore,
    required this.profileStore,
    required this.label,
    required this.list,
  }) : super(key: key);

  final LoginStore loginStore;
  final ProductsStore store;
  final ProfileStore profileStore;
  final BottomNavigationStore bottomNavigationStore;
  final OrderHistoryStore orderHistoryStore;
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
            builder: (_) => MultiProvider(
              providers: [
                Provider.value(value: loginStore),
                Provider.value(value: store),
                Provider.value(value: profileStore),
                Provider.value(value: bottomNavigationStore),
                Provider.value(value: orderHistoryStore),
              ],
              child: ProductsViewScreen(
                list: list,
                axis: Axis.vertical,
                itemCount: list.length,
                appBarTitle: label,
              ),
            ),
          ),
        );
      },
    );
  }
}
