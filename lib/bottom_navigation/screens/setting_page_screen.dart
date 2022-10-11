import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/screens/order_history_screen.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/screens/cart_screen.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/screens/profile_details_screen.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/screens/login_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class SettingsPageScreen extends StatelessWidget {
  const SettingsPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double leftMargin = MediaQuery.of(context).size.width * 0.04;
    double imageSize = safeBlockVertical(context: context) * 15;
    double deftMargin = ConstantWidget.getScreenPercentSize(context, 2);
    final loginStore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final profileStore = context.read<ProfileStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return Scaffold(
      body: Container(
        color: ConstantData.bgColor,
        margin: EdgeInsets.only(
            left: leftMargin,
            right: leftMargin,
            bottom: MediaQuery.of(context).size.width * 0.01),
        child: Observer(builder: (_) {
          final profileModel = profileStore.profileModel.firmInfoModel;
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: (deftMargin * 1.5)),
                child: Column(
                  children: [
                    SizedBox(
                      height: (deftMargin * 2),
                    ),
                    Row(
                      children: [
                        Container(
                          height: imageSize,
                          width: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: ExactAssetImage(
                                  '${ConstantData.assetsPath}med_logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: deftMargin),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstantWidget.getCustomTextWithoutAlign(
                                    profileModel.firmName,
                                    ConstantData.mainTextColor,
                                    FontWeight.w600,
                                    font22Px(context: context)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child:
                                      ConstantWidget.getCustomTextWithoutAlign(
                                          profileModel.email,
                                          ConstantData.mainTextColor,
                                          FontWeight.w600,
                                          font15Px(context: context)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: blockSizeVertical(context: context) * 5,
              ),
              InkWell(
                child: const GetCell(label: 'Profile', icon: Icons.edit),
                onTap: () async {
                  // sendAction(EditProfilePage());
                  // final phone = await DataBox().readPhoneNo();
                  // print(phone);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: profileStore,
                        child: Provider.value(
                          value: loginStore,
                          child: Provider.value(
                            value: productStore,
                            child: Provider.value(
                              value: bottomNavigationStore,
                              child: Provider.value(
                                value: orderHistoryStore,
                                child: const ProfileDetailsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                child:
                    const GetCell(label: 'My Orders', icon: Icons.shopping_bag),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: orderHistoryStore,
                        child: Provider.value(
                          value: loginStore,
                          child: Provider.value(
                            value: profileStore,
                            child: Provider.value(
                              value: productStore,
                              child: const OrderHistoryScreen(
                                fromSettingsPage: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                child: const GetCell(label: 'Cart', icon: Icons.shopping_cart),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: productStore,
                        child: Provider.value(
                          value: loginStore,
                          child: Provider.value(
                            value: profileStore,
                            child: Provider.value(
                              value: orderHistoryStore,
                              child: Provider.value(
                                value: bottomNavigationStore,
                                child: const CartScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  // sendAction(AddToCartPage());
                },
              ),
              // InkWell(
              //   child: GetCell(
              //       S.of(context)!.address, Icons.local_shipping_outlined),
              //   onTap: () {
              //     sendAction(ShippingAddressPage());
              //   },
              // ),
              // InkWell(
              //   child: GetCell(S.of(context)!.mySavedCards, Icons.credit_card),
              //   onTap: () {
              //     sendAction(MySavedCardsPage());
              //   },
              // ),
              // InkWell(
              //   child: GetCell(S.of(context)!.giftCard, Icons.card_giftcard),
              //   onTap: () {
              //     sendAction(MyVouchers(false));
              //   },
              // ),
              // InkWell(
              //   child: _getModeCell(
              //       S.of(context)!.darkMode,
              //       (themMode == 0)
              //           ? Icons.toggle_off_outlined
              //           : Icons.toggle_on_outlined),
              //   onTap: () {
              //     print("themeMode--1-$themMode}");
              //     if (themMode == 1) {
              //       PrefData.setThemeMode(0);
              //     } else {
              //       PrefData.setThemeMode(1);
              //     }
              //     getThemeMode();
              //   },
              // ),
              // InkWell(
              //   child: GetCell(
              //       S.of(context)!.notification, Icons.notifications_none),
              //   onTap: () {
              //     sendAction(NotificationList());
              //   },
              // ),
              // InkWell(
              //   child: GetCell(S.of(context)!.review, Icons.rate_review),
              //   onTap: () {
              //     sendAction(WriteReviewPage());
              //   },
              // ),
              // InkWell(
              //   child: const GetCell(label: 'About Us', icon: Icons.info),
              //   onTap: () {
              //     // sendAction(AboutUsPage());
              //   },
              // ),
              InkWell(
                child: const GetCell(label: 'Logout', icon: Icons.logout),
                onTap: () {
                  // PrefData.setIsSignIn(false);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => MyHomePage()));
                  bottomNavigationStore.currentPage = 1;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: loginStore..init(),
                        child: Provider.value(
                          value: productStore,
                          child: Provider.value(
                            value: profileStore..init(),
                            child: Provider.value(
                              value: bottomNavigationStore,
                              child: Provider.value(
                                value: orderHistoryStore,
                                child: LoginScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  // return Scaffold(
  //   body: Center(
  //     child: ConstantWidget.getCustomText(
  //       'Settings',
  //       ConstantData.mainTextColor,
  //       1,
  //       TextAlign.center,
  //       FontWeight.w600,
  //       font22Px(context: context),
  //     ),
  //   ),
  // );
}

class GetCell extends StatelessWidget {
  const GetCell({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    double deftMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double size = ConstantWidget.getScreenPercentSize(context, 6);
    double iconSize = ConstantWidget.getPercentSize(size, 50);
    return Container(
      margin: EdgeInsets.only(
          bottom: ConstantWidget.getScreenPercentSize(context, 0.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: ConstantWidget.getScreenPercentSize(context, 1)),
                height: size,
                width: size,
                decoration: BoxDecoration(
                    color: ConstantData.cellColor,
                    borderRadius: BorderRadius.all(Radius.circular(
                        ConstantWidget.getPercentSize(size, 15)))),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: ConstantData.mainTextColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: font18Px(context: context),
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.textColor,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.navigate_next,
                    color: ConstantData.textColor,
                    size: ConstantWidget.getScreenPercentSize(context, 3),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: deftMargin, bottom: deftMargin),
            height: ConstantWidget.getScreenPercentSize(context, 0.02),
            color: ConstantData.mainTextColor,
          ),
        ],
      ),
    );
  }
}
