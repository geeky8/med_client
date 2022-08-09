// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/bottom_navigation/screens/home_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/repository/order_history_repository.dart';
import 'package:medrpha_customer/order_history/screens/order_history_details_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/models/cart_model.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/products/utils/order_dialog.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'products_store.g.dart';

class ProductsStore = _ProductsStore with _$ProductsStore;

abstract class _ProductsStore with Store {
  final _productsRepository = ProductsRepository();

  @observable
  StoreState catState = StoreState.SUCCESS;

  @observable
  String message = 'Coming Soon!';

  // @observable
  // StoreState state = StoreState.SUCCESS;
  @observable
  CategoriesType categoriesType = CategoriesType.ETHICAL;

  @observable
  List<CategoryModel> categories = <CategoryModel>[];

  @observable
  StoreState prodState = StoreState.SUCCESS;

  @observable
  ObservableList<ProductModel> ethicalProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> genericProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> surgicalProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> veterinaryProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> ayurvedicProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> generalProductList =
      ObservableList<ProductModel>.of([]);

  // @observable
  // ObservableList<ProductModel> allProducts =
  //     ObservableList<ProductModel>.of([]);

  @observable
  StoreState homeState = StoreState.SUCCESS;

  @observable
  StoreState cartState = StoreState.SUCCESS;

  // @observable
  // StoreState checkoutState = StoreState.SUCCESS;

  // @observable
  // ObservableList<ProductModel> cartItemsList = ObservableList.of([]);

  Future<void> init() async {
    cartState = StoreState.LOADING;
    await getCategories();
    await _getProducts();
    if (ethicalProductList.isNotEmpty) {
      await getCartItems();
    }

    cartState = StoreState.SUCCESS;
    // allProducts
    //   ..clear()
    //   ..addAll(ethicalProductList)
    //   ..addAll(genericProductList)
    //   ..addAll(surgicalProductList)
    //   ..addAll(veterinaryProductList)
    //   ..addAll(ayurvedicProductList)
    //   ..addAll(generalProductList);
    // print('Parth');
  }

  Future<void> _getProducts() async {
    homeState = StoreState.LOADING;
    await getEthicalProducts();
    // if (ethicalProductList.isNotEmpty) {
    homeState = StoreState.SUCCESS;
    // }
    await getGenerallProducts();
    await getGenericProducts();
    await getSurgicalProducts();
    await getVeterinaryProducts();
    await getAyurvedicProducts();
    // print('Done');
    // homeState = StoreState.SUCCESS;
  }

