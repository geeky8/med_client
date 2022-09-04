import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:medrpha_customer/enums/delivery_status_type.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:http/http.dart' as http;

class OrderHistoryRepository {
  final _httpClient = http.Client();

  // final _orderUrl = 'https://api.medrpha.com/api/order/orderlist';
  final _orderUrl = 'https://apitest.medrpha.com/api/order/orderlist';
  // final _ordersListUrl = 'https://api.medrpha.com/api/order/orderdetail';
  final _ordersListUrl = 'https://apitest.medrpha.com/api/order/orderdetail';
  // final _cancelOrderUrl = 'https://api.medrpha.com/api/order/ordercancel';
  final _cancelOrderUrl = 'https://apitest.medrpha.com/api/order/ordercancel';

  Future<List<OrderHistoryModel>> getListOrdersHistory(
      {String? fromDate, String? toDate, String? orderNo}) async {
    final list = <OrderHistoryModel>[];
    final sessId = await DataBox().readSessId();

    final body = {
      "orderno": orderNo ?? "",
      "FromDate": fromDate ?? "",
      "ToDate": toDate ?? "",
      "sessid": sessId,
    };

    final resp = await _httpClient.post(Uri.parse(_orderUrl), body: body);
    // print('------ history model ${_resp.body}');
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody['status'] == '1') {
        final data = respBody['data'] as List<dynamic>;
        for (final i in data) {
          final model =
              OrderHistoryModel.fromJson(json: i as Map<String, dynamic>);

          final ordersResponse = await getOrdersResponseModel(
            sessId: sessId,
            orderId: model.orderId,
          );

          OrderHistoryModel orderModel = model.copyWith(
            ordersList: ordersResponse.productList,
          );

          if (i['order_status'] == 'Placed') {
            if (model.deliveredDate != '') {
              orderModel = orderModel.copyWith(
                  orderStatusType: OrderStatusType.DELIVERED);
            } else if (model.dispatchedDate != '') {
              orderModel = orderModel.copyWith(
                  orderStatusType: OrderStatusType.DISPATCHED);
            } else {
              orderModel = orderModel.copyWith(
                  orderStatusType: OrderStatusType.CONFIRMED);
            }
          } else {
            orderModel =
                orderModel.copyWith(orderStatusType: OrderStatusType.CANCELLED);
          }
          list.add(orderModel);
        }
      }
    }
    return list;
  }

  Future<OrderHistoryResponseModel> getOrdersResponseModel({
    String? sessId,
    required String orderId,
  }) async {
    final sessId = await DataBox().readSessId();
    final body = {"sessid": sessId, "order_id": orderId};

    final resp = await _httpClient.post(Uri.parse(_ordersListUrl), body: body);

    OrderHistoryResponseModel responseModel = OrderHistoryResponseModel(
      productList: [],
      orderNo: '',
      orderDateTime: '',
    );

    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      // print('----------- history products ---------${resp.body}');
      if (respBody['status'] == '1') {
        final data = respBody['data'] as List<dynamic>;
        final list = <ProductModel>[];

        for (final i in data) {
          // print('----------${i}');
          final model = ProductModel.fromJson(json: i as Map<String, dynamic>);
          list.add(model);
        }

        // print('----------${_list.length}');

        responseModel = responseModel.copyWith(
          productList: list,
          orderNo: (respBody['order_no'] ?? '') as String,
          orderDateTime: (respBody['order_datetime'] ?? '') as String,
        );
      }
    }
    return responseModel;
  }

  Future<int?> cancelOrder({required String id, required String text}) async {
    final sessId = await DataBox().readSessId();
    final body = {"sessid": sessId, "order_id": id, "remarks": text};

    final resp = await _httpClient.post(Uri.parse(_cancelOrderUrl), body: body);
    if (kDebugMode) {
      print('cancel order ---------------- ${resp.body}');
    }
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      if (respBody['status'] == '1') {
        return 1;
      }
    }
    // print(resp.body);
    return null;
  }
}

class OrderHistoryResponseModel {
  OrderHistoryResponseModel({
    required this.productList,
    required this.orderNo,
    required this.orderDateTime,
  });

  final List<ProductModel> productList;
  final String orderNo;
  final String orderDateTime;

  OrderHistoryResponseModel copyWith({
    List<ProductModel>? productList,
    String? orderNo,
    String? orderDateTime,
  }) {
    return OrderHistoryResponseModel(
      productList: productList ?? this.productList,
      orderNo: orderNo ?? this.orderNo,
      orderDateTime: orderDateTime ?? this.orderDateTime,
    );
  }
}
