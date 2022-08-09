import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class OrderDialog extends StatelessWidget {
  const OrderDialog({
    Key? key,
    required this.func,
    required this.image,
    required this.label,
    required this.text,
  }) : super(key: key);

  final String label;
  final String image;
  final VoidCallback func;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      child: Container(
        height: ConstantWidget.getScreenPercentSize(context, 60),
        decoration: BoxDecoration(
          color: ConstantData.bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 27),
                  child: Image.asset(
                    ConstantData.assetsPath + image,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: blockSizeHorizontal(context: context) * 3,
                        ),
                        child: ConstantWidget.getCustomText(
                          text,
                          ConstantData.mainTextColor,
                          2,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: func,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 4,
                  vertical: blockSizeVertical(context: context) * 2,
                ),
                decoration: BoxDecoration(
                  color: ConstantData.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ConstantWidget.getCustomText(
                  label,
                  ConstantData.bgColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font15Px(context: context) * 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
