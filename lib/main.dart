import 'package:flutter/material.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/splash.dart';
import 'package:provider/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // DataBox().initDataBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          Provider<LoginStore>(create: (_) => LoginStore()),
          Provider<ProductsStore>(
            create: (_) => ProductsStore(),
          ),
        ],
        child: const SplashScreen(),
        // child: const HomeScreen(),
        // child: const TestScreen(),
      ),
    );
  }
}
