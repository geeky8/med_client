// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/screens/otp_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:medrpha_customer/utils/update_app_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// To manage navigation depending upon auth of user
  Future<void> _check({
    required LoginStore store,
    required ProductsStore productsStore,
    required ProfileStore profileStore,
    required BottomNavigationStore bottomNavigationStore,
    required OrderHistoryStore orderHistoryStore,
  }) async {
    // final value = await _checkVersion();
    // if (value == 0) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => const UpdateAppScreen(),
    //     ),
    //   );
    // } else {
    final sessId = await DataBox().readSessId();
    if (sessId == '') {
      /// For first time user

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Provider.value(
            value: store,
            child: Provider.value(
              value: productsStore,
              child: Provider.value(
                value: profileStore,
                child: Provider.value(
                  value: bottomNavigationStore,
                  child: Provider.value(
                    value: orderHistoryStore,
                    child: SignUpPage(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      /// Regular users

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Provider.value(
            value: store..init(),
            child: Provider.value(
              value: productsStore..init(),
              child: Provider.value(
                value: profileStore..init(),
                child: Provider.value(
                  value: bottomNavigationStore,
                  child: Provider.value(
                    value: orderHistoryStore..getOrdersList(),
                    child: LoginScreen(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // }
  }

  Future<int> _checkVersion() async {
    final httpClient = http.Client();
    // const url = 'https://api.medrpha.com/api/Default/latestappversion';
    const url = 'https://apitest.medrpha.com/api/Default/latestappversion';
    final packageInfo = await PackageInfo.fromPlatform();
    if (kDebugMode) {
      print(packageInfo.buildNumber);
    }
    int versionTrue = 1;
    final resp = await httpClient.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body) as Map<String, dynamic>;
      if (respBody['status'] as String == '1') {
        if (respBody['version'] as String != packageInfo.buildNumber) {
          if (kDebugMode) {
            print('update is req');
          }
          versionTrue = 0;
          // if (mounted) {

          // }
        }
      }
    }
    return versionTrue;
  }

  @override
  void initState() {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    _check(
      store: store,
      productsStore: productStore,
      profileStore: profileStore,
      bottomNavigationStore: bottomNavigationStore,
      orderHistoryStore: orderHistoryStore,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ConstantData.assetsPath + 'med_logo_text_img.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
