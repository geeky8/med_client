import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class ConstantWidget {
  static double getPercentSize(double total, double percent) {
    return (total * percent) / 100;
  }

  static Widget getHorizonSpace(double space) {
    return SizedBox(
      width: space,
    );
  }

  static double largeTextSize = 28;

  static Widget getAppBarIcon() {
    return Icon(
      Icons.keyboard_backspace_outlined,
      color: ConstantData.textColor,
    );
    // return       ConstantWidget.getCustomTextWithoutAlign(S.of(context)!.checkOut, ConstantData.textColor, FontWeight.bold, ConstantData.font18Px),
  }

  static Widget getAppBarText(String s, BuildContext context) {
    return ConstantWidget.getCustomTextWithoutAlign(
        s,
        ConstantData.mainTextColor,
        FontWeight.bold,
        font22Px(context: context));
  }

  static Widget errorWidget({
    required BuildContext context,
    required double height,
    required double width,
    required double fontSize,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ConstantWidget.getScreenPercentSize(context, height),
          width: ConstantWidget.getScreenPercentSize(context, height),
          child: Image.asset(
            ConstantData.assetsPath + 'not_found.png',
            fit: BoxFit.fill,
          ),
        ),
        ConstantWidget.getCustomText(
          'Not Found',
          ConstantData.mainTextColor,
          1,
          TextAlign.center,
          FontWeight.bold,
          fontSize,
        ),
      ],
    );
  }

  static Widget getBottomText(
      BuildContext context, String s, Function function) {
    double bottomHeight = ConstantWidget.getScreenPercentSize(context, 6);
    // double bottomHeight = ConstantWidget.getScreenPercentSize(context, 7.6);
    double radius = ConstantWidget.getPercentSize(bottomHeight, 18);

    return Container(
      margin: EdgeInsets.only(
          bottom: ConstantWidget.getPercentSize(bottomHeight, 15)),
      child: Container(
        height: bottomHeight,
        margin: EdgeInsets.symmetric(
            horizontal: ConstantWidget.getPercentSize(bottomHeight, 50),
            vertical: ConstantWidget.getPercentSize(bottomHeight, 15)),
        decoration: BoxDecoration(
          color: ConstantData.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Center(
          child: ConstantWidget.getTextWidget(s, Colors.white, TextAlign.start,
              FontWeight.bold, ConstantWidget.getPercentSize(bottomHeight, 30)),
        ),
      ),
    );
  }

  static Widget getEditButton(
      BuildContext context, String s, Function function) {
    double bottomHeight = ConstantWidget.getScreenPercentSize(context, 6);
    double radius = ConstantWidget.getPercentSize(bottomHeight, 18);

    return InkWell(
      child: Container(
        height: bottomHeight,
        margin: EdgeInsets.symmetric(
            horizontal: ConstantWidget.getPercentSize(bottomHeight, 50),
            vertical: ConstantWidget.getPercentSize(bottomHeight, 15)),
        decoration: BoxDecoration(
          color: ConstantData.accentColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Center(
          child: ConstantWidget.getTextWidget(s, Colors.white, TextAlign.start,
              FontWeight.bold, ConstantWidget.getPercentSize(bottomHeight, 30)),
        ),
      ),
      onTap: () => function,
    );
  }

  static Widget getDrawerItem(
      BuildContext context, String s, var icon, Function function) {
    return ListTile(
      title: ConstantWidget.getCustomText(
          s,
          ConstantData.textColor,
          1,
          TextAlign.start,
          FontWeight.w500,
          ConstantWidget.getScreenPercentSize(context, 2.3)),
      leading: ConstantWidget.getCustomIcon(context, icon),
      onTap: () => function,
    );
  }

  static Widget getCustomIcon(BuildContext context, var icon) {
    return Icon(
      icon,
      size: ConstantWidget.getScreenPercentSize(context, 3.7),
      color: ConstantData.textColor,
    );
  }

  static Widget getUnderlineText(String text, Color color, int maxLine,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: textSizes,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getCustomTextWithAlign(
      String text, Color color, TextAlign textAlign, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontFamily: ConstantData.fontFamily,
          decoration: TextDecoration.none,
          fontWeight: fontWeight),
    );
  }

  static Widget getCustomTextWithoutAlign(
      String text, Color color, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: ConstantData.fontFamily,
          decoration: TextDecoration.none,
          fontWeight: fontWeight),
    );
  }

  static double getHeaderSize(BuildContext context) {
    return ConstantWidget.getScreenPercentSize(context, 3);
  }

  static double getSubTitleSize(BuildContext context) {
    return ConstantWidget.getScreenPercentSize(context, 2);
  }

  static double getActionTextSize(BuildContext context) {
    return ConstantWidget.getScreenPercentSize(context, 1.8);
  }

  static double getDefaultDialogPadding(BuildContext context) {
    return ConstantWidget.getScreenPercentSize(context, 2);
  }

  static double getDefaultDialogRadius(BuildContext context) {
    return ConstantWidget.getScreenPercentSize(context, 1);
  }

  static double getScreenPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height * percent) / 100;
  }

  static double getWidthPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width * percent) / 100;
  }

  static Widget getSpace(double space) {
    return SizedBox(
      height: space,
    );
  }

  static Widget getCustomText(String text, Color color, int maxLine,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getTextWidget(String text, Color color, TextAlign textAlign,
      FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getSpaceTextWidget(String text, Color color,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          height: 1.5,
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getSpaceTextWidgetWithMaxLine(
      String text,
      Color color,
      TextAlign textAlign,
      int maxLine,
      FontWeight fontWeight,
      double textSizes) {
    return Text(
      text,
      maxLines: maxLine,
      style: TextStyle(
          height: 1.5,
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getRoundCornerButtonWithoutIcon(String texts, Color color,
      Color textColor, double btnRadius, Function function) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(btnRadius),
              shape: BoxShape.rectangle,
              color: color,
              // border: BorderSide(color: borderColor, width: 1)
            ),

            // shape: RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(btnRadius),
            //     side: BorderSide(color: borderColor, width: 1)),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),

            child: Center(
              child: getCustomText(
                  texts, textColor, 1, TextAlign.center, FontWeight.w500, 18),
            ),
          )
        ],
      ),
      onTap: () => function,
    );
  }

  static Widget getRoundCornerButton(String texts, Color color, Color textColor,
      IconData icons, double btnRadius, Function function) {
    return InkWell(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(btnRadius),
            shape: BoxShape.rectangle,
            color: color,
          ),

          //
          //
          // shape: RoundedRectangleBorder(
          //   borderRadius: new BorderRadius.circular(btnRadius),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          // onPressed: () {
          //   function();
          // },

          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstantWidget.getCustomText(
                  texts, textColor, 1, TextAlign.center, FontWeight.w400, 18),
              const SizedBox(
                width: 15,
              ),
              Icon(
                icons,
                size: 25,
                color: textColor,
              )
              // Icon(
              //
              //   icons,
              //   size: 25,
              //   color: textColor,
              // )
            ],
          )),
      onTap: () => function,
    );
  }

  static Widget getCustomTextWithoutSize(
      String text, Color color, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight),
    );
  }

  static Widget getCustomTextWithFontSize(
      String text, Color color, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: ConstantData.fontFamily,
          decoration: TextDecoration.none,
          fontWeight: fontWeight),
    );
  }

  static Widget getRoundCornerBorderButton(String texts, Color color,
      Color borderColor, Color textColor, double btnRadius, Function function) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(btnRadius),
              shape: BoxShape.rectangle,
              border: Border.all(color: borderColor, width: 1),
              color: color,
              // border: BorderSide(color: borderColor, width: 1)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Center(
              child: getCustomText(
                  texts, textColor, 1, TextAlign.center, FontWeight.w500, 18),
            ),
          )
        ],
      ),
      onTap: () => function,
    );
  }

  static Widget getLargeBoldTextWithMaxLine(
      String text, Color color, int maxLine) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: largeTextSize,
          color: color,
          fontFamily: ConstantData.fontFamily,
          fontWeight: FontWeight.w600),
      maxLines: maxLine,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget getDefaultTextWidget(String s, TextAlign textAlign,
      FontWeight fontWeight, double fontSize, var color) {
    return Text(
      s,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: ConstantData.fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color),
    );
  }

  static Widget textOverFlowWidget(String s, FontWeight fontWeight, int maxLine,
      double fontSize, Color color) {
    return Text(
      s,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: ConstantData.fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static Widget getDefaultTextFiledWidget(BuildContext context, String s,
      TextEditingController textEditingController) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: ConstantData.cellColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: TextField(
        maxLines: 1,
        controller: textEditingController,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.textColor,
            fontWeight: FontWeight.w400,
            fontSize: fontSize),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: ConstantWidget.getWidthPercentSize(context, 2)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: s,
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily,
                color: ConstantData.textColor,
                fontWeight: FontWeight.w400,
                fontSize: fontSize)),
      ),
    );
  }

  static Widget getLineTextView(String s, var color, var fontSize) {
    return Text(
      s,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontFamily: ConstantData.fontFamily,
        fontWeight: FontWeight.w400,
        decorationColor:
            // ignore: unnecessary_null_comparison
            (s.isNotEmpty || s != null) ? color : Colors.transparent,
        decorationStyle: TextDecorationStyle.solid,
        decoration: TextDecoration.lineThrough,
        fontSize: fontSize,
      ),
    );
  }

  static Widget getPrescriptionTextFiled(
      BuildContext context,
      var icon,
      String s,
      TextEditingController textEditingController,
      Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return InkWell(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        padding: EdgeInsets.symmetric(
            horizontal: ConstantWidget.getWidthPercentSize(context, 2)),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: ConstantData.cellColor,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: TextField(
          maxLines: 1,
          controller: textEditingController,
          enabled: false,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.textColor,
              fontWeight: FontWeight.w400,
              fontSize: fontSize),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: height / 3.5),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixIcon: Icon(icon, color: ConstantData.textColor),
              hintText: s,
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize)),
        ),
      ),
      onTap: () => function,
    );
  }

  static Widget getPrescriptionDesc(BuildContext context, String s,
      TextEditingController textEditingController) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
      padding: EdgeInsets.symmetric(
          horizontal: ConstantWidget.getWidthPercentSize(context, 2)),
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        color: ConstantData.cellColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: TextField(
        maxLines: 6,
        controller: textEditingController,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.textColor,
            fontWeight: FontWeight.w400,
            fontSize: fontSize),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: height / 3.1),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: s,
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily,
                color: ConstantData.textColor,
                fontWeight: FontWeight.w400,
                fontSize: fontSize)),
      ),
    );
  }

  static Widget getPasswordTextFiled(BuildContext context, String s,
      TextEditingController textEditingController) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return Container(
        height: height,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: BoxDecoration(
          color: ConstantData.cellColor,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: TextField(
          maxLines: 1,
          obscureText: true,
          controller: textEditingController,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.textColor,
              fontWeight: FontWeight.w400,
              fontSize: fontSize),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: ConstantWidget.getWidthPercentSize(context, 2)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: s,
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize)),
        ));
  }

  static Widget getBirthTextFiled(BuildContext context, String s,
      TextEditingController textEditingController, Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 6);
    double borderWidth = ConstantWidget.getPercentSize(height, 0.7);
    double radius = ConstantWidget.getPercentSize(height, 34);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return InkWell(
      child: Container(
          height: height,
          margin: EdgeInsets.symmetric(
              vertical: ConstantWidget.getScreenPercentSize(context, 0.8)),
          child: TextField(
            maxLines: 1,
            controller: textEditingController,
            style: TextStyle(
                fontFamily: ConstantData.fontFamily,
                color: ConstantData.textColor,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: ConstantWidget.getWidthPercentSize(context, 2)),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: ConstantWidget.getPercentSize(height, 50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantData.textColor, width: borderWidth),
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ConstantData.textColor, width: borderWidth),
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius),
                  ),
                ),
                hintText: s,
                hintStyle: TextStyle(
                    fontFamily: ConstantData.fontFamily,
                    color: ConstantData.textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          )),
      onTap: () => function,
    );
  }

  static SnackBar customSnackBar(
      {required String text, required BuildContext context}) {
    return SnackBar(
        content: getTextWidget(
      text,
      ConstantData.bgColor,
      TextAlign.left,
      FontWeight.w500,
      font18Px(context: context),
    ));
  }

  static Widget getButtonWidget(
    BuildContext context,
    String s,
    var color,
  ) {
    // S
    double height = ConstantWidget.getScreenPercentSize(context, 7.5);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Center(
          child: getDefaultTextWidget(
              s,
              TextAlign.center,
              FontWeight.w500,
              fontSize,
              (color == ConstantData.primaryColor)
                  ? Colors.white
                  : ConstantData.mainTextColor)),
    );
  }

  static Widget loadingIndicator(
      BuildContext context, Color color, double height) {
    return SizedBox(
      height: height,
      width: height,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }

  static Widget linearLoadingIndicator(
      BuildContext context, Color color, double height) {
    return SizedBox(
      child: LinearProgressIndicator(
        color: ConstantData.mainTextColor,
        backgroundColor: ConstantData.cellColor,
        // value: 1,
        minHeight: 5,
      ),
    );
  }

  static Widget adminStatusbanner(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
                top: blockSizeVertical(context: context) * 3,
                bottom: blockSizeVertical(context: context)),
            // alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                color: ConstantData.accentColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: getCustomText(
                'Admin Approval Pending',
                ConstantData.bgColor,
                1,
                TextAlign.center,
                FontWeight.bold,
                font18Px(context: context)),
          ),
        ),
      ],
    );
  }

  static Widget socialWidget(
      BuildContext context, ValueChanged<bool> onChanged) {
    double margin = getScreenPercentSize(context, 5);
    double cellSize = getScreenPercentSize(context, 5.5);

    return Container(
      margin: EdgeInsets.only(bottom: margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: (margin / 2)),
              height: cellSize,
              width: cellSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ConstantData.textColor.withOpacity(0.3),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  ConstantData.assetsPath + "google_icon.png",
                  height: cellSize,
                ),
              ),
            ),
            onTap: () {
              onChanged(true);
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: (margin / 2)),
              height: cellSize,
              width: cellSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ConstantData.textColor.withOpacity(0.3),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  ConstantData.assetsPath + "fb_icon.png",
                  height: cellSize,
                ),
              ),
            ),
            onTap: () {
              onChanged(false);
            },
          ),
        ],
      ),
    );
  }
}
