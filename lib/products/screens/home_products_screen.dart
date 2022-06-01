import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/screens/cart_screen.dart';
import 'package:medrpha_customer/products/screens/categories_screen.dart';
import 'package:medrpha_customer/products/screens/product_details_screen.dart';
import 'package:medrpha_customer/products/screens/products_view_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 14);
    double searchHeight = ConstantWidget.getPercentSize(height, 40);
    double font = ConstantWidget.getScreenPercentSize(context, 2.3);

    double radius = ConstantWidget.getPercentSize(height, 10);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double sideMargin = margin * 1.2;

    final store = context.read<ProductsStore>();

    final loginStore = context.read<LoginStore>();

    // return Provider<ProductsStore>(
    //     create: (_) => ProductsStore()..init(),
    //     builder: (context, _) {
    //       final store = context.read<ProductsStore>();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: ConstantData.bgColor,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: margin * 1.5),
                    margin: EdgeInsets.symmetric(horizontal: sideMargin),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: blockSizeVertical(context: context) * 2),
                          child: InkWell(
                            child: Icon(
                              Icons.menu,
                              color: ConstantData.mainTextColor,
                            ),
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                        const Spacer(),
                        Observer(builder: (_) {
                          return InkWell(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: blockSizeVertical(context: context) *
                                          2),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: ConstantData.mainTextColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        blockSizeHorizontal(context: context) *
                                            2.5,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(
                                        blockSizeVertical(context: context)),
                                    decoration: const BoxDecoration(
                                        color: ConstantData.primaryColor,
                                        shape: BoxShape.circle),
                                    child: ConstantWidget.getCustomText(
                                        store.cartModel.noOfProducts.toString(),
                                        Colors.white,
                                        1,
                                        TextAlign.center,
                                        FontWeight.bold,
                                        10),
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
                                      child: const CartScreen(),
                                    ),
                                  ));
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  // Observer(builder: (_) {
                  //   final adminStatus = loginStore.loginModel.adminStatus;
                  //   return Offstage(
                  //     offstage: false,
                  //     child: Padding(
                  //       padding: EdgeInsets.only(
                  //           bottom: blockSizeVertical(context: context) * 2),
                  //       child: ConstantWidget.adminStatusbanner(context),
                  //     ),
                  //   );
                  // }),
                  Container(
                    // height: height,
                    margin: EdgeInsets.symmetric(horizontal: margin),
                    padding: EdgeInsets.all((margin * 1.2)),

                    decoration: BoxDecoration(
                      color: ConstantData.cellColor,
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ConstantWidget.getCustomText(
                                "Hey,",
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.start,
                                FontWeight.w600,
                                font),
                            const SizedBox(
                              width: 0.5,
                            ),
                            ConstantWidget.getCustomText(
                                "Welcome",
                                Colors.orange,
                                1,
                                TextAlign.start,
                                FontWeight.w600,
                                font),
                          ],
                        ),
                        SizedBox(
                          height: (margin / 2.5),
                        ),
                        ConstantWidget.getCustomText(
                            "Can I help you something?",
                            ConstantData.textColor,
                            1,
                            TextAlign.start,
                            FontWeight.w200,
                            (font / 1.5)),
                        SizedBox(
                          height: ((margin / 1.2)),
                        ),
                        InkWell(
                          child: SizedBox(
                            width: double.infinity,
                            height: searchHeight,
                            child: TextField(
                              style: TextStyle(
                                fontFamily: ConstantData.fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (string) {},
                              maxLines: 1,
                              enabled: true,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Search....',
                                // prefixIcon: Icon(Icons.search),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: ConstantData.fontFamily,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(radius)),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(radius)),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(radius)),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => SearchPage(),
                            //     ));
                          },
                        )
                      ],
                    ),
                  ),
                  Observer(builder: (_) {
                    final list = store.categories;
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: sideMargin, vertical: sideMargin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidget.getCustomTextWithoutAlign(
                              'Categories',
                              ConstantData.mainTextColor,
                              FontWeight.w700,
                              ConstantWidget.getScreenPercentSize(
                                  context, 2.5)),
                          const Spacer(),
                          Visibility(
                            child: InkWell(
                              child: ConstantWidget.getCustomTextWithoutAlign(
                                  'View All',
                                  ConstantData.accentColor,
                                  FontWeight.bold,
                                  ConstantWidget.getScreenPercentSize(
                                      context, 2)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Provider.value(
                                      value: loginStore,
                                      child: Provider.value(
                                        value: store,
                                        child: CategoriesListScreen(list: list),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            visible: true,
                          )
                        ],
                      ),
                    );
                  }),
                  Observer(builder: (_) {
                    final list = store.categories;
                    final state = store.catState;

                    switch (state) {
                      case StoreState.LOADING:
                        return SizedBox(
                          width: blockSizeHorizontal(context: context) * 10,
                          child: LinearProgressIndicator(
                            color: ConstantData.mainTextColor,
                            backgroundColor: ConstantData.cellColor,
                            // value: 1,
                            minHeight: 5,
                          ),
                        );
                      // return ConstantWidget.loadingIndicator(
                      //     context,
                      //     Colors.black,
                      //     blockSizeHorizontal(context: context) * 7);
                      case StoreState.SUCCESS:
                        return CategoryList(
                          list: list,
                          sideMargin: sideMargin,
                          store: store,
                          loginStore: loginStore,
                        );
                      case StoreState.ERROR:
                        return Image.asset(
                            ConstantData.assetsPath + 'splash.jpg');

                      case StoreState.EMPTY:
                        // return Image.asset(
                        //     ConstantData.assetsPath + 'splash.jpg');
                        return ConstantWidget.errorWidget(
                            context: context,
                            height: 10,
                            width: 6,
                            fontSize: font15Px(context: context));
                    }
                  }),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),
                  Observer(builder: (_) {
                    final list = store.allProducts;
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: sideMargin, vertical: sideMargin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidget.getCustomTextWithoutAlign(
                              'Products',
                              ConstantData.mainTextColor,
                              FontWeight.w700,
                              ConstantWidget.getScreenPercentSize(
                                  context, 2.5)),
                          const Spacer(),
                          InkWell(
                            child: ConstantWidget.getCustomTextWithoutAlign(
                                'View All',
                                ConstantData.accentColor,
                                FontWeight.bold,
                                ConstantWidget.getScreenPercentSize(
                                    context, 2)),
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
                                                appBarTitle: 'All Products',
                                              ),
                                            ),
                                          )));
                            },
                          )
                        ],
                      ),
                    );
                  }),
                  Observer(builder: (_) {
                    final list = store.ethicalProductList;
                    // list.shuffle();
                    final state = store.prodState;
                    switch (state) {
                      case StoreState.LOADING:
                        return SizedBox(
                          width: blockSizeHorizontal(context: context) * 10,
                          child: LinearProgressIndicator(
                            color: ConstantData.mainTextColor,
                            backgroundColor: ConstantData.cellColor,
                            // value: 1,
                            minHeight: 5,
                          ),
                        );
                      // return ConstantWidget.loadingIndicator(
                      //     context,
                      //     Colors.black,
                      //     blockSizeHorizontal(context: context) * 7);
                      case StoreState.SUCCESS:
                        return ProductsList(
                          store: store,
                          list: list,
                          axis: Axis.horizontal,
                          itemCount: (list.length < 5) ? list.length : 5,
                          loginStore: loginStore,
                        );
                      case StoreState.ERROR:
                        return Image.asset(
                            ConstantData.assetsPath + 'splash.jpg');
                      case StoreState.EMPTY:
                        return ConstantWidget.errorWidget(
                            context: context,
                            height: 10,
                            width: 6,
                            fontSize: font15Px(context: context));
                    }
                  }),
                ],
              ),
            ),
          ),
          Observer(builder: (_) {
            final adminStatus = loginStore.loginModel.adminStatus;
            return Offstage(
              offstage: adminStatus,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: blockSizeVertical(context: context) * 10),
                child: ConstantWidget.adminStatusbanner(context),
              ),
            );
          }),
        ],
      ),
    );
    // });
  }
}

