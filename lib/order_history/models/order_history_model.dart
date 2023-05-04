import 'package:flutter/material.dart';
import 'package:medrpha_customer/enums/order_status_type.dart';
import 'package:medrpha_customer/enums/payment_status_type.dart';
import 'package:medrpha_customer/products/models/products_model.dart';

class OrderHistoryModel {
  OrderHistoryModel({
    required this.orderId,
    required this.orderNo,
    required this.orderAmount,
    required this.placedDateTime,
    required this.paymentStatusType,
    required this.ordersList,
    required this.orderStatus,
    required this.dispatchedDate,
    required this.deliveredDate,
    required this.roundValTotal,
    required this.orderStatusType,
    required this.isView,
  });

  factory OrderHistoryModel.fromJson({required Map<String, dynamic> json}) {
    debugPrint('------- order status ----- $json ------------');

    return OrderHistoryModel(
      orderId: (json['order_id'] ?? '') as String,
      orderNo: (json['order_no'] ?? '') as String,
      orderAmount: (json['order_amount'] ?? '') as String,
      placedDateTime: (json['Placed_Date'] ?? '') as String,
      paymentStatusType:
          paymentStatusFromValue((json['payment_status'] ?? '') as String),
      ordersList: [],
      orderStatus: (json['order_status'] ?? '') as String,
      dispatchedDate: (json['Dispatched_Date'] ?? '') as String,
      deliveredDate: (json['Delivered_Date'] ?? '') as String,
      roundValTotal: (json['roundvaltotal'] ?? '') as String,
      orderStatusType: orderStatusFromValue(json['order_status'] as String),
      isView: false,
    );
  }

  OrderHistoryModel copyWith({
    String? orderId,
    String? orderNo,
    String? orderAmount,
    String? placedDateTime,
    PaymentStatusType? paymentStatusType,
    List<ProductModel>? ordersList,
    String? orderStatus,
    String? dispatchedDate,
    String? deliveredDate,
    String? roundValTotal,
    OrderStatusType? orderStatusType,
    bool? isView,
  }) {
    return OrderHistoryModel(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      orderAmount: orderAmount ?? this.orderAmount,
      placedDateTime: placedDateTime ?? this.placedDateTime,
      paymentStatusType: paymentStatusType ?? this.paymentStatusType,
      ordersList: ordersList ?? this.ordersList,
      orderStatus: orderStatus ?? this.orderStatus,
      dispatchedDate: dispatchedDate ?? this.dispatchedDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      roundValTotal: roundValTotal ?? this.roundValTotal,
      orderStatusType: (orderStatusType ?? this.orderStatusType),
      isView: isView ?? this.isView,
    );
  }

  final String orderId;
  final String orderAmount;
  final String orderNo;
  final String placedDateTime;
  final String dispatchedDate;
  final String deliveredDate;
  final String orderStatus;
  final String roundValTotal;
  final PaymentStatusType paymentStatusType;
  List<ProductModel>? ordersList;
  final OrderStatusType orderStatusType;
  final bool isView;
}