  @action
  Future<void> getCategories() async {
    catState = StoreState.LOADING;
    final _list = await _productsRepository.getCategories();
    if (_list.isNotEmpty) {
      categories
        ..clear()
        ..addAll(_list);

      catState = StoreState.SUCCESS;
    } else {
      catState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getEthicalProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '1');
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        ethicalProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getGenericProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '2');
    if (productRespModel != null) {
      if (productRespModel.message == 'successful !!') {
        genericProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      } else if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        message = 'Admin Status Pending';
        prodState = StoreState.ERROR;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getSurgicalProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '3');
    if (productRespModel != null) {
      if (productRespModel.message == 'successful !!') {
        surgicalProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      } else if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        message = 'Admin Status Pending';
        prodState = StoreState.ERROR;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getVeterinaryProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '4');
    if (productRespModel != null) {
      if (productRespModel.message == 'successful !!') {
        veterinaryProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      } else if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        message = 'Admin Status Pending';
        prodState = StoreState.ERROR;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getAyurvedicProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '5');
    if (productRespModel != null) {
      if (productRespModel.message == 'successful !!') {
        ayurvedicProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      } else if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        message = 'Admin Status Pending';
        prodState = StoreState.ERROR;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getGenerallProducts() async {
    prodState = StoreState.LOADING;
    final productRespModel =
        await _productsRepository.getProducts(categoryId: '6');
    if (productRespModel != null) {
      if (productRespModel.message == 'successful !!') {
        generalProductList
          ..clear()
          ..addAll(productRespModel.productList);
        prodState = StoreState.SUCCESS;
      } else if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        message = 'Admin Status Pending';
        prodState = StoreState.ERROR;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  //-------------------------- Searching --------------------------------------//

  @observable
  StoreState searchState = StoreState.EMPTY;

  @observable
  TextEditingController searchController = TextEditingController();

  @observable
  ObservableList<ProductModel> searchList = ObservableList<ProductModel>.of([]);

  @action
  Future<void> getSearchedResults({required String term}) async {
    // print(term);
    if (term.isNotEmpty) {
      searchState = StoreState.LOADING;
      Future.delayed(Duration.zero, () async {
        final productRespModel =
            await _productsRepository.getProducts(term: term);
        if (productRespModel != null) {
          if (productRespModel.message == 'successful !!') {
            searchList
              ..clear()
              ..addAll(productRespModel.productList);
            searchState = StoreState.SUCCESS;
          } else if (productRespModel.message ==
              'product not serviceable in your area !!!') {
            message = 'Products not servicable in your selected area!';
            searchState = StoreState.ERROR;
          } else {
            message = 'Admin Status Pending';
            searchState = StoreState.ERROR;
          }
        } else {
          searchState = StoreState.EMPTY;
        }
      });
    } else {
      searchState = StoreState.EMPTY;
    }
  }

  //----------------------------------- Cart ---------------------------------------------------//
  @observable
  CartModel cartModel = CartModel(
    totalSalePrice: '',
    noOfProducts: 0,
    productList: ObservableList<ProductModel>.of([]),
  );

  @action
  Future<void> getCartItems({bool? isRemove}) async {
    final model = await _productsRepository.getCart();
    if (isRemove != null) {
      cartModel = cartModel.copyWith(
        totalSalePrice: model.totalSalePrice,
        noOfProducts: model.noOfProducts,
      );
    } else {
      // cartModel = model;
      final _list = ObservableList<ProductModel>.of([]);
      for (final i in model.productList) {
        final _updatedModel = await _updateProductsAccordingToCart(model: i);
        _list.add(_updatedModel);
      }
      cartModel = model.copyWith(productList: _list);
    }
    // cartState = StoreState.SUCCESS;
    // print(
    //     '--------------> Amount -------------------->${cartModel.totalSalePrice}');
    // print(cartModel.productList.toString());
  }

  @action
  Future<ProductModel> _updateProductsAccordingToCart(
      {required ProductModel model}) async {
    final category = categoriesfromValue(model.category);
    // print(model.cartQuantity);
    switch (category) {
      case CategoriesType.ETHICAL:
        final _index = ethicalProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = ethicalProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        ethicalProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);
        return _cartModel;
      case CategoriesType.GENERIC:
        final _index = genericProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = genericProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        genericProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);
        return _cartModel;
      case CategoriesType.SURGICAL:
        final _index = surgicalProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = surgicalProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        surgicalProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);

        return _cartModel;
      case CategoriesType.VETERINARY:
        final _index = veterinaryProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = veterinaryProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        veterinaryProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);
        return _cartModel;
      case CategoriesType.AYURVEDIC:
        final _index = ayurvedicProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = ayurvedicProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        ayurvedicProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);
        return _cartModel;
      case CategoriesType.GENERAL:
        final _index = generalProductList
            .indexWhere((element) => element.pid == model.pid);
        final _cartModel = generalProductList[_index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        generalProductList
          ..removeAt(_index)
          ..insert(_index, _cartModel);
        return _cartModel;
    }

