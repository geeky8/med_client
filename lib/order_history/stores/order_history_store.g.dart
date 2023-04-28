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

  late final _$liveOrdersAtom =
      Atom(name: '_OrderHistoryStore.liveOrders', context: context);

  @override
  ObservableList<OrderHistoryModel> get liveOrders {
    _$liveOrdersAtom.reportRead();
    return super.liveOrders;
  }

  @override
  set liveOrders(ObservableList<OrderHistoryModel> value) {
    _$liveOrdersAtom.reportWrite(value, super.liveOrders, () {
      super.liveOrders = value;
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

  late final _$returnCancelledOrdersAtom =
      Atom(name: '_OrderHistoryStore.returnCancelledOrders', context: context);

  @override
  ObservableList<OrderHistoryModel> get returnCancelledOrders {
    _$returnCancelledOrdersAtom.reportRead();
    return super.returnCancelledOrders;
  }

  @override
  set returnCancelledOrders(ObservableList<OrderHistoryModel> value) {
    _$returnCancelledOrdersAtom.reportWrite(value, super.returnCancelledOrders,
        () {
      super.returnCancelledOrders = value;
    });
  }

  late final _$orderStatusTypeSelectedAtom = Atom(
      name: '_OrderHistoryStore.orderStatusTypeSelected', context: context);

  @override
  int get orderStatusTypeSelected {
    _$orderStatusTypeSelectedAtom.reportRead();
    return super.orderStatusTypeSelected;
  }

  @override
  set orderStatusTypeSelected(int value) {
    _$orderStatusTypeSelectedAtom
        .reportWrite(value, super.orderStatusTypeSelected, () {
      super.orderStatusTypeSelected = value;
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
liveOrders: ${liveOrders},
dispatchedOrders: ${dispatchedOrders},
deliveredOrders: ${deliveredOrders},
returnCancelledOrders: ${returnCancelledOrders},
orderStatusTypeSelected: ${orderStatusTypeSelected},
invoiceDwdState: ${invoiceDwdState}
    ''';
  }
}
