import 'package:flutter/material.dart';
import 'package:medrpha_customer/profile/models/drug_license_model.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/models/fssai_model.dart';
import 'package:medrpha_customer/profile/models/gst_model.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'size_config.dart';

class ConstantData {
  /// Colors [Color]
  static Color primaryColor = '#0188A6'.toColor();
  static Color accentColor = "#55D6BE".toColor();
  static Color secondaryColor = '#ACFCD9'.toColor();
  static Color bgColor = "#ffffff".toColor();
  static Color bgColor1 = '#F7F7F7'.toColor();
  static Color viewColor = "#F1F1F1".toColor();
  static Color cellColor = "#F1F1F1".toColor();
  // static Color cellColor = "#E4E6ED".toColor();

  /// Necessary URL's
  static String assetsPath = "assets/images/";
  static String catImgUrl = 'https://superadmin.medrpha.com/allimage/';
  static String productUrl = 'https://partner.medrpha.com/product_image/';
  static String licenseUrl = 'https://medrpha.com/user_reg/';
  static String invoiceUrl = 'https://medrpha.com/InvoicePDF/';
  static String privacyPolicy = "https://google.com";

  //Api-key Details
  static String apiKey = 'rzp_test_3mRxTObsNw167K';
  static String apiSecretKey = 'i67GTEvHsJpSIkAKcM3etMRh';

  static String rupeeConversion({required String value}) {
    final numeric = double.parse(value);
    if (int.parse((numeric / 1000).toString()) > 1) {
      // final _paramas = value.replaceRange(value.length - 3, value.length, 'K');
      final params = '${numeric / 1000}K';
      return params;
    } else {
      return value;
    }
  }

  /// App Colors.
  static const double avatarRadius = 40;
  static Color mainTextColor = "#030303".toColor();
  static String fontFamily = "Gilroy";
  static Color borderColor = Colors.grey.shade400;
  // static Color mainTextColor = "#084043".toColor();
  static Color textColor = "#4E4E4E".toColor();
  static Color color1 = "#FD6C57".toColor();
  static Color color2 = "#019E8B".toColor();
  static Color color3 = "#1F8AFB".toColor();
  static Color color4 = "#FB9754".toColor();
  static Color color5 = "#E66474".toColor();
  static Color cartColor = "#F1F1F1".toColor();
  static Color clrBorder = const Color(0xffBABABA);
  static Color clrBlack30 = const Color(0xff303030);
  static Color clrBlack20 = const Color(0xffC9C9C9);

  static Color shadowColor = ConstantData.primaryColor.withOpacity(0.2);

  /// Constant snackbar
  SnackBar snackBarValidation(BuildContext context) {
    return SnackBar(
      content: ConstantWidget.getTextWidget(
        'Please Check All the Details',
        bgColor,
        TextAlign.left,
        FontWeight.w500,
        font18Px(context: context),
      ),
    );
  }

  /// Constant data models for initalization
  final initFirmInfoModel = FirmInfoModel(
    firmName: '',
    email: '',
    phone: '',
    country: '',
    city: '',
    pin: '',
    address: '',
    contactName: '',
    contactNo: '',
    altContactNo: '',
    state: '',
  );

  final initGstModel = GSTModel(
    gstNo: '',
    toFill: false,
  );

  final initDrugLicenseModel = DrugLicenseModel(
    name: '',
    number: '',
    validity: '',
    license1Bytes: [],
    license2Bytes: [],
    dlImg1: '',
    dlImg2: '',
    toFill: false,
  );

  final initFssaiModel = FSSAIModel(
    number: '',
    numberBytes: [],
    toFill: false,
    fssaiImg: '',
  );

  static const double padding = 20;

  /// All constant formats
  static String timeFormat = "hh:mm aa";
  static String dateFormat = "EEE ,MMM dd,yyyy";
  static RegExp emailValidate = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp gstValidate =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

  /// color conversion
  static colorList() {
    List<Color> colorList = [];
    colorList.add(color1);
    colorList.add(color2);
    colorList.add(color3);
    colorList.add(color4);
    colorList.add(color5);
    return colorList;
  }

  // static setThemePosition() async {
  //   int themMode = await PrefData.getThemeMode();

  //   print("themeMode-----$themMode");

  //   if (themMode == 1) {
  //     textColor = Colors.white70;
  //     bgColor = "#14181E".toColor();
  //     viewColor = "#292929".toColor();
  //     cellColor = "#252525".toColor();
  //     mainTextColor = Colors.white;
  //     borderColor = Colors.white70;

  //     cartColor = "#1E1D26".toColor();
  //     viewColor = "#1E1D26".toColor();
  //   } else {
  //     textColor = "#0A2A2C".toColor();
  //     bgColor = "#ffffff".toColor();
  //     viewColor = Colors.grey.shade100;
  //     cellColor = "#F1F1F1".toColor();
  //     // mainTextColor = "#084043".toColor();
  //     mainTextColor = "#030303".toColor();
  //     borderColor = Colors.grey.shade400;
  //     cartColor = "#F1F1F1".toColor();
  //   }
  // }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
