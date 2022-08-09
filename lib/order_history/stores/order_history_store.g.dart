// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderHistoryStore on _OrderHistoryStore, Store {
  late final _$stateAtom =
      Atom(name: '_OrderHistoryStore.state', context: context);

  @override
  StoreState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(StoreState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$ordersAtom =
      Atom(name: '_OrderHistoryStore.orders', context: context);

  @override
  ObservableList<OrderHistoryModel> get orders {
    _$ordersAtom.reportRead();
    return super.orders;
  }

  @override
  set orders(ObservableList<OrderHistoryModel> value) {
    _$ordersAtom.reportWrite(value, super.orders, () {
      super.orders = value;
    });
  }

  late final _$dispatchedOrdersAtom =
      Atom(name: '_OrderHistoryStore.dispatchedOrders', context: context);

  @override
  ObservableList<OrderHistoryModel> get dispatchedOrders {
    _$dispatchedOrdersAtom.reportRead();
    return super.dispatchedOrders;
  }

  @override
  set dispatchedOrders(ObservableList<OrderHistoryModel> value) {
    _$dispatchedOrdersAtom.reportWrite(value, super.dispatchedOrders, () {
      super.dispatchedOrders = value;
    });
  }

  late final _$deliveredOrdersAtom =
      Atom(name: '_OrderHistoryStore.deliveredOrders', context: context);

  @override
  ObservableList<OrderHistoryModel> get deliveredOrders {
    _$deliveredOrdersAtom.reportRead();
    return super.deliveredOrders;
  }

  @override
  set deliveredOrders(ObservableList<OrderHistoryModel> value) {
    _$deliveredOrdersAtom.reportWrite(value, super.deliveredOrders, () {
      super.deliveredOrders = value;
    });
  }

  late final _$viewOrdersStatusTypeAtom =
      Atom(name: '_OrderHistoryStore.viewOrdersStatusType', context: context);

  @override
  OrderStatusType get viewOrdersStatusType {
    _$viewOrdersStatusTypeAtom.reportRead();
    return super.viewOrdersStatusType;
  }

  @override
  set viewOrdersStatusType(OrderStatusType value) {
    _$viewOrdersStatusTypeAtom.reportWrite(value, super.viewOrdersStatusType,
        () {
      super.viewOrdersStatusType = value;
    });
  }

  late final _$invoiceDwdStateAtom =
      Atom(name: '_OrderHistoryStore.invoiceDwdState', context: context);

  @override
  StoreState get invoiceDwdState {
    _$invoiceDwdStateAtom.reportRead();
    return super.invoiceDwdState;
  }

  @override
  set invoiceDwdState(StoreState value) {
    _$invoiceDwdStateAtom.reportWrite(value, super.invoiceDwdState, () {
      super.invoiceDwdState = value;
    });
  }

  late final _$updateTheOrdersStateAsyncAction =
      AsyncAction('_OrderHistoryStore.updateTheOrdersState', context: context);

  @override
  Future<void> updateTheOrdersState({required OrderHistoryModel model}) {
    return _$updateTheOrdersStateAsyncAction
        .run(() => super.updateTheOrdersState(model: model));
  }

  late final _$getOrdersListAsyncAction =
      AsyncAction('_OrderHistoryStore.getOrdersList', context: context);

  @override
  Future<void> getOrdersList() {
    return _$getOrdersListAsyncAction.run(() => super.getOrdersList());
  }

  late final _$downloadInvoiceAsyncAction =
      AsyncAction('_OrderHistoryStore.downloadInvoice', context: context);

  @override
  Future<void> downloadInvoice(
      {required String invoice, required BuildContext context}) {
    return _$downloadInvoiceAsyncAction
        .run(() => super.downloadInvoice(invoice: invoice, context: context));
  }

  @override
  String toString() {
    return '''
state: ${state},
orders: ${orders},
dispatchedOrders: ${dispatchedOrders},
deliveredOrders: ${deliveredOrders},
viewOrdersStatusType: ${viewOrdersStatusType},
invoiceDwdState: ${invoiceDwdState}
    ''';
  }
}
