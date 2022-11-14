import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

typedef SelectedWidget = List<Widget> Function(BuildContext);
typedef OnChanged = void Function(String?);
typedef DropDownValidte = String? Function(String?)?;

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    this.value,
    required this.hint,
    required this.itemList,
    required this.onChanged,
    required this.selectFunc,
    required this.dropDownValidte,
    this.onTap,
  }) : super(key: key);

  final String? value;
  final SelectedWidget selectFunc;
  final OnChanged onChanged;
  final String hint;
  final List<DropdownMenuItem<String>> itemList;
  final DropDownValidte dropDownValidte;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context) * 2,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: onTap,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontFamily: ConstantData.fontFamily,
            fontSize: font12Px(context: context) * 1.1,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
        ),
        alignment: AlignmentDirectional.bottomStart,
        focusColor: Colors.transparent,
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
        validator: dropDownValidte,

        // underline: Container(),
        onChanged: onChanged,
      ),
    );
  }
}
