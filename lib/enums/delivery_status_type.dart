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
        return 'Confirmed';
      case OrderStatusType.DISPATCHED:
        return 'Dispatched';
      case OrderStatusType.DELIVERED:
        return 'Delivered';
      case OrderStatusType.CANCELLED:
        return 'Cancelled';
    }
  }
}

OrderStatusType deliverStatusFromValue(String status) {
  switch (status) {
    case 'Confirmed':
      return OrderStatusType.CONFIRMED;
    case 'On-Delivery':
      return OrderStatusType.DISPATCHED;
    case 'Delivered':
      return OrderStatusType.DELIVERED;
    case 'Cancelled':
      return OrderStatusType.CANCELLED;
  }
  return OrderStatusType.CONFIRMED;
}
