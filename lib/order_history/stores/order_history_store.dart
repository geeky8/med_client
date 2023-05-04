// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/enums/order_status_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/models/order_history_model.dart';
import 'package:medrpha_customer/order_history/repository/order_history_repository.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api_service.dart';

part 'order_history_store.g.dart';

class OrderHistoryStore = _OrderHistoryStore with _$OrderHistoryStore;

abstract class _OrderHistoryStore with Store {
  final _orderHistoryRepository = OrderHistoryRepository();

  @observable
  StoreState state = StoreState.SUCCESS;

  @observable
  ObservableList<OrderHistoryModel> allOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> searchOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> liveOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> dispatchedOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> deliveredOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  ObservableList<OrderHistoryModel> returnCancelledOrders =
      ObservableList<OrderHistoryModel>.of([]);

  @observable
  int orderStatusTypeSelected = 0;

  @observable
  bool filter = false;

  // @action
  // Future<void> updateTheOrdersState({required OrderHistoryModel model}) async {
  //   final index =
  //       orders.indexWhere((element) => element.orderId == model.orderId);
  //   final updateModel = model.copyWith(isView: !model.isView);
  //   orders
  //     ..removeAt(index)
  //     ..insert(index, updateModel);
  // }

  // @action
  // Future<void> getMyOrderDetails({required String orderId}) async {
  //   final sessId = await DataBox().readSessId();

  //   final ordersResponse = await _orderHistoryRepository.getOrdersResponseModel(
  //     sessId: sessId,
  //     orderId: orderId,
  //   );
  // }

  @action
  Future<void> getOrdersList() async {
    state = StoreState.LOADING;
    final list = await _orderHistoryRepository.getListOrdersHistory();
    // print(
    //     '---------- order history resp -------------->${_list.first.ordersList.length}');
    if (list.isNotEmpty) {
      liveOrders.clear();
      dispatchedOrders.clear();
      deliveredOrders.clear();
      returnCancelledOrders.clear();

      allOrders
        ..clear()
        ..addAll(list);

      searchOrders
        ..clear()
        ..addAll(allOrders);

      for (final order in list) {
        switch (order.orderStatusType) {
          case OrderStatusType.CONFIRMED:
            liveOrders.add(order);
            break;
          case OrderStatusType.DISPATCHED:
            dispatchedOrders.add(order);
            break;
          case OrderStatusType.DELIVERED:
            deliveredOrders.add(order);
            break;
          case OrderStatusType.CANCELLED:
            returnCancelledOrders.add(order);
            break;
          case OrderStatusType.RETURNED:
            returnCancelledOrders.add(order);
            break;
        }
      }
    }
  }

  @observable
  StoreState invoiceDwdState = StoreState.SUCCESS;

  Future<void> askPermission(PermissionStatus status) async {
    if (status.isDenied || status.isLimited) {
      debugPrint('---- open');
      final stat = await Permission.storage.request();
      askPermission(stat);
    }
    return;
  }

  @action
  Future<void> downloadInvoice({
    required String invoice,
    required BuildContext context,
  }) async {
    final url = '$invoiceUrl$invoice.pdf';

    PermissionStatus status = await Permission.storage.status;

    await askPermission(status);

    status = await Permission.storage.status;
    if (status.isGranted) {
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
                if (total != -1) {}
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
      // snackBar = ConstantWidget.customSnackBar(
      //   text: 'Order cancelled successfully, status will be updated soon.',
      //   context: context,
      // );
      Fluttertoast.showToast(msg: "Order Cancellation Successful");
    } else {
      // snackBar = ConstantWidget.customSnackBar(
      //   text: 'Order cancellation failed, please try again.',
      //   context: context,
      // );
      Fluttertoast.showToast(msg: "Order Cancellation Failure");
    }
    invoiceDwdState = StoreState.SUCCESS;
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await getOrdersList();
  }
}
