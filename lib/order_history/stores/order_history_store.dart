// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/enums/delivery_status_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/order_history/repository/order_history_repository.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:mobx/mobx.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

part 'order_history_store.g.dart';

class OrderHistoryStore = _OrderHistoryStore with _$OrderHistoryStore;

abstract class _OrderHistoryStore with Store {
  final _orderHistoryRepository = OrderHistoryRepository();

  @observable
  StoreState state = StoreState.SUCCESS;

  @observable
  ObservableList<OrderHistoryModel> orders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> dispatchedOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> deliveredOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  OrderStatusType viewOrdersStatusType = OrderStatusType.CONFIRMED;

  @action
  Future<void> updateTheOrdersState({required OrderHistoryModel model}) async {
    final index =
        orders.indexWhere((element) => element.orderId == model.orderId);
    final updateModel = model.copyWith(isView: !model.isView);
    orders
      ..removeAt(index)
      ..insert(index, updateModel);
  }

  @action
  Future<void> getOrdersList() async {
    state = StoreState.LOADING;
    final list = await _orderHistoryRepository.getListOrdersHistory();
    // print(
    //     '---------- order history resp -------------->${_list.first.ordersList.length}');
    if (list.isNotEmpty) {
      orders
        ..clear()
        ..addAll(list);
      // dispatchedOrders.clear();
      // deliveredOrders.clear();
      // for (final model in orders) {
      //   if (model.dispatchedDate != '' && model.deliveredDate == '') {
      //     final _currModel =
      //         model.copyWith(deliveryStatusType: DeliveryStatusType.DISPATCHED);
      //     dispatchedOrders.add(_currModel);
      //     // final _index =
      //     //     orders.indexWhere((element) => element.orderId == model.orderId);
      //     // orders.removeAt(_index);
      //   } else if (model.dispatchedDate != '' && model.deliveredDate != '') {
      //     final _currModel =
      //         model.copyWith(deliveryStatusType: DeliveryStatusType.DELIVERED);
      //     deliveredOrders.add(_currModel);
      //     // final _index =
      //     //     orders.indexWhere((element) => element.orderId == model.orderId);
      //     // orders.removeAt(_index);
      //   }
      // }
    }
  }

  @observable
  StoreState invoiceDwdState = StoreState.SUCCESS;

  @action
  Future<void> downloadInvoice({
    required String invoice,
    required BuildContext context,
  }) async {
    final url = '${ConstantData.invoiceUrl}$invoice.pdf';

    final status = await Permission.storage.status;
    // final persmissionStatus = await [Permission.storage].request();
    if (status.isGranted || status.isLimited) {
      invoiceDwdState = StoreState.LOADING;
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        final savename = "medrpha_$invoice.pdf";
        final savePath = "${dir.path}/$savename";

        if (File(savePath).existsSync()) {
          invoiceDwdState = StoreState.SUCCESS;
          final snackBar = SnackBar(
            content: Row(
              children: [
                ConstantWidget.getTextWidget(
                  'Invoice already downloaded',
                  ConstantData.bgColor,
                  TextAlign.left,
                  FontWeight.w600,
                  font18Px(context: context),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    await OpenFilex.open(savePath);
                  },
                  child: Text(
                    'open',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: font18Px(context: context),
                      color: Colors.blue,
                      fontFamily: ConstantData.fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // print(savePath);

          try {
            Future.delayed(const Duration(seconds: 1), () async {
              await Dio().download(url, savePath,
                  onReceiveProgress: (received, total) {
                if (total != -1) {
                  // print((received / total * 100).toStringAsFixed(0) + "%");
                  //you can build progressbar feature too
                }
              });

              invoiceDwdState = StoreState.SUCCESS;

              final snackBar = SnackBar(
                content: Row(
                  children: [
                    ConstantWidget.getTextWidget(
                      'Invoice downloaded successfully',
                      ConstantData.bgColor,
                      TextAlign.left,
                      FontWeight.w600,
                      font18Px(context: context),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        await OpenFilex.open(savePath);
                      },
                      child: Text(
                        'open',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: font18Px(context: context),
                          color: ConstantData.bgColor,
                          fontFamily: ConstantData.fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          } on DioError catch (e) {
            // print(e.message);
            invoiceDwdState = StoreState.ERROR;

            final snackBar = ConstantWidget.customSnackBar(
                text: 'Failed to download invoice', context: context);

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      } else {
        final snackBar = ConstantWidget.customSnackBar(
            text: 'Cannot find downloads directory', context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        invoiceDwdState = StoreState.EMPTY;
      }
    } else {
      final snackBar = ConstantWidget.customSnackBar(
          text: 'Permission denied', context: context);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      invoiceDwdState = StoreState.EMPTY;
    }
  }

  Future<void> cancelOrder({
    required String id,
    required String remarks,
    required BuildContext context,
  }) async {
    invoiceDwdState = StoreState.LOADING;
    SnackBar snackBar;
    // print(remarks);
    // print(id);
    final value = await _orderHistoryRepository.cancelOrder(
      id: id,
      text: remarks,
    );
    if (value != null) {
      snackBar = ConstantWidget.customSnackBar(
        text: 'Order cancelled successfully, status will be updated soon.',
        context: context,
      );
    } else {
      snackBar = ConstantWidget.customSnackBar(
        text: 'Order cancellation failed, please try again.',
        context: context,
      );
    }
    invoiceDwdState = StoreState.SUCCESS;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await getOrdersList();
  }
}
