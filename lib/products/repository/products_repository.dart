import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
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
  final _categoryUrl = 'https://apitest.medrpha.com/api/product/getcategory';
  final _productsUrl = 'https://apitest.medrpha.com/api/product/productlist';
  final _productDetailsUrl =
      'https://apitest.medrpha.com/api/product/productdetails';

  Future<List<CategoryModel>> getCategories() async {
    final catlist = <CategoryModel>[];
    final _sessId = await DataBox().readSessId();
    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
    };
    final resp = await _httpClient.post(Uri.parse(_categoryUrl), body: _body);

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

  Future<ProductResponseModel?> getProducts(
      {String? categoryId, bool? refresh, String? term}) async {
    final productlist = <ProductModel>[];
    final _sessId = await DataBox().readSessId();
    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
      "term": term ?? '',
      "catcheck": categoryId ?? '',
    };

    final resp = await _httpClient.post(Uri.parse(_productsUrl), body: _body);
    // print('body :${resp.body}');

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
          final updatedModel =
              await _getProductDetails(model: model, sessId: _sessId);

          productlist.add(updatedModel);
        }
        productRespModel = productRespModel.copyWith(productList: productlist);
        // print('lenght ---${productRespModel.productList.length}');
      }
      return productRespModel;
    }
  }

  Future<ProductModel> _getProductDetails({
    required ProductModel model,
    required String sessId,
  }) async {
    final _body = {
      "sessid": sessId,
      "pid": model.pid,
      "price_id": model.priceId
    };

    ProductModel _currModel = model;

    final resp =
        await _httpClient.post(Uri.parse(_productDetailsUrl), body: _body);

    if (resp.statusCode == 200) {
      final _respBody = jsonDecode(resp.body);
      if (_respBody['status'] == '1') {
        final _data = _respBody['data'] as Map<String, dynamic>;
        // print(_data);
        _currModel = model.copyWith(
          expiryDate: _data['dtExpiryDate'] as String,
          description: _data['Description'] as String,
          productName: _data['product_name'] as String,
          productImg: _data['product_img'] as String,
          prodSaleTypeDetails: _data['prodsaletypedetails'] as String,
          company: _data['compnaystr'] as String,
          category: _data['categorystr'] as String,
        );
      }
    }
    return _currModel;
  }

  final _httpClient = http.Client();

//------------------------------------------------ Cart -----------------------------------------//

  final _updateProductQuantityUrl =
      'https://apitest.medrpha.com/api/cart/updatequantity';
  final _addToCartUrl = 'https://apitest.medrpha.com/api/cart/addtocart';
  final _getCartUrl = 'https://apitest.medrpha.com/api/cart/viewcart';
  final _removeCartUrl = 'https://apitest.medrpha.com/api/cart/deletecart';

  final _plusCart = 'https://apitest.medrpha.com/api/cart/cartplus';
  final _minusCart = 'https://apitest.medrpha.com/api/cart/cartminus';

  Future<void> plusTheCart({required ProductModel model}) async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      "sessid": _sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "quantity": model.quantity
    };

    final resp = await _httpClient.post(Uri.parse(_plusCart), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      // if (respBody['status'] == '1') {
      //   final list = respBody['data'] as List<dynamic>;
      //   for (final i in list) {
      //     final model = ProductModel.fromJson(json: i);
      //     productlist.add(model);
      //   }
      // }
    }
  }

  Future<void> minusTheCart({required ProductModel model}) async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      "sessid": _sessId,
      "pid": model.pid,
      "priceID": model.priceId,
    };

    final resp = await _httpClient.post(Uri.parse(_minusCart), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      // if (respBody['status'] == '1') {
      //   final list = respBody['data'] as List<dynamic>;
      //   for (final i in list) {
      //     final model = ProductModel.fromJson(json: i);
      //     productlist.add(model);
      //   }
      // }
    }
  }

  Future<void> updateQuantity({required ProductModel model}) async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "quantity": model.quantity,
      "qtyfield": model.cartQuantity.toString(),
    };

    final resp = await _httpClient.post(Uri.parse(_updateProductQuantityUrl),
        body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      // if (respBody['status'] == '1') {
      //   final list = respBody['data'] as List<dynamic>;
      //   for (final i in list) {
      //     final model = ProductModel.fromJson(json: i);
      //     productlist.add(model);
      //   }
      // }
    }
  }

  Future<void> addToCart({required ProductModel model}) async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
      "pid": model.pid,
      "priceID": model.priceId,
      "WPID": model.wpid,
      "saleprice": model.salePrice,
    };

    final resp = await _httpClient.post(Uri.parse(_addToCartUrl), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      // if (respBody['status'] == '1') {
      //   final list = respBody['data'] as List<dynamic>;
      //   for (final i in list) {
      //     final model = ProductModel.fromJson(json: i);
      //     productlist.add(model);
      //   }
      // }
    }
  }

  Future<void> removeFromCart({required ProductModel model}) async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
      "pid": model.pid,
      "priceID": model.priceId
    };

    final resp = await _httpClient.post(Uri.parse(_removeCartUrl), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      // if (respBody['status'] == '1') {
      //   final list = respBody['data'] as List<dynamic>;
      //   for (final i in list) {
      //     final model = ProductModel.fromJson(json: i);
      //     productlist.add(model);
      //   }
      // }
    }
  }

  Future<CartModel> getCart() async {
    final _sessId = await DataBox().readSessId();

    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
    };

    final prodList = ObservableList<ProductModel>.of([]);
    int count = 0;
    String total = '';

    final resp = await _httpClient.post(Uri.parse(_getCartUrl), body: _body);

    // print(resp.body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
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

  final _checkoutUrl = 'https://test.medrpha.com/api/checkout/checkout';
  final _ordersPayment = 'https://api.razorpay.com/v1/orders';
  final _paymentConfirmUrl =
      'https://apitest.medrpha.com/api/order/payconfirmed';
  final _checkoutConfirmUrl =
      'https://test.medrpha.com/api/checkout/checkoutconfirm';

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

    // print(_body.toString());

    final resp = await _httpClient.post(Uri.parse(_checkoutUrl), body: body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      // print(respBody);
      if (respBody['status'] == '1') {
        return respBody['order_id'] as String;
      }
    }
  }

  Future<String?> checkoutConfirm({
    required String orderId,
    required PaymentOptions paymentOptionsType,
  }) async {
    final sessId = await DataBox().readSessId();
    final body = {
      "sessid": sessId,
      "order_id": orderId,
      "payment_mode": paymentOptionsType.toPaymentOption()
    };

    final resp =
        await _httpClient.post(Uri.parse(_checkoutConfirmUrl), body: body);
    print('---------- Confirm checkout ---------- ${resp.body}');
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      if (respBody['status'] == '1') {
        return (respBody['order_id'] as String);
      }
    }
  }

  Future<int> paymentConfirmation({required String orderId}) async {
    final sessId = await DataBox().readSessId();
    final body = {"sessid": sessId, "order_id": orderId};
    int status = 0;

    final resp =
        await _httpClient.post(Uri.parse(_paymentConfirmUrl), body: body);

    // print('--------Payement resp ${resp.body}');

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

  //------------------------- Searching -------------------------------------------------//
  // Future<> getSearchedResults()async{}

// var options = {
//       'key': 'rzp_test_DgTJRx7VR36Tvl',
//       'amount':
//           double.parse((orderDetailsController.order_amount as String)) * 100,
//       'name': 'Mederpha',
//       'description': 'Online Medical Hub',
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {
//         'contact': cs.customer.value.phoneno,
//         'email': cs.customer.value.txtemail,
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
}
