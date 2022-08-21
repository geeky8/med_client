// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'constant_data.dart';
import 'constant_widget.dart';

class ThankYouDialog extends StatefulWidget {
  final BuildContext context;
  final ValueChanged<int> onChanged;

  @override
  _ThankYouDialog createState() {
    return _ThankYouDialog();
  }

  const ThankYouDialog(this.context, this.onChanged, {Key? key})
      : super(key: key);
}

class _ThankYouDialog extends State<ThankYouDialog> {
  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 70);
    double radius = ConstantWidget.getPercentSize(height, 2);
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0.0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: dialogContent(context, setState),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  dialogContent(BuildContext context, var setState) {
    double height = ConstantWidget.getScreenPercentSize(context, 60);
    double width = ConstantWidget.getWidthPercentSize(context, 90);
    double radius = ConstantWidget.getPercentSize(height, 2);
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all((radius)),
      decoration: BoxDecoration(
        color: ConstantData.cellColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: ConstantData.shadowColor,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ConstantData.assetsPath + "accept-circular-button-outline.png",
                color: ConstantData.primaryColor,
                height: ConstantWidget.getPercentSize(height, 18),
                width: ConstantWidget.getPercentSize(height, 18),
              ),
              SizedBox(
                height: ConstantWidget.getPercentSize(
                  height,
                  5,
                ),
              ),
              ConstantWidget.getTextWidget(
                  'thankYou',
                  ConstantData.mainTextColor,
                  TextAlign.center,
                  FontWeight.w500,
                  ConstantWidget.getPercentSize(height, 7)),
              SizedBox(
                height: ConstantWidget.getPercentSize(
                  height,
                  6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      // fontWeight: FontWeight.w500,
                      fontSize: font18Px(context: context),
                      fontFamily: ConstantData.fontFamily,
                      color: ConstantData.mainTextColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'Your order'),
                      TextSpan(
                          text: ' #345678 ',
                          style: TextStyle(
                              fontSize: font18Px(context: context),
                              fontWeight: FontWeight.w500,
                              color: ConstantData.textColor)),
                      const TextSpan(text: 'is Completed.'),
                    ],
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: font12Px(context: context),
                    fontFamily: ConstantData.fontFamily,
                    color: ConstantData.mainTextColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Please check the Delivery status at',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: font18Px(context: context),
                            color: ConstantData.textColor)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => OrderTrackMap(),
                            //     ));
                          },
                        text: '\nOrder Tracking ',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            fontSize: font22Px(context: context),
                            color: ConstantData.accentColor)),
                    TextSpan(
                        text: ' pages.',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: font18Px(context: context),
                            color: ConstantData.textColor)),
                  ],
                ),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 3),
              ),
            ],
          )),
          // Expanded(child: Align(alignment: Alignment.bottomCenter,child: ConstantWidget.getBottomText(context, S.of(context)!.goToOrder, (){
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MyOrderPage(false),
          //       ));
          // }),))

          // ConstantWidget.getBottomText(context, 'goToOrder', () {
          //   // Navigator.pushReplacement(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //       builder: (context) => MyOrderPage(false),
          //   //     ));
          // })
        ],
      ),
    );
  }
}
