import 'package:flutter/material.dart';

import 'constant_data.dart';
import 'constant_widget.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, descriptions, text;
  final Image? img;
  final Function func;

  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.descriptions,
    required this.text,
    this.img,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: ConstantData.bgColor,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: ConstantData.padding,
              top: ConstantData.avatarRadius + ConstantData.padding,
              right: ConstantData.padding,
              bottom: ConstantData.padding),
          margin: const EdgeInsets.only(top: ConstantData.avatarRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstantWidget.getCustomText(title, ConstantData.mainTextColor, 1,
                  TextAlign.center, FontWeight.w600, 20),
              const SizedBox(
                height: 10,
              ),
              ConstantWidget.getCustomText(
                  descriptions,
                  ConstantData.mainTextColor,
                  2,
                  TextAlign.center,
                  FontWeight.normal,
                  14),
              const SizedBox(
                height: 22,
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                width: double.infinity,
                child: ConstantWidget.getRoundCornerButtonWithoutIcon(
                  text,
                  ConstantData.primaryColor,
                  Colors.white,
                  20,
                  () {
                    func;
                  },
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: ConstantData.padding,
          right: ConstantData.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: ConstantData.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(ConstantData.avatarRadius)),
                child: Image.asset(
                  ConstantData.assetsPath + "security.png",
                  color: ConstantData.mainTextColor,
                )),
          ),
        ),
      ],
    );
  }
}
