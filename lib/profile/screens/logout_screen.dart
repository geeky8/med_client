// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/splash.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantWidget.customAppBar(
        context: context,
        title: 'Logout',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              ConstantData.assetsPath + 'img_allow_notification.png',
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 4,
            ),
            child: ConstantWidget.getCustomText(
              'By Completing the registeration you may unlock all the features of this application.',
              ConstantData.mainTextColor,
              2,
              TextAlign.center,
              FontWeight.w600,
              font22Px(context: context),
            ),
          ),
          SizedBox(
            height: blockSizeVertical(context: context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 4,
            ),
            child: ConstantWidget.getBottomButton(
              context: context,
              func: () {
                Navigator.of(context).pop();
              },
              label: 'Click here to unlock surprises!',
              height: blockSizeVertical(context: context),
              labelColor: ConstantData.bgColor,
              color: ConstantData.primaryColor,
            ),
          ),
          // const Spacer(),
          SizedBox(
            height: blockSizeVertical(context: context) * 4,
          ),
          ConstantWidget.getCustomText(
            'Are you sure you want to logout?',
            ConstantData.mainTextColor,
            2,
            TextAlign.center,
            FontWeight.w600,
            font18Px(context: context),
          ),
          SizedBox(
            height: blockSizeVertical(context: context),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      Provider<LoginStore>(create: (_) => LoginStore()),
                      Provider<ProductsStore>(create: (_) => ProductsStore()),
                      Provider<ProfileStore>(create: (_) => ProfileStore()),
                      Provider<BottomNavigationStore>(
                        create: (_) => BottomNavigationStore(),
                      ),
                      Provider<OrderHistoryStore>(
                        create: (_) => OrderHistoryStore(),
                      ),
                    ],
                    child: const SplashScreen(),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 4,
                vertical: blockSizeVertical(context: context) * 1.5,
              ),
              decoration: BoxDecoration(
                color: ConstantData.primaryColor,
                borderRadius: BorderRadius.circular(
                  font22Px(context: context),
                ),
              ),
              child: ConstantWidget.getCustomText(
                'Logout',
                ConstantData.bgColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font18Px(context: context),
              ),
            ),
          ),
          SizedBox(
            height: blockSizeVertical(context: context) * 2,
          ),
          // SizedBox(
          //   height: blockSizeVertical(context: context) * 2,
          // ),
          // ConstantWidget.getBottomButton(
          //   context: context,
          //   func: () {},
          //   label: 'Logout',
          //   height: blockSizeVertical(context: context),
          //   labelColor: ConstantData.bgColor,
          //   color: ConstantData.accentColor,
          // ),
        ],
      ),
    );
  }
}
