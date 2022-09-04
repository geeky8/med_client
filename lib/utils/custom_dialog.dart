import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/size_config.dart';

import 'constant_data.dart';
import 'constant_widget.dart';

class CustomDialog extends StatefulWidget {
  final BuildContext context;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  _CustomDialog createState() {
    return _CustomDialog();
  }

  const CustomDialog(this.context, this.index, this.onChanged, {Key? key})
      : super(key: key);
}

class _CustomDialog extends State<CustomDialog> {
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

  late int position;

  @override
  void initState() {
    super.initState();
    position = widget.index;
    setState(() {});
  }

  dialogContent(BuildContext context, var setState) {
    // int position =await PrefData.getPosition() ;

    // setThemePosition( setState);

    double height = ConstantWidget.getScreenPercentSize(context, 40);
    double width = ConstantWidget.getWidthPercentSize(context, 90);
    double radius = ConstantWidget.getPercentSize(height, 2);
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all((radius * 2)),
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
      child: Stack(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.center,
          //   child: NumberPicker(
          //     value: position,
          //     minValue: 1,
          //     maxValue: 50,
          //     textStyle: TextStyle(
          //         fontSize: ConstantWidget.getScreenPercentSize(context, 2),
          //         color: ConstantData.mainTextColor,
          //         fontFamily: ConstantData.fontFamily),
          //     selectedTextStyle: TextStyle(
          //         fontSize: ConstantWidget.getScreenPercentSize(context, 5),
          //         color: ConstantData.accentColor,
          //         fontFamily: ConstantData.fontFamily),
          //     step: 1,
          //     haptics: true,
          //     onChanged: (value) => setState(() {
          //       position = value;
          //     }),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              child: ConstantWidget.getTextWidget(
                'ok',
                ConstantData.accentColor,
                TextAlign.start,
                FontWeight.w600,
                font22Px(context: context),
              ),
              onTap: () {
                widget.onChanged(position);
                Navigator.pop(widget.context);
              },
            ),
          )
        ],
      ),
    );
  }
}
