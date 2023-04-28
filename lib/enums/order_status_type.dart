/// [OrderStatusType] for managing delivery status of orders.
// ignore_for_file: constant_identifier_names

enum OrderStatusType {
  ///[OrderStatusType.CONFIRMED] for confirmed orders.
  CONFIRMED,

  ///[OrderStatusType.DISPATCHED] for dispatched orders.
  DISPATCHED,

  ///[OrderStatusType.DELIVERED] for delivered orders.
  DELIVERED,

  ///[OrderStatusType.CANCELLED] for cancelled orders.
  CANCELLED,

  ///[OrderStatusType.RETURNED] for cancelled orders.
  RETURNED,
}

// extension OrderStatusTypeExtension on OrderStatusType {
//   String toDeliveryStatus() {
//     switch (this) {
// case OrderStatusType.CONFIRMED:
//   return 'Confirmed';
// case OrderStatusType.DISPATCHED:
//   return 'On-Delivery';
// case OrderStatusType.DELIVERED:
//   return 'Delivered';
//     }
//   }
// }

extension OrderStatusTypeExtenstion on OrderStatusType {
  String orderStatusString() {
    switch (this) {
      case OrderStatusType.CONFIRMED:
        return 'Placed';
      case OrderStatusType.DISPATCHED:
        return 'Dispatched';
      case OrderStatusType.DELIVERED:
        return 'Delivered';
      case OrderStatusType.CANCELLED:
        return 'Cancelled';
      case OrderStatusType.RETURNED:
        return 'Returned';
    }
  }

  int getIndicator() {
    switch (this) {
      case OrderStatusType.CONFIRMED:
        return 0;
      case OrderStatusType.DISPATCHED:
        return 1;
      case OrderStatusType.DELIVERED:
        return 2;
      case OrderStatusType.CANCELLED:
        return 4;
      case OrderStatusType.RETURNED:
        return 3;
    }
  }
}

OrderStatusType orderStatusFromIndex(int status) {
  switch (status) {
    case 0:
      return OrderStatusType.CONFIRMED;
    case 1:
      return OrderStatusType.DISPATCHED;
    case 2:
      return OrderStatusType.DELIVERED;
    case 4:
      return OrderStatusType.CANCELLED;
    case 3:
      return OrderStatusType.RETURNED;
  }
  return OrderStatusType.CONFIRMED;
}

OrderStatusType orderStatusFromValue(String status) {
  switch (status) {
    case 'Placed':
      return OrderStatusType.CONFIRMED;
    case 'Dispatched':
      return OrderStatusType.DISPATCHED;
    case 'Delivered':
      return OrderStatusType.DELIVERED;
    case 'Cancelled':
      return OrderStatusType.CANCELLED;
    case 'Returned':
      return OrderStatusType.RETURNED;
  }
  return OrderStatusType.CONFIRMED;
}
