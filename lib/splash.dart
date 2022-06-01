import 'package:flutter/material.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/screens/sign_up_page.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _check({
    required LoginStore store,
    required ProductsStore productsStore,
  }) async {
    final _sessId = await DataBox().readSessId();
    if (_sessId == '') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Provider.value(
                  value: store,
                  child: Provider.value(
                      value: productsStore, child: SignUpPage()))));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Provider.value(
            value: store..init(),
            child: Provider.value(
              value: productsStore,
              child: LoginScreen(),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    final store = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    _check(
      store: store,
      productsStore: productStore,
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
