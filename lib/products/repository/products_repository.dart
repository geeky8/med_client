import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/enums/payment_options.dart';
import 'package:medrpha_customer/products/models/cart_model.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';

class ProductResponseModel {
  ProductResponseModel({
    required this.message,
    required this.productList,
  });

  factory ProductResponseModel.fromJson(
      {required String message, required List<ProductModel> productList}) {
    return ProductResponseModel(
      message: message,
      productList: productList,
    );
  }

  ProductResponseModel copyWith(
      {String? message, List<ProductModel>? productList}) {
    return ProductResponseModel(
      message: message ?? this.message,
      productList: productList ?? this.productList,
    );
  }

  final List<ProductModel> productList;
  final String message;
}

class ProductsRepository {
  //---------------------------------------------- Products --------------------------------------------------//
  //TODO: Change API to test or prod.

  final _categoryUrl = 'https://api.medrpha.com/api/product/getcategory';
  // final _categoryUrl = 'https://apitest.medrpha.com/api/product/getcategory';
  final _productsUrl = 'https://api.medrpha.com/api/product/productlist';
  // final _productsUrl = 'https://apitest.medrpha.com/api/product/productlist';
  final _productDetailsUrl =
      'https://api.medrpha.com/api/product/productdetails';
  // final _productDetailsUrl =
  //     'https://apitest.medrpha.com/api/product/productdetails';

  Future<List<CategoryModel>> getCategories() async {
    final catlist = <CategoryModel>[];
    final sessId = await DataBox().readSessId();
    final body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": sessId,
    };
    final resp = await _httpClient.post(Uri.parse(_categoryUrl), body: body);

    if (kDebugMode) {
      print('category resp -----------${resp.body}');
    }

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          final model = CategoryModel.fromJson(json: i);
          catlist.add(model);
        }
      }
    }
    return catlist;
  }

  Future<ProductResponseModel?> getProducts({
    String? categoryId,
    bool? refresh,
    String? term,
    int? pageIndex,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();

    final productlist = <ProductModel>[];
    final sessId = await DataBox().readSessId();
    final body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": sessId,
      "term": term ?? '',
      "catcheck": categoryId ?? '',
      "PageIndex": (pageIndex ?? '1').toString(),
      "PageSize": '16'
    };

    final resp = await _httpClient.post(Uri.parse(_productsUrl), body: body);

    debugPrint('--- prod resp ---------${resp.body}');

    if (term != null) {}
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print('Message ---------------------${respBody['message']}');
      ProductResponseModel productRespModel = ProductResponseModel.fromJson(
        message: respBody['message'] as String,
        productList: [],
      );
      if (respBody['message'] == 'successful !!') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          // print(i);
          final model = ProductModel.fromJson(json: i);
          // print(model.pid);
          // final updatedModel =
          //     await _getProductDetails(model: model, sessId: sessId);

          productlist.add(model);
        }
        debugPrint('------products lenght ${productlist.length}');
        productRespModel = productRespModel.copyWith(productList: productlist);
        // print('lenght ---${productRespModel.productList.length}');
      }
      stopwatch.stop();
      if (kDebugMode) {
        print('time taken by products ---- ${stopwatch.elapsedMilliseconds}');
      }
      return productRespModel;
    }
    return null;
  }

  Future<ProductModel> getProductDetails({
    required ProductModel model,
    required String sessId,
  }) async {
    final body = {
      "sessid": sessId,
      "pid": model.pid,
      "price_id": model.priceId
    };

    ProductModel currModel = model;

    final resp =
        await _httpClient.post(Uri.parse(_productDetailsUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final data = respBody['data'] as Map<String, dynamic>;
        // print(_data);
        currModel = model.copyWith(
          expiryDate: data['dtExpiryDate'] as String,
          description: data['Description'] as String,
          productName: data['product_name'] as String,
          productImg: data['product_img'] as String,
          prodSaleTypeDetails: data['prodsaletypedetails'] as String,
          company: data['compnaystr'] as String,
          category: data['categorystr'] as String,
        );
      }
    }
    return currModel;
  }

  final _httpClient = http.Client();