    // final _totalPrice = (int.parse(model.salePrice) * model.cartQuantity!) +
    //     cartModel.totalSalePrice;
    // cartModel = cartModel.copyWith(
    //     totalSalePrice:
    //         _totalPrice); // print(ethicalProductList[index].cartQuantity);
  }

  @action
  Future<void> updateCartQunatity({
    required ProductModel model,
    required String value,
    required BuildContext context,
  }) async {
    SnackBar _snackBar;
    if (int.parse(value) > int.parse(model.quantity)) {
      _snackBar = ConstantWidget.customSnackBar(
          text: 'Selection exceeded avl quantity', context: context);
    } else if (int.parse(value) <= 0) {
      _snackBar = ConstantWidget.customSnackBar(
          text: 'Selection below minimum quantity', context: context);
    } else {
      final currModel = model.copyWith(cartQuantity: int.parse(value));
      final _index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(_index)
        ..insert(_index, currModel);
      await _productsRepository.updateQuantity(model: currModel);
      await getCartItems();
      _snackBar = ConstantWidget.customSnackBar(
          text: 'Successfully updated the quantity', context: context);
      // plusMinusToCart(model: currModel);
    }
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @action
  Future<void> plusToCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    int qty = model.cartQuantity! + 1;
    if (qty > int.parse(model.quantity)) {
      final _snackBar = ConstantWidget.customSnackBar(
          text: 'Selection exceeded avl quantity', context: context);
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    } else {
      final currModel = model.copyWith(cartQuantity: qty);
      final _index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(_index)
        ..insert(_index, currModel);
      await _productsRepository.plusTheCart(model: currModel);
      await getCartItems();
      // plusMinusToCart(model: currModel);
    }
  }

  @action
  Future<void> minusToCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    if (model.cartQuantity! > 1) {
      int qty = model.cartQuantity! - 1;
      final currModel = model.copyWith(cartQuantity: qty);
      final _index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(_index)
        ..insert(_index, currModel);
      await _productsRepository.minusTheCart(model: currModel);
      await getCartItems();
      // plusMinusToCart(model: currModel);
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   c
      // });
    } else if (model.cartQuantity == 1) {
      await removeFromCart(model: model);
      // int qty = model.cartQuantity! - 1;
      // final currModel = model.copyWith(cartQuantity: qty);
      // final _index = cartModel.productList
      //     .indexWhere((element) => element.pid == currModel.pid);
      // cartModel.productList
      //   ..removeAt(_index)
      //   ..insert(_index, currModel);
    } else {
      final _snackBar = ConstantWidget.customSnackBar(
          text: 'Selection below minimum quantity', context: context);
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
  }

  @action
  Future<void> addToCart({required ProductModel model}) async {
    // final index =
    //     cartItemsList.indexWhere((element) => element.pid == model.pid);
    // if (index == -1) {
    // print(model.cartQuantity);

    int qty = model.cartQuantity! + 1;
    final currModel = model.copyWith(cartQuantity: qty);
    cartModel.productList.add(currModel);
    await _productsRepository.addToCart(model: currModel);
    await getCartItems();
    // plusMinusToCart(model: _currModel);

    // final totalPrice =
    //     (int.parse(model.salePrice) * int.parse(model.cartQuantity)) +
    //         cartModel.totalSalePrice;
    // cartModel = cartModel.copyWith(totalSalePrice: totalPrice);
    // }
  }

  @action
  Future<void> removeFromCart({required ProductModel model}) async {
    final index =
        cartModel.productList.indexWhere((element) => element.pid == model.pid);
    // print(index);
    if (index != -1) {
      await _productsRepository.removeFromCart(model: model);
      await getCartItems(isRemove: true);
      _updateProductsAccordingToCart(model: model.copyWith(cartQuantity: 0));
      cartModel.productList.removeAt(index);
      // plusMinusToCart(model: _currModel);
      // final totalPrice =
      //     (int.parse(model.salePrice) * int.parse(model.cartQuantity)) +
      //         cartModel.totalSalePrice;
      // cartModel = cartModel.copyWith(totalSalePrice: totalPrice);
    }
  }

  //----------------------------------- Checkout ----------------------------------------------//
  @observable
  PaymentOptions paymentOptions = PaymentOptions.ONLINE;

  @action
  Future<String?> checkout({
    required BuildContext context,
  }) async {
    // String status;
    cartState = StoreState.LOADING;

    final payLater = (paymentOptions == PaymentOptions.PAYLATER) ? '2' : '1';

    final value = await _productsRepository.checkout(
      amount: cartModel.totalSalePrice.toString(),
      payLater: payLater,
    );
    if (value != null) {
      //----------- Payment confirmation -----------------------------
      if (paymentOptions == PaymentOptions.ONLINE) {
        final payStatus =
            await _productsRepository.paymentConfirmation(orderId: value);

        if (payStatus == 1) {
          //---------- Confirm Checkout -----------------------------
          // print('options ---------${paymentOptions.toPaymentOption()}');
          final confirmValue = await _productsRepository.checkoutConfirm(
            orderId: value,
            paymentOptionsType: paymentOptions,
          );

          cartState = StoreState.SUCCESS;
          return confirmValue;
        } else {
          final snackBar = ConstantWidget.customSnackBar(
            text:
                'Failed to process the payment, we will confirm the order soon',
            context: context,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        //---------- Confirm Checkout -----------------------------
        final confirmValue = await _productsRepository.checkoutConfirm(
          orderId: value,
          paymentOptionsType: paymentOptions,
        );

        cartState = StoreState.SUCCESS;
        return confirmValue;
      }
    } else {
      cartState = StoreState.SUCCESS;
    }
  }

  @observable
  StoreState checkoutState = StoreState.SUCCESS;

  @action
  Future<void> confirmPayment({
    required String orderId,
    required BuildContext context,
    required OrderHistoryStore orderHistoryStore,
  }) async {
    checkoutState = StoreState.LOADING;
    final payStatus = await _productsRepository.paymentConfirmation(
      orderId: orderId,
    );
    if (payStatus == 1) {
      await orderHistoryStore.getOrdersList();
      showDialog(
        context: context,
        builder: (context) => OrderDialog(
          func: () async {
            Navigator.pop(context);
          },
          image: 'order-confirmed.png',
          text: 'Thank you for confirming your payment',
          label: 'Cancel',
        ),
      );
      final snackBar = ConstantWidget.customSnackBar(
          text: 'Payment successfully confirmed', context: context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showDialog(
        context: context,
        builder: (context) => OrderDialog(
          func: () {
            Navigator.pop(context);
          },
          image: 'online-payment-error.png',
          text:
              'Oops...something went wrong. If money is deducted it will be refunded to your account.',
          label: 'Cancel',
        ),
      );
      final snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to place the order', context: context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    checkoutState = StoreState.SUCCESS;
  }

  @action
  Future<void> successOrder({
    required BuildContext context,
    required LoginStore loginStore,
    required ProfileStore profileStore,
    required BottomNavigationStore bottomNavigationStore,
    required OrderHistoryStore orderHistoryStore,
    required ProductsStore productsStore,
  }) async {
    checkoutState = StoreState.LOADING;
    final status = await checkout(context: context);
    if (status != null) {
      await getCartItems();
      await orderHistoryStore.getOrdersList();

      checkoutState = StoreState.SUCCESS;

      // if (fromOrders == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Provider.value(
            value: productsStore,
            child: Provider.value(
              value: loginStore,
              child: Provider.value(
                value: profileStore,
                child: Provider.value(
                  value: orderHistoryStore,
                  child: Provider.value(
                    value: bottomNavigationStore,
                    child: const HomeScreen(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      // }
      showDialog(
        context: context,
        builder: (context) => OrderDialog(
          func: () async {
            final repo = OrderHistoryRepository();
            final orderHistoryResponseModel =
                await repo.getOrdersResponseModel(orderId: status);
            final orderHistoryModel = await repo.getListOrdersHistory(
                orderNo: orderHistoryResponseModel.orderNo);
            Navigator.pop(context);

            // if (fromOrders == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Provider.value(
                  value: orderHistoryStore,
                  child: Provider.value(
                    value: loginStore,
                    child: Provider.value(
                      value: productsStore,
                      child: Provider.value(
                        value: profileStore,
                        child: OrderHistoryDetailsScreen(
                          model: orderHistoryModel.first,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            // }
          },
          image: 'order-confirmed.png',
          text: 'Thank you for placing your order',
          label: 'Check status',
        ),
      );
      // _relocateToHome();
    } else {
      showDialog(
        context: context,
        builder: (context) => OrderDialog(
          func: () {
            Navigator.pop(context);
          },
          image: 'online-payment-error.png',
          text:
              'Oops...something went wrong. If money is deducted it will be refunded to your account.',
          label: 'Cancel',
        ),
      );
      final snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to place the order', context: context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
