import 'package:flutter/material.dart';

double screenWidth({required BuildContext context}) {
  final _mediaQueryData = MediaQuery.of(context);
  return _mediaQueryData.size.width;
}

double screenHeight({required BuildContext context}) {
  final _mediaQueryData = MediaQuery.of(context);
  return _mediaQueryData.size.height;
}

double blockSizeHorizontal({required BuildContext context}) {
  final width = screenWidth(context: context);
  return (width / 100);
}

double blockSizeVertical({required BuildContext context}) {
  final height = screenHeight(context: context);
  return (height / 100);
}

double safeAreaHorizontal({required BuildContext context}) {
  final _mediaQueryData = MediaQuery.of(context);
  final _safeAreaHorizontal =
      _mediaQueryData.padding.left + _mediaQueryData.padding.right;
  return _safeAreaHorizontal;
}

double safeAreaVertical({required BuildContext context}) {
  final _mediaQueryData = MediaQuery.of(context);
  final _safeAreaVertical =
      _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  return _safeAreaVertical;
}

double safeBlockHorizontal({required BuildContext context}) {
  final _safeAreaHorizontal = safeAreaHorizontal(context: context);
  final _screenWidth = screenWidth(context: context);
  return (_screenWidth - _safeAreaHorizontal) / 100;
}

double safeBlockVertical({required BuildContext context}) {
  final _safeAreaVertical = safeAreaVertical(context: context);
  final _screenHeight = screenHeight(context: context);
  return (_screenHeight - _safeAreaVertical) / 100;
}

double font12Px({required BuildContext context}) {
  return safeBlockVertical(context: context) / 0.75;
}

double font15Px({required BuildContext context}) {
  return safeBlockVertical(context: context) / 0.60;
}

double font18Px({required BuildContext context}) {
  return safeBlockVertical(context: context) / 0.5;
}

double font22Px({required BuildContext context}) {
  return safeBlockVertical(context: context) / 0.4;
}

double font25Px({required BuildContext context}) {
  return safeBlockVertical(context: context) / 0.3;
}


// class SizeConfig {
//   late final MediaQueryData _mediaQueryData;
//   late final double screenWidth;
//   late final double screenHeight;
//   late final double blockSizeHorizontal;
//   late final double blockSizeVertical;
//   late final double _safeAreaHorizontal;
//   late final double _safeAreaVertical;
//   late final double safeBlockHorizontal;
//   late final double safeBlockVertical;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     blockSizeHorizontal = screenWidth / 100;
//     blockSizeVertical = screenHeight / 100;
//     _safeAreaHorizontal =
//         _mediaQueryData.padding.left + _mediaQueryData.padding.right;
//     _safeAreaVertical =
//         _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
//     safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
//     safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
//   }
// }
