/// [PaymentOptions] for managing payment status of orders.
// ignore_for_file: constant_identifier_names

enum PaymentOptions {
  ///[PaymentOptions.ONLINE] for Online payment.
  ONLINE,

  ///[PaymentOptions.PAYLATER] for credit payments.
  PAYLATER,

  ///[PaymentOptions.PAYONDELIVERY] for credit payments.
  PAYONDELIVERY,
}

extension PaymentOptionsExtenstion on PaymentOptions {
  String toPaymentOption() {
    switch (this) {
      case PaymentOptions.ONLINE:
        return '3';
      case PaymentOptions.PAYLATER:
        return '2';
      case PaymentOptions.PAYONDELIVERY:
        return '1';
    }
  }
}

// PaymentOptions paymentStatusFromValue(String status) {
//   switch (status) {
//     case '2':
//       return PaymentOptions.PAID;
//     case '1':
//       return PaymentOptions.UNPAID;
//   }
//   return PaymentOptions.UNPAID;
// }