class ProductsList extends StatelessWidget {
  const ProductsList({
    required this.list,
    required this.axis,
    required this.itemCount,
    required this.store,
    required this.loginStore,
    Key? key,
  }) : super(key: key);

  final List<ProductModel> list;
  final Axis axis;
  final int itemCount;
  final ProductsStore store;
  final LoginStore loginStore;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = safeBlockHorizontal(context: context) * 45;

    double width = ConstantWidget.getWidthPercentSize(context, 60);
    double sideMargin = margin * 1.2;
    double firstHeight = ConstantWidget.getPercentSize(height, 60);
    double remainHeight = height - firstHeight;

    double radius = ConstantWidget.getPercentSize(height, 5);

    return Container(
        height: height,
        margin: EdgeInsets.only(bottom: margin),
        child: ListView.builder(
            padding: EdgeInsets.only(right: sideMargin),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            scrollDirection: axis,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // print(list[index].category);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Provider.value(
                              value: store,
                              child: Provider.value(
                                value: loginStore,
                                child: ProductsDetailScreen(
                                  model: list[index],
                                  modelIndex: index,
                                ),
                              ))));
                },
                child: SizedBox(
                  width: width,
                  child: Container(
                    margin: EdgeInsets.only(left: sideMargin),
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
                        // Align(alignment: Alignment.topRight,
                        // child:
                        // Container(
                        //   padding: EdgeInsets.all(sideMargin/4),
                        //
                        //   decoration: BoxDecoration(
                        //     color: ConstantData.accentColor,
                        //     borderRadius: BorderRadius.only(topRight: Radius.circular(radius)),
                        //
                        //
                        //
                        //   ),
                        //   child: ConstantWidget.getCustomText(
                        //       (subCategoryModelList[index].offer !=
                        //           null)
                        //           ? subCategoryModelList[index].offer
                        //           : "",
                        //       Colors.white,
                        //       // ConstantData.accentColor,
                        //       1,
                        //       TextAlign.start,
                        //       FontWeight.w400,
                        //       ConstantWidget.getPercentSize(
                        //           firstHeight, 12)),
                        //
                        // ),),
                        //

                        // Align(
                        //   alignment: Alignment.bottomRight,
                        //   child: InkWell(
                        //     onTap: () {},
                        //     child: Container(
                        //       padding: EdgeInsets.all(
                        //           blockSizeHorizontal(context: context) * 2),
                        //       decoration: BoxDecoration(
                        //         color: ConstantData.primaryColor,
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       child: ConstantWidget.getCustomText(
                        //           'Add',
                        //           ConstantData.bgColor,
                        //           1,
                        //           TextAlign.center,
                        //           FontWeight.bold,
                        //           font15Px(context: context)),
                        //     ),
                        //   ),
                        // ),

                        Align(
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
                                ConstantWidget.getPercentSize(firstHeight, 12)),
                          ),
                        ),
                        // ),),visible:   (subCategoryModelList[index].offer != null || subCategoryModelList[index].offer.isNotEmpty),),

                        Container(
                          padding: EdgeInsets.all((sideMargin / 2)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: firstHeight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fit: BoxFit.cover)),
                                    ),
                                    Observer(builder: (_) {
                                      final adminStatus =
                                          loginStore.loginModel.adminStatus;
                                      if (adminStatus) {
                                        return Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ConstantWidget.getLineTextView(
                                                '₹' + list[index].oldMrp,
                                                Colors.grey,
                                                ConstantWidget.getPercentSize(
                                                    firstHeight, 12)),

                                            // ConstantWidget.getCustomText(
                                            //     (subCategoryModelList[index]
                                            //                 .offPrice !=
                                            //             null)
                                            //         ? subCategoryModelList[
                                            //                 index]
                                            //             .offPrice
                                            //         : "",
                                            //     Colors.grey,
                                            //     1,
                                            //     TextAlign.start,
                                            //     FontWeight.w600,
                                            //     ConstantWidget.getPercentSize(
                                            //         firstHeight, 12)),
                                            SizedBox(
                                              height:
                                                  ConstantWidget.getPercentSize(
                                                      firstHeight, 8),
                                            ),
                                            ConstantWidget.getCustomText(
                                                '₹' + list[index].newMrp,
                                                ConstantData.mainTextColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w700,
                                                font18Px(context: context)),
                                            SizedBox(
                                              height:
                                                  ConstantWidget.getPercentSize(
                                                      firstHeight, 8),
                                            ),
                                          ],
                                        ));
                                      } else {
                                        return const SizedBox();
                                      }
                                    })
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: ConstantWidget.getPercentSize(
                                        remainHeight, 8),
                                  ),
                                  ConstantWidget.getCustomText(
                                      (list[index].productName.length > 15)
                                          ? list[index]
                                                  .productName
                                                  .substring(0, 12) +
                                              '...'
                                          : list[index].productName,
                                      ConstantData.mainTextColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      ConstantWidget.getPercentSize(
                                          remainHeight, 22)),
                                  SizedBox(
                                    height: ConstantWidget.getPercentSize(
                                        remainHeight, 8),
                                  ),
                                  ConstantWidget.getCustomText(
                                      list[index].prodSaleTypeDetails,
                                      Colors.grey,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w600,
                                      ConstantWidget.getPercentSize(
                                          remainHeight, 14)),
                                ],
                              )),
                            ],
                          ),
                        ),
                        Observer(builder: (_) {
                          final adminStatus = loginStore.loginModel.adminStatus;
                          if (adminStatus) {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        blockSizeVertical(context: context) * 2,
                                    right:
                                        blockSizeHorizontal(context: context)),
                                child: InkWell(
                                  onTap: () async {
                                    final _index = store.cartModel.productList
                                        .indexWhere((element) =>
                                            element.pid == list[index].pid);
                                    SnackBar _snackBar;
                                    if (_index == -1) {
                                      await store.addToCart(model: list[index]);
                                      _snackBar = ConstantWidget.customSnackBar(
                                          text: 'Added To Cart',
                                          context: context);
                                    } else {
                                      _snackBar = ConstantWidget.customSnackBar(
                                          text: 'Item Already in Cart',
                                          context: context);
                                    }

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(_snackBar);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            blockSizeVertical(context: context),
                                        horizontal: blockSizeHorizontal(
                                                context: context) *
                                            4),
                                    decoration: BoxDecoration(
                                      color: ConstantData.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ConstantWidget.getCustomText(
                                        'Add',
                                        ConstantData.bgColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w500,
                                        font15Px(context: context)),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
    required this.list,
    required this.sideMargin,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  final List<CategoryModel> list;
  final double sideMargin;
  final ProductsStore store;
  final LoginStore loginStore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: safeBlockHorizontal(context: context) * 20,
        // margin: EdgeInsets.only(bottom: margin),
        child: ListView.builder(
            padding: EdgeInsets.only(right: sideMargin),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              double height = safeBlockHorizontal(context: context) * 20;
              double imageSize = ConstantWidget.getPercentSize(height, 65);
              double remainSize = height - imageSize;
              // if (colorIndex == (ConstantData.colorList().length - 1)) {
              //   colorIndex = 0;
              // } else {
              //   colorIndex++;
              // }
              return InkWell(
                child: SizedBox(
                  width: height,
                  child: Container(
                    margin: EdgeInsets.only(left: sideMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              ConstantWidget.getPercentSize(imageSize, 25)),
                          height: imageSize,
                          width: imageSize,
                          decoration: BoxDecoration(
                            // color: ConstantData.color1,
                            border: Border.all(
                                color: ConstantData.mainTextColor, width: 1.2),
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: ConstantData.catImgUrl +
                                list[index].categoryImgUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top:
                                  ConstantWidget.getPercentSize(remainSize, 20),
                            ),
                            child: ConstantWidget.getCustomText(
                                list[index].categoryName,
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.start,
                                FontWeight.w400,
                                font15Px(context: context)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  switch (list[index].categoryName) {
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
                                          itemCount:
                                              store.ethicalProductList.length,
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
                                          itemCount:
                                              store.genericProductList.length,
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
                                          itemCount:
                                              store.surgicalProductList.length,
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
                                          itemCount: store
                                              .veterinaryProductList.length,
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
                                          itemCount:
                                              store.ayurvedicProductList.length,
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
                                          itemCount:
                                              store.generalProductList.length,
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
                                          list: store.allProducts,
                                          axis: Axis.vertical,
                                          itemCount: store.allProducts.length,
                                          appBarTitle: 'All Prodcuts'),
                                    ),
                                  )));
                      break;
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SubCategoriesPage()));
                },
              );
            }));
  }
}
