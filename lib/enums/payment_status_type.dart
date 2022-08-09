/// [PaymentStatusType] for managing payment status of orders.
// ignore_for_file: constant_identifier_names

enum PaymentStatusType {
  ///[PaymentStatusType.PAID] for paid orders.
  PAID,

  ///[PaymentStatusType.UNPAID] for unpaid orders.
  UNPAID,

  ///[PaymentStatusType.PAYLATER] for unpaid orders and paylater enabled users.
  PAYLATER,
}

extension PaymentStatusTypeExtenstion on PaymentStatusType {
  String toPaymentStr() {
    switch (this) {
      case PaymentStatusType.PAID:
        return '2';
      case PaymentStatusType.UNPAID:
        return '1';
      case PaymentStatusType.PAYLATER:
        return '3';
    }
  }
}

PaymentStatusType paymentStatusFromValue(String status) {
  switch (status) {
    case '2':
      return PaymentStatusType.PAID;
    case '1':
      return PaymentStatusType.UNPAID;
    case '3':
      return PaymentStatusType.PAYLATER;
  }
  return PaymentStatusType.UNPAID;
}
