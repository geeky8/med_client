import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:pay/pay.dart';

class GooglePay extends StatelessWidget {
  GooglePay({Key? key}) : super(key: key);

  final _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onResult(Map<String, dynamic> map) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GooglePayButton(
          paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
          paymentItems: _paymentItems,
          type: GooglePayButtonType.pay,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: onResult,
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
