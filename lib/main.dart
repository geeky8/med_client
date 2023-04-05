import 'package:flutter/material.dart';
import 'package:medrpha_customer/gpayscreen.dart';
import 'package:medrpha_customer/profile/screens/logout_screen.dart';
import 'package:medrpha_customer/profile/screens/new_profile_screen.dart';
import 'package:medrpha_customer/speech_to_text.dart';
import 'package:provider/provider.dart';

import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/splash.dart';

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
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.transparent,
        ),
      ),

      /// Initializing all stores
      home: MultiProvider(
        providers: [
          Provider<LoginStore>(create: (_) => LoginStore()),
          Provider<ProductsStore>(create: (_) => ProductsStore()),
          Provider<ProfileStore>(create: (_) => ProfileStore()),
          Provider<BottomNavigationStore>(
              create: (_) => BottomNavigationStore()),
          Provider<OrderHistoryStore>(create: (_) => OrderHistoryStore()),
        ],
        child: const SplashScreen(),
        // child: NewProfileScreen(
        //   phone: '9920483807',
        // ),
        // child: OrderHistory(),
        // child: const HomeScreen(),
        // child: const SpeechText(),
      ),
    );
  }
}
