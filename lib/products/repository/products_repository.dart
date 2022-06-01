import 'dart:convert';

import 'package:medrpha_customer/products/models/cart_model.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';

class ProductsRepository {
  final _categoryUrl = 'https://apitest.medrpha.com/api/product/getcategory';
  final _productsUrl = 'https://apitest.medrpha.com/api/product/productlist';
  final _updateProductQuantityUrl =
      'https://apitest.medrpha.com/api/cart/updatequantity';
  final _addToCartUrl = 'https://apitest.medrpha.com/api/cart/addtocart';
  final _getCartUrl = 'https://apitest.medrpha.com/api/cart/viewcart';
  final _removeCartUrl = 'https://apitest.medrpha.com/api/cart/deletecart';
  final _productDetailsUrl =
      'https://apitest.medrpha.com/api/product/productdetails';

  final _httpClient = http.Client();

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

  Future<List<ProductModel>> getProducts({required String categoryId}) async {
    final productlist = <ProductModel>[];
    final _sessId = await DataBox().readSessId();
    final _body = {
      // "sessid": "34c4efad30e6e2d4",
      "sessid": _sessId,
      "term": '',
      "catcheck": '',
    };

    final resp = await _httpClient.post(Uri.parse(_productsUrl), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        for (final i in list) {
          final model = ProductModel.fromJson(json: i);

          final updatedModel =
              await _getProductDetails(model: model, sessId: _sessId);

          productlist.add(updatedModel);
        }
      }
    }
    return productlist;
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
      print(respBody);
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
      print(respBody);
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
    double total = 0;

    final resp = await _httpClient.post(Uri.parse(_getCartUrl), body: _body);

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      print(respBody);
      if (respBody['status'] == '1') {
        final list = respBody['data'] as List<dynamic>;
        count = int.parse(respBody['count'] as String);
        print("$count ");
        total = double.parse(respBody['final'] as String);
        for (final i in list) {
          final model = ProductModel.fromJson(json: i);
          prodList.add(model);
        }
      }
    }
    return CartModel(
        totalSalePrice: total, noOfProducts: count, productList: prodList);
  }
}