//------------------------------------------------ Cart -----------------------------------------//
  //TODO: Change API to test or prod.

  final _updateProductQuantityUrl =
      'https://api.medrpha.com/api/cart/updatequantity';
  // final _updateProductQuantityUrl =
  //     'https://apitest.medrpha.com/api/cart/updatequantity';
  final _addToCartUrl = 'https://api.medrpha.com/api/cart/addtocart';
  // final _addToCartUrl = 'https://apitest.medrpha.com/api/cart/addtocart';
  final _getCartUrl = 'https://api.medrpha.com/api/cart/viewcart';
  // final _getCartUrl = 'https://apitest.medrpha.com/api/cart/viewcart';
  final _removeCartUrl = 'https://api.medrpha.com/api/cart/deletecart';
  // final _removeCartUrl = 'https://apitest.medrpha.com/api/cart/deletecart';

  final _plusCart = 'https://api.medrpha.com/api/cart/cartplus';
  // final _plusCart = 'https://apitest.medrpha.com/api/cart/cartplus';
  final _minusCart = 'https://api.medrpha.com/api/cart/cartminus';
  // final _minusCart = 'https://apitest.medrpha.com/api/cart/cartminus';

  Future<int?> plusTheCart({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "quantity": model.quantity
    };

    final resp = await _httpClient.post(Uri.parse(_plusCart), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      if (respBody['status'] == '1') {
        return 1;
      }
    }
    return null;
  }

  Future<int?> minusTheCart({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
      "pid": model.pid,
      "priceID": model.priceId,
    };

    final resp = await _httpClient.post(Uri.parse(_minusCart), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);

      if (respBody['status'] == '1') {
        return 1;
      }
    }
    return null;
  }

  Future<int?> updateQuantity({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();

    final body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "quantity": model.quantity,
      "qtyfield": model.cartQuantity.toString(),
    };

    final resp = await _httpClient.post(Uri.parse(_updateProductQuantityUrl),
        body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        return 1;
      }
    }
    return null;
  }

  Future<int?> addToCart({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();

    final body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "WPID": model.wpid,
      "saleprice": model.salePrice,
    };

    final resp = await _httpClient.post(Uri.parse(_addToCartUrl), body: body);

    // print('------ add to cart${resp.body}');

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      if (respBody['status'] == '1') {
        return 1;
      }
    }
    return null;
  }

  Future<int?> removeFromCart({required ProductModel model}) async {
    final sessId = await DataBox().readSessId();

    final body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": sessId,
      "pid": model.pid,
      "priceID": model.priceId
    };

    final resp = await _httpClient.post(Uri.parse(_removeCartUrl), body: body);

    debugPrint('------ removal from cart -------${resp.body}');

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);

      if (respBody['status'] == '1') {
        return 1;
      }
    }

    return null;
  }

  Future<CartModel> getCart() async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
      // "sessid": sessId,
    };

    final prodList = ObservableList<ProductModel>.of([]);
    int count = 0;
    String total = '';

    final resp = await _httpClient.post(Uri.parse(_getCartUrl), body: body);

    if (kDebugMode) {
      print('------ get cart${resp.body}');
    }

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      debugPrint('------getCart--------${resp.body}');
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        count = int.parse(respBody['count'] as String);
        // print("$count ");
        total = (respBody['final'] as String);
        // print('Total Cart : $total');
        for (final i in list) {
          // print(i['quantity'] + 'cart');
          final model = ProductModel.fromJson(
            json: i,
          );
          // print(model.cartQuantity.toString() + 'cartAdded');

          prodList.add(model);
        }
      }
    }
    return CartModel(
        totalSalePrice: total, noOfProducts: count, productList: prodList);
  }

  //------------------- ----------------Checkout ------------------------------------------------------//
  //TODO: Change API to test or prod.

  final _checkoutUrl = 'https://medrpha.com/api/checkout/checkout';
  // final _checkoutUrl = 'https://test.medrpha.com/api/checkout/checkout';
  final _ordersPayment = 'https://api.razorpay.com/v1/orders';
  final _paymentConfirmUrl = 'https://medrpha.com/api/order/payconfirmed';
  // final _paymentConfirmUrl =
  //     'https://apitest.medrpha.com/api/order/payconfirmed';
  final _checkoutConfirmUrl =
      'https://medrpha.com/api/checkout/checkoutconfirm';
  // final _checkoutConfirmUrl =
  //     'https://test.medrpha.com/api/checkout/checkoutconfirm';

  Future<String?> checkout({
    required String amount,
    required String payLater,
  }) async {
    final sessId = await DataBox().readSessId();

    final body = {
      "sessid": sessId,
      "paymode": "1",
      "final": amount,
      "paylater": payLater
    };

    if (kDebugMode) {
      print(body.toString());
    }

    final resp = await _httpClient.post(Uri.parse(_checkoutUrl), body: body);

    if (kDebugMode) {
      print('------ checkout${resp.body}');
    }

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print('---------- checkout ${respBody}');
      if (respBody['status'] == '1') {
        return respBody['order_id'] as String;
      } else {
        Fluttertoast.showToast(msg: respBody['message'] as String);
      }
    }
    return null;
  }

  Future<String> checkoutConfirm({
    required String orderId,
    required PaymentOptions paymentOptionsType,
  }) async {
    final sessId = await DataBox().readSessId();
    final body = {
      "sessid": sessId,
      "order_id": orderId,
      "payment_mode": paymentOptionsType.toPaymentOption()
    };

    String confirm = '';

    final resp =
        await _httpClient.post(Uri.parse(_checkoutConfirmUrl), body: body);
    if (kDebugMode) {
      print('---------- Confirm checkout ---------- ${resp.body}');
    }
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      if (respBody['status'] == '1') {
        confirm = respBody['order_id'] as String;
      }
    }
    return confirm;
  }

  Future<int> paymentConfirmation({required String orderId}) async {
    final sessId = await DataBox().readSessId();
    final body = {"sessid": sessId, "order_id": orderId};
    int status = 0;

    final resp =
        await _httpClient.post(Uri.parse(_paymentConfirmUrl), body: body);

    print('--------Payement resp ${resp.body}');

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      if (respBody['status'] == '1') {
        status = 1;
      }
    }

    return status;
  }

  Future<String> createOrder({
    required String payment,
    required int noOfProducts,
  }) async {
    final userName = ConstantData.apiKey;
    final pass = ConstantData.apiSecretKey;

    final basicAuth = 'Basic ${base64Encode(utf8.encode('$userName:$pass'))}';

    final body = jsonEncode({
      "amount": payment * 100,
      "currency": "INR",
      "receipt": "rcptid_$noOfProducts"
    });

    final headers = {
      'Content-Type': 'application/json',
      'authorization': basicAuth,
    };

    final resp = await http.post(
      Uri.parse(_ordersPayment),
      headers: headers,
      body: body,
    );

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      final id = respBody['id'] as String;
      return id;
    } else {
      return '';
    }
  }
}
