// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/screens/setting_page_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/order_history/screens/order_history_screen.dart';
import 'package:medrpha_customer/products/screens/categories_screen.dart';
import 'package:medrpha_customer/products/screens/home_products_screen.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    /// List pages toggled using bottom navigation
    final pages = [
      const OrderHistoryScreen(),
      const ProductHomeScreen(),
      const CategoriesListScreen(
        isHome: false,
      ),
      const SettingsPageScreen(),
    ];

    // final _nabBarItems = [
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(Icons.history),
    //     // title: ("History"),
    //     activeColorPrimary: ConstantData.primaryColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(CupertinoIcons.home),
    //     // title: ("Home"),
    //     activeColorPrimary: ConstantData.primaryColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    //   PersistentBottomNavBarItem(
    //     icon: const Icon(CupertinoIcons.settings),
    //     // title: ("Settings"),
    //     activeColorPrimary: ConstantData.primaryColor,
    //     inactiveColorPrimary: CupertinoColors.systemGrey,
    //   ),
    // ];

    return Observer(builder: (_) {
      final page = bottomNavigationStore.currentPage;
      return Scaffold(
        // bottomNavigationBar: Row(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         // padding: EdgeInsets.symmetric(
        //         //     vertical: blockSizeVertical(context: context)),
        //         decoration: BoxDecoration(
        //             color: ConstantData.primaryColor,
        //             borderRadius: BorderRadius.circular(
        //                 blockSizeHorizontal(context: context) * 5)),
        //         child: ClipRRect(
        //           borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
        //           child: BottomNavigationBar(
        //             currentIndex: page,
        //             showSelectedLabels: false,
        //             showUnselectedLabels: false,
        //             selectedIconTheme: IconThemeData(
        //                 color: ConstantData.bgColor,
        //                 size: blockSizeHorizontal(context: context) * 6),
        //             unselectedIconTheme: IconThemeData(
        //                 color: ConstantData.bgColor,
        //                 size: blockSizeHorizontal(context: context) * 5),
        //             selectedFontSize: font22Px(context: context),
        //             unselectedFontSize: font18Px(context: context),
        //             selectedItemColor: ConstantData.bgColor,
        //             unselectedItemColor: ConstantData.color5,
        //             backgroundColor: ConstantData.primaryColor,
        //             onTap: (index) {
        //               bottomNavigationStore.currentPage = index;
        //             },
        //             items: const [
        //               BottomNavigationBarItem(
        //                 icon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.cartColor,
        //                   // size: font18Px(context: context),
        //                 ),
        //                 activeIcon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.bgColor,
        //                   // size: font22Px(context: context),
        //                 ),
        //                 label: 'Orders',
        //               ),
        //               BottomNavigationBarItem(
        //                 icon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.cellColor,
        //                   // size: font18Px(context: context),
        //                 ),
        //                 activeIcon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.bgColor,
        //                   // size: font22Px(context: context),
        //                 ),
        //                 label: 'Home',
        //               ),
        //               BottomNavigationBarItem(
        //                 icon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.cellColor,
        //                   // size: font18Px(context: context),
        //                 ),
        //                 activeIcon: Icon(
        //                   Icons.calendar_today,
        //                   // color: ConstantData.bgColor,
        //                   // size: font22Px(context: context),
        //                 ),
        //                 label: 'Profile',
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // bottomNavigationBar: FancyBottomNavigation(
        //   tabs: [
        //     TabData(iconData: Icons.history, title: "Orders"),
        //     TabData(iconData: Icons.home, title: "Home"),
        //     TabData(iconData: Icons.settings, title: "Settings")
        //   ],
        //   onTabChangedListener: (position) {
        //     bottomNavigationStore.currentPage = position;
        //   },
        //   initialSelection: page,
        //   barBackgroundColor: ConstantData.bgColor,
        //   activeIconColor: ConstantData.bgColor,
        //   inactiveIconColor: ConstantData.primaryColor,
        //   circleColor: ConstantData.primaryColor,
        //   textColor: ConstantData.primaryColor,
        // ),
        // bottomNavigationBar: PersistentTabView(
        //   context,
        //   // controller: _controller,
        //   onItemSelected: (value) {
        //     bottomNavigationStore.currentPage = value;
        //   },
        //   screens: _pages,
        //   items: _nabBarItems,
        //   confineInSafeArea: true,
        //   backgroundColor: Colors.white, // Default is Colors.white.
        //   handleAndroidBackButtonPress: true, // Default is true.
        //   resizeToAvoidBottomInset:
        //       true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        //   stateManagement: true, // Default is true.
        //   hideNavigationBarWhenKeyboardShows:
        //       true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        //   decoration: NavBarDecoration(
        //     borderRadius: BorderRadius.circular(10.0),
        //     colorBehindNavBar: Colors.white,
        //   ),
        //   popAllScreensOnTapOfSelectedTab: true,
        //   popActionScreens: PopActionScreensType.all,
        //   itemAnimationProperties: const ItemAnimationProperties(
        //     // Navigation Bar's items animation properties.
        //     duration: Duration(milliseconds: 200),
        //     curve: Curves.ease,
        //   ),
        //   screenTransitionAnimation: const ScreenTransitionAnimation(
        //     // Screen transition animation on change of selected tab.
        //     animateTabTransition: true,
        //     curve: Curves.ease,
        //     duration: Duration(milliseconds: 200),
        //   ),
        //   navBarStyle: NavBarStyle
        //       .style6, // Choose the nav bar style with this property.
        // ),
        // bottomNavigationBar: Observer(builder: (_) {
        //   final page = bottomNavigationStore.currentPage;
        //   return MotionTabBar(
        //     labels: const ["Home", "My Order", "Profile"],
        //     // labels: ["Home", "Category", "Chat", "Filter", "Setting"],
        //     initialSelectedTab: "Home",
        //     tabIconColor: ConstantData.mainTextColor,
        //     tabSelectedColor: ConstantData.primaryColor,
        //     // selectedIndex: _selectedIndex,
        //     onTabItemSelected: (int value) {
        //       bottomNavigationStore.currentPage = value;
        //     },
        //     icons: const [
        //       Icons.home,
        //       // Icons.auto_awesome_mosaic,
        //       Icons.calendar_today_outlined,
        //       // Icons.message_outlined,
        //       Icons.account_circle_sharp,
        //     ],
        //     textStyle: TextStyle(
        //         color: Colors.transparent,
        //         fontSize: ConstantWidget.getWidthPercentSize(context, 0),
        //         fontFamily: ConstantData.fontFamily),
        //   );
        // }),
        // bottomNavigationBar: Container(
        //   height: ConstantWidget.getScreenPercentSize(context, 8),
        //   // alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     color: ConstantData.bgColor,
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        //     boxShadow: [
        //       BoxShadow(
        //           color: ConstantData.cartColor,
        //           offset: const Offset(1, 1),
        //           spreadRadius: 4,
        //           blurRadius: 4),
        //     ],
        //   ),
        //   child: Padding(
        //     padding: EdgeInsets.only(
        //       right: blockSizeHorizontal(context: context) * 3,
        //       left: blockSizeHorizontal(context: context) * 3,
        //       top: blockSizeVertical(context: context) * 2,
        //       // vertical: blockSizeVertical(context: context) * 2,
        //     ),
        //     child: Row(
        //       // crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Expanded(
        //           flex: 2,
        //           child: BottomNavWidgets(
        //             label: 'Orders',
        //             iconData: CupertinoIcons.clock,
        //             selectedIconData: CupertinoIcons.clock_fill,
        //             store: bottomNavigationStore,
        //             index: 0,
        //           ),
        //         ),
        //         const Spacer(),
        //         Expanded(
        //           flex: 2,
        //           child: BottomNavWidgets(
        //             label: 'Orders',
        //             iconData: Icons.home_outlined,
        //             selectedIconData: Icons.home_filled,
        //             store: bottomNavigationStore,
        //             index: 1,
        //           ),
        //         ),
        //         const Spacer(),
        //         Expanded(
        //           flex: 2,
        //           child: BottomNavWidgets(
        //             label: 'Orders',
        //             iconData: Icons.settings_outlined,
        //             selectedIconData: Icons.settings,
        //             store: bottomNavigationStore,
        //             index: 2,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        ///-----> Bottom Navigation
        bottomNavigationBar: SizedBox(
          height: ConstantWidget.getScreenPercentSize(context, 7.2),
          child: BottomNavigationBar(
              onTap: (value) {
                bottomNavigationStore.currentPage = value;
              },
              backgroundColor: ConstantData.bgColor,
              elevation: 15,
              type: BottomNavigationBarType.fixed,
              currentIndex: bottomNavigationStore.currentPage,
              selectedItemColor: ConstantData.primaryColor,
              unselectedItemColor: Colors.black45,
              iconSize: ConstantWidget.getScreenPercentSize(context, 3.2),
              selectedLabelStyle: TextStyle(
                fontFamily: ConstantData.fontFamily,
                fontSize: font12Px(context: context),
                fontWeight: FontWeight.w600,
                color: ConstantData.primaryColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: ConstantData.fontFamily,
                fontSize: font12Px(context: context),
                color: ConstantData.clrBlack30,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  activeIcon: Icon(Icons.shopping_bag),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ]),
        ),
        body: pages[page],
      );
    });
  }
}

class BottomNavWidgets extends StatelessWidget {
  const BottomNavWidgets({
    Key? key,
    required this.iconData,
    required this.label,
    required this.index,
    required this.store,
    required this.selectedIconData,
  }) : super(key: key);

  final IconData iconData;
  final IconData selectedIconData;
  final String label;
  final int index;
  final BottomNavigationStore store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        store.currentPage = index;
      },
      child: Column(
        children: [
          Icon(
            (store.currentPage == index) ? selectedIconData : iconData,
            color: (store.currentPage == index)
                ? ConstantData.primaryColor
                : ConstantData.mainTextColor.withOpacity(0.5),
            size: (store.currentPage == index)
                ? ConstantWidget.getScreenPercentSize(context, 4)
                : ConstantWidget.getScreenPercentSize(context, 4),
          ),
          // ConstantWidget.getCustomText(
          //   label,
          //   (store.currentPage == index)
          //       ? ConstantData.primaryColor
          //       : ConstantData.clrBlack30,
          //   1,
          //   TextAlign.center,
          //   FontWeight.w500,
          //   (store.currentPage == index)
          //       ? font15Px(context: context) * 1.2
          //       : font15Px(context: context) * 1.1,
          // ),
        ],
      ),
    );
  }
}
