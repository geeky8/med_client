import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

typedef SelectedWidget = List<Widget> Function(BuildContext);
typedef OnChanged = void Function(String?);

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    this.value,
    required this.hint,
    required this.itemList,
    required this.onChanged,
    required this.selectFunc,
  }) : super(key: key);

  final String? value;
  final SelectedWidget selectFunc;
  final OnChanged onChanged;
  final String hint;
  final List<DropdownMenuItem<String>> itemList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context) * 2,
      ),
      child: Container(
        width: ConstantWidget.getWidthPercentSize(context, 30),
        padding: EdgeInsets.symmetric(
          horizontal: blockSizeHorizontal(context: context) * 4,
          // vertical: blockSizeVertical(context: context),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: ConstantData.clrBorder),
          borderRadius: BorderRadius.circular(
            font15Px(context: context),
          ),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          alignment: AlignmentDirectional.bottomStart,
          // selectedItemBuilder: (BuildContext context) => store.cityList
          //     .map<Widget>(
          //       (element) => Center(
          //         child: ConstantWidget.getCustomText(
          //           element.cityName,
          //           ConstantData.mainTextColor,
          //           1,
          //           TextAlign.center,
          //           FontWeight.w500,
          //           font18Px(context: context),
          //         ),
          //       ),
          //     )
          //     .toList(),
          selectedItemBuilder: selectFunc,
          hint: Center(
            child: ConstantWidget.getCustomText(
              hint,
              ConstantData.mainTextColor,
              1,
              TextAlign.center,
              FontWeight.w500,
              font18Px(context: context),
            ),
          ),
          disabledHint: Center(
            child: ConstantWidget.getCustomText(
              hint,
              ConstantData.mainTextColor,
              1,
              TextAlign.center,
              FontWeight.w500,
              font18Px(context: context),
            ),
          ),
          items: itemList,
          underline: Container(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
