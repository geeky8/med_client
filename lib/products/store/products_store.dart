// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
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
import 'package:medrpha_customer/products/utils/order_dialog.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
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

  @observable
  int ethicalPageIndex = 1;

  @observable
  int genericPageIndex = 1;

  @observable
  int surgicalPageIndex = 1;

  @observable
  int vetPageIndex = 1;

  @observable
  int ayurvedicPageIndex = 1;

  @observable
  int generalPageIndex = 1;

  @observable
  int searchIndex = 1;

  @observable
  StoreState paginationState = StoreState.SUCCESS;

  Future<void> init() async {
    ethicalPageIndex = 1;
    generalPageIndex = 1;
    surgicalPageIndex = 1;
    ayurvedicPageIndex = 1;
    vetPageIndex = 1;
    genericPageIndex = 1;

    cartState = StoreState.LOADING;
    await getCategories();
    await _getProducts();
    if (ethicalProductList.isNotEmpty) {
      await getCartItems(cartOpt: true);
    }

    cartState = StoreState.SUCCESS;
  }

  Future<void> _getProducts() async {
    homeState = StoreState.LOADING;
    await getEthicalProducts();
    homeState = StoreState.SUCCESS;
    await getGenerallProducts();
    await getGenericProducts();
    await getSurgicalProducts();
    await getVeterinaryProducts();
    await getAyurvedicProducts();
  }

  @action
  Future<void> getCategories() async {
    catState = StoreState.LOADING;
    final list = await _productsRepository.getCategories();
    if (list.isNotEmpty) {
      categories
        ..clear()
        ..addAll(list);

      catState = StoreState.SUCCESS;
    } else {
      catState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getEthicalProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '1',
      pageIndex: ethicalPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            ethicalProductList.addAll(productRespModel.productList);
          } else {
            ethicalProductList
              ..clear()
              ..addAll(productRespModel.productList);
            print('----prod state ${prodState.name}');
          }
        } else if (ethicalPageIndex > 1) {
          ethicalPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<ProductModel> getProductDetails({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();
    final fetchModel = await _productsRepository.getProductDetails(
      model: model,
      sessId: sessId,
    );
    return fetchModel;
  }

  @action
  Future<void> getGenericProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '2',
      pageIndex: genericPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            genericProductList.addAll(productRespModel.productList);
          } else {
            genericProductList
              ..clear()
              ..addAll(productRespModel.productList);
          }
        } else if (genericPageIndex > 1) {
          genericPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getSurgicalProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '3',
      pageIndex: surgicalPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            surgicalProductList.addAll(productRespModel.productList);
          } else {
            surgicalProductList
              ..clear()
              ..addAll(productRespModel.productList);
          }
        } else if (surgicalPageIndex > 1) {
          surgicalPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getVeterinaryProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '4',
      pageIndex: vetPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            veterinaryProductList.addAll(productRespModel.productList);
          } else {
            veterinaryProductList
              ..clear()
              ..addAll(productRespModel.productList);
          }
        } else if (vetPageIndex > 1) {
          vetPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getAyurvedicProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '5',
      pageIndex: ayurvedicPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            ayurvedicProductList.addAll(productRespModel.productList);
          } else {
            ayurvedicProductList
              ..clear()
              ..addAll(productRespModel.productList);
          }
        } else if (ayurvedicPageIndex > 1) {
          ayurvedicPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
      }
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getGenerallProducts({bool? load}) async {
    if (load == null) prodState = StoreState.LOADING;
    final productRespModel = await _productsRepository.getProducts(
      categoryId: '6',
      pageIndex: generalPageIndex,
    );
    // print(productRespModel!.message);
    if (productRespModel != null) {
      if (productRespModel.message ==
          'product not serviceable in your area !!!') {
        message = 'Products not servicable in your selected area!';
        prodState = StoreState.ERROR;
      } else {
        if (productRespModel.productList.isNotEmpty) {
          if (load != null) {
            generalProductList.addAll(productRespModel.productList);
          } else {
            generalProductList
              ..clear()
              ..addAll(productRespModel.productList);
          }
        } else if (generalPageIndex > 1) {
          generalPageIndex--;
          Fluttertoast.showToast(msg: 'No more products to show');
        }
        prodState = StoreState.SUCCESS;
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
  Future<void> getSearchedResults({required String term, bool? load}) async {
    // print(term);
    if (term.isNotEmpty) {
      if (kDebugMode) {
        print(term);
      }
      if (load == null) searchState = StoreState.LOADING;
      Future.delayed(Duration.zero, () async {
        final productRespModel = await _productsRepository.getProducts(
          term: term,
          pageIndex: searchIndex,
        );
        if (productRespModel != null) {
          if (productRespModel.message == 'successful !!') {
            if (productRespModel.productList.isNotEmpty) {
              if (load != null) {
                searchList
                  ..clear()
                  ..addAll(productRespModel.productList);
              } else {
                searchList.addAll(productRespModel.productList);
              }
            } else if (searchIndex > 1) {
              searchIndex--;
              Fluttertoast.showToast(msg: 'No more products to show');
            }
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
      searchList.clear();
      searchState = StoreState.EMPTY;
    }
  }

  //----------------------------------- Cart ---------------------------------------------------//
  @observable
  CartModel cartModel = CartModel(
    totalSalePrice: '0.0',
    noOfProducts: 0,
    productList: ObservableList<ProductModel>.of([]),
  );

  @action
  Future<void> getCartItems({
    bool? isRemove,
    bool? cartOpt,
  }) async {
    final model = await _productsRepository.getCart();
    if (isRemove != null) {
      cartModel = cartModel.copyWith(
        totalSalePrice: model.totalSalePrice,
        noOfProducts: model.noOfProducts,
      );
    } else {
      // cartModel = model;
      cartModel.copyWith(productList: model.productList);
      final list = ObservableList<ProductModel>.of([]);
      if (cartOpt != null) {
        for (final i in model.productList) {
          final updatedModel = await _updateProductsAccordingToCart(model: i);
          list.add(updatedModel);
        }
        cartModel = model.copyWith(productList: list);
      }
    }

    debugPrint('----- cart total----${cartModel.totalSalePrice}');
  }

  @action
  Future<ProductModel> _updateProductsAccordingToCart(
      {required ProductModel model}) async {
    if (model.subTotal == '0.00') {
      final currModel = model.copyWith(
        subTotal: '0.00',
        totalQtyPrice: '0.00',
        productName: 'Remove the product',
        description: 'Prices have been changes or ',
      );

      return currModel;
    }
    final category = categoriesfromValue(model.category);
    // print(model.cartQuantity);

    switch (category) {
      case CategoriesType.ETHICAL:
        final index = ethicalProductList
            .indexWhere((element) => element.pid == model.pid);
        // final fModel = ethicalProductList.f
        if (index != -1) {
          final cartModel = ethicalProductList[index].copyWith(
              cartQuantity: model.cartQuantity, subTotal: model.subTotal);
          ethicalProductList
            ..removeAt(index)
            ..insert(index, cartModel);
          return cartModel;
        }
        return model;
      // ethicalProductList[index] = cartModel;
      case CategoriesType.GENERIC:
        final index = genericProductList
            .indexWhere((element) => element.pid == model.pid);
        if (index != -1) {
          final cartModel = genericProductList[index].copyWith(
              cartQuantity: model.cartQuantity, subTotal: model.subTotal);
          genericProductList
            ..removeAt(index)
            ..insert(index, cartModel);
          return cartModel;
        }
        return model;
      case CategoriesType.SURGICAL:
        final index = surgicalProductList
            .indexWhere((element) => element.pid == model.pid);
        if (index != -1) {
          final cartModel = surgicalProductList[index].copyWith(
              cartQuantity: model.cartQuantity, subTotal: model.subTotal);
          surgicalProductList
            ..removeAt(index)
            ..insert(index, cartModel);

          return cartModel;
        }
        return model;
      case CategoriesType.VETERINARY:
        final index = veterinaryProductList
            .indexWhere((element) => element.pid == model.pid);
        if (index != -1) {
          final cartModel = veterinaryProductList[index].copyWith(
              cartQuantity: model.cartQuantity, subTotal: model.subTotal);
          veterinaryProductList
            ..removeAt(index)
            ..insert(index, cartModel);
          return cartModel;
        }
        return model;
      case CategoriesType.AYURVEDIC:
        final index = ayurvedicProductList
            .indexWhere((element) => element.pid == model.pid);
        final cartModel = ayurvedicProductList[index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        ayurvedicProductList
          ..removeAt(index)
          ..insert(index, cartModel);
        return cartModel;
      case CategoriesType.GENERAL:
        final index = generalProductList
            .indexWhere((element) => element.pid == model.pid);
        final cartModel = generalProductList[index].copyWith(
            cartQuantity: model.cartQuantity, subTotal: model.subTotal);
        generalProductList
          ..removeAt(index)
          ..insert(index, cartModel);
        return cartModel;
    }
  }

  @action
  Future<void> updateCartQunatity({
    required ProductModel model,
    required String value,
    required BuildContext context,
  }) async {
    SnackBar snackBar;
    print('$value ------- ${model.quantity}');
    if (int.parse(value) > int.parse(model.quantity)) {
      snackBar = ConstantWidget.customSnackBar(
          text: 'Quantity not available', context: context);
    } else if (int.parse(value) <= 0) {
      snackBar = ConstantWidget.customSnackBar(
          text: 'Quantity not available', context: context);
    } else {
      cartTotal(
        totalPrice: double.parse(cartModel.totalSalePrice),
        oldTotal: (double.parse(model.newMrp) * model.cartQuantity!),
        newTotal: (double.parse(model.newMrp) * int.parse(value)),
      );

      final currModel = model.copyWith(
        cartQuantity: int.parse(value),
        subTotal: (double.parse(model.newMrp) * int.parse(value)).toString(),
      );

      final index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(index)
        ..insert(index, currModel);

      await _updateProductsAccordingToCart(model: currModel);

      _productsRepository.updateQuantity(model: currModel);

      snackBar = ConstantWidget.customSnackBar(
          text: 'Qunatity updated', context: context);
      // plusMinusToCart(model: currModel);
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void cartTotal({
    required double totalPrice,
    required double oldTotal,
    required double newTotal,
  }) {
    final total = (totalPrice - oldTotal) + newTotal;
    cartModel = cartModel.copyWith(totalSalePrice: total.toStringAsFixed(2));
  }

  @observable
  StoreState plusState = StoreState.SUCCESS;

  @observable
  StoreState minusRemoveState = StoreState.SUCCESS;

  @observable
  StoreState removeState = StoreState.SUCCESS;

  @action
  Future<void> plusToCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    // plusMinusRemoveState = StoreState.LOADING;
    Stopwatch stopwatch = Stopwatch()..start();
    int qty = model.cartQuantity! + 1;
    if (int.parse(model.quantity) > 0) {
      if (qty > int.parse(model.quantity)) {
        final snackBar = ConstantWidget.customSnackBar(
            text: 'Quantity not available', context: context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        cartTotal(
          totalPrice: double.parse(cartModel.totalSalePrice),
          oldTotal: (double.parse(model.newMrp) * (qty - 1)),
          newTotal: (double.parse(model.newMrp) * qty),
        );

        final currModel = model.copyWith(
          cartQuantity: qty,
          subTotal: (double.parse(model.newMrp) * qty).toString(),
        );

        debugPrint('-----added qty ${currModel.cartQuantity}');

        final index = cartModel.productList
            .indexWhere((element) => element.pid == currModel.pid);
        cartModel.productList
          ..removeAt(index)
          ..insert(index, currModel);

        await _updateProductsAccordingToCart(model: currModel);

        final value = _productsRepository.plusTheCart(model: currModel);
        SnackBar snackBar;
        if (value == null) {
          snackBar = ConstantWidget.customSnackBar(
            text: 'Failed to update the cart',
            context: context,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        stopwatch.stop();
        if (kDebugMode) {
          print('plus cart seconds ${stopwatch.elapsedMilliseconds}');
        }
        // plusMinusToCart(model: currModel);
      }
    }

    // plusMinusRemoveState = StoreState.SUCCESS;
  }

  @action
  Future<void> minusToCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    final stopWatch = Stopwatch()..start();
    SnackBar snackBar;
    if (model.cartQuantity! > 1) {
      int qty = model.cartQuantity! - 1;
      cartTotal(
        totalPrice: double.parse(cartModel.totalSalePrice),
        oldTotal: (double.parse(model.newMrp) * (qty + 1)),
        newTotal: (double.parse(model.newMrp) * qty),
      );

      final currModel = model.copyWith(
        cartQuantity: qty,
        subTotal: (double.parse(model.newMrp) * qty).toString(),
      );
      final index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(index)
        ..insert(index, currModel);

      await _updateProductsAccordingToCart(model: currModel);

      final value = _productsRepository.minusTheCart(model: currModel);
      if (value == null) {
        snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to update the cart',
          context: context,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      stopWatch.stop();
      print('subtract seconds ------ ${stopWatch.elapsedMilliseconds}');
    } else if (model.cartQuantity == 1) {
      await removeFromCart(
        model: model,
        context: context,
      );
      snackBar = ConstantWidget.customSnackBar(
        text: 'Removed from cart',
        context: context,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      snackBar = ConstantWidget.customSnackBar(
          text: 'Quantity not available', context: context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @action
  Future<void> addToCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    if (int.parse(model.quantity) > 0) {
      final stopWatch = Stopwatch()..start();

      int qty = 1;

      cartTotal(
        totalPrice: double.parse(cartModel.totalSalePrice),
        oldTotal: 0.0,
        newTotal: double.parse(model.newMrp) * qty,
      );
      final currModel = model.copyWith(
        cartQuantity: qty,
        subTotal: (double.parse(model.newMrp) * qty).toString(),
      );

      cartModel.productList.add(currModel);
      await _updateProductsAccordingToCart(model: currModel);

      _productsRepository.addToCart(model: currModel);
      // await getCartItems();
      print(cartModel.totalSalePrice);
      stopWatch.stop();
      print('adding to cart --- ${stopWatch.elapsedMilliseconds}');
    } else {
      final snackBar = ConstantWidget.customSnackBar(
        text: 'Product quantity not available',
        context: context,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @action
  Future<void> removeFromCart({
    required ProductModel model,
    required BuildContext context,
  }) async {
    cartTotal(
      totalPrice: double.parse(cartModel.totalSalePrice),
      oldTotal: (double.parse(model.newMrp) * model.cartQuantity!),
      newTotal: 0.00,
    );

    final currModel = model.copyWith(
      cartQuantity: 0,
      subTotal: 0.00.toString(),
    );
    final index = cartModel.productList
        .indexWhere((element) => element.pid == currModel.pid);
    cartModel.productList.removeAt(index);

    await _updateProductsAccordingToCart(model: currModel);

    // await getCartItems(isRemove: true);
    if (index != -1) {
      final value = _productsRepository.removeFromCart(model: model);
      SnackBar snackBar;
      if (value != null) {
        snackBar = ConstantWidget.customSnackBar(
          text: 'Removed from cart',
          context: context,
        );
      } else {
        snackBar = ConstantWidget.customSnackBar(
          text: 'Failed to remove from cart',
          context: context,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //----------------------------------- Checkout ----------------------------------------------//
  @observable
  PaymentOptions paymentOptions = PaymentOptions.PAYONDELIVERY;

  @observable
  String orderId = '';

  @observable
  String payableAmount = '';

  @action
  Future<String> checkout({required BuildContext context}) async {
    String ans = '';
    checkoutState = StoreState.LOADING;
    SnackBar snackBar = ConstantWidget.customSnackBar(
      text: 'Failure, order not successful',
      context: context,
    );
    debugPrint('---- before checkout -----------${cartModel.totalSalePrice}');
    final payLater = (paymentOptions == PaymentOptions.PAYLATER) ? '2' : '1';
    final value = await _productsRepository.checkout(
        amount: cartModel.totalSalePrice, payLater: payLater);

    payableAmount = cartModel.totalSalePrice;

    if (value != null) {
      orderId = value;
      snackBar = ConstantWidget.customSnackBar(
        text: 'Successful, checkout',
        context: context,
      );
      ans = value;
    }
    await getCartItems();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    checkoutState = StoreState.SUCCESS;

    return ans;
    // return value;
    //   },
    // );

    // return '';
    //   },
    // );
  }

  @action
  Future<String> confirmCheckout({
    required BuildContext context,
    String? orderId,
  }) async {
    // String status;
    checkoutState = StoreState.LOADING;

    if (kDebugMode) {
      print('------ order check -------$orderId');
    }

    String confirm = '';

    if (orderId != null) {
      int payStatus = 1;
      //----------- Payment confirmation -----------------------------
      if (paymentOptions == PaymentOptions.ONLINE) {
        payStatus =
            await _productsRepository.paymentConfirmation(orderId: orderId);
        if (kDebugMode) {
          print('------ payment check -------$payStatus');
        }

        if (payStatus == 1) {
          // print('options ---------${paymentOptions.toPaymentOption()}');
          final snackBar = ConstantWidget.customSnackBar(
            text: 'Your payment has been confirmed',
            context: context,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = ConstantWidget.customSnackBar(
            text:
                'Failed to process the payment, we will confirm the order soon',
            context: context,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }

      //---------- Confirm Checkout -----------------------------
      if (payStatus == 1) {
        final confirmValue = await _productsRepository.checkoutConfirm(
          orderId: orderId,
          paymentOptionsType: paymentOptions,
        );
        if (kDebugMode) {
          print('------ confirm checkout check -------$confirmValue');
        }

        if (confirmValue != '') {
          confirm = confirmValue;
        }
        return confirmValue;
      }
    }
    checkoutState = StoreState.SUCCESS;

    return confirm;
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
    // required String orderId,
  }) async {
    checkoutState = StoreState.LOADING;
    await loginStore.getUserStatus();

    if (!loginStore.loginModel.adminStatus) {
      final snackBar = ConstantWidget.customSnackBar(
          text: 'Your account has been deactivated', context: context);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final status = await confirmCheckout(
        context: context,
        orderId: orderId,
      );

      if (status != '') {
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
        checkoutState = StoreState.SUCCESS;
      }
    }

    // checkoutState = StoreState.SUCCESS;
  }
}

// extension MyToast on Fluttertoast {
//   Future<bool?> myFlutterToast({
//     required String msg,
//   }) {
//     return Fluttertoast.showToast(
//       msg: msg,
//       fontSize: 15,
//     );
//   }
// }
