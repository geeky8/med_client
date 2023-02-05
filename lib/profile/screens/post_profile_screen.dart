// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/profile/screens/profile_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/create_pin_screen.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class ProfileSubmission extends StatelessWidget {
  const ProfileSubmission({
    Key? key,
    this.beginToFill,
  }) : super(key: key);

  final bool? beginToFill;

  @override
  Widget build(BuildContext context) {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    // final loginStore = context.read<LoginStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: ConstantWidget.getScreenPercentSize(context, 10),
        child: ConstantWidget.getBottomButton(
          context: context,
          func: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    Provider.value(value: store),
                    Provider.value(value: orderHistoryStore),
                    Provider.value(value: profileStore),
                    Provider.value(
                      value: bottomNavigationStore..currentPage = 0,
                    ),
                    Provider.value(
                      value: productStore,
                    ),
                  ],
                  child: const HomeScreen(),
                ),
              ),
            );
          },
          label: '${"Let's"} Go',
          color: ConstantData.primaryColor,
          height: 7,
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ConstantData.assetsPath + 'img_allow_notification.png'),
            // const Spacer(),
            SizedBox(
              height: blockSizeVertical(context: context) * 4,
            ),
            ConstantWidget.getCustomText(
              'Profile Created Successfully!',
              ConstantData.mainTextColor,
              1,
              TextAlign.center,
              FontWeight.w600,
              font22Px(context: context) * 1.1,
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 5,
                vertical: blockSizeVertical(context: context) * 2,
              ),
              child: ConstantWidget.getCustomText(
                (beginToFill != null)
                    ? 'Congratulations, your profile has been created successfully and is under review till then you can checkout our store.'
                    : 'Congratulations, your profile has been updated successfully and is under review till then you can checkout our store.',
                ConstantData.clrBorder,
                3,
                TextAlign.center,
                FontWeight.w600,
                font18Px(context: context) * 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
