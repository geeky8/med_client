import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:intl/intl.dart';

typedef TextFieldValidator = String? Function(String?)?;

String? validator(String? value) {
  if (value != null) {
    if (value.isEmpty) {
      return 'Invalid';
    }
  }
  return null;
}

InputDecoration TextFieldDecoration(
    {required BuildContext context,
    required String labelName,
    required String hintName,
    bool? onTap}) {
  return InputDecoration(
    labelText: labelName,
    hintText: hintName,
    labelStyle: TextStyle(
      color: ConstantData.mainTextColor,
      fontSize: font18Px(context: context),
      fontFamily: ConstantData.fontFamily,
      fontWeight: FontWeight.w500,
    ),
    prefix: (onTap != null)
        ? Icon(
            CupertinoIcons.calendar,
            size: font18Px(context: context),
            color: ConstantData.mainTextColor,
          )
        : null,
    hintStyle: TextStyle(
      color: ConstantData.clrBorder,
      fontSize: font18Px(context: context),
      fontFamily: ConstantData.fontFamily,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: TextStyle(
      color: ConstantData.color1,
      fontSize: font15Px(context: context),
      fontFamily: ConstantData.fontFamily,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        font18Px(context: context),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ConstantData.primaryColor),
      borderRadius: BorderRadius.circular(
        font18Px(context: context),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ConstantData.primaryColor),
      borderRadius: BorderRadius.circular(
        font18Px(context: context),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ConstantData.color1),
      borderRadius: BorderRadius.circular(
        font18Px(context: context),
      ),
    ),
  );
}

Widget CustomTextField({
  required BuildContext context,
  required String hintName,
  required String labelName,
  required TextInputType keyboardType,
  required TextInputAction textInputAction,
  TextFieldValidator validator,
  required TextEditingController controller,
  bool? onTap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: blockSizeVertical(context: context) * 2,
    ),
    child: TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: (onTap != null)
          ? () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                final formattedDate =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
                controller.text = formattedDate.toString();
              }
            }
          : () {},
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: TextStyle(
        fontSize: font22Px(context: context),
        fontFamily: ConstantData.fontFamily,
        color: ConstantData.mainTextColor,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
      decoration: TextFieldDecoration(
        context: context,
        hintName: hintName,
        labelName: labelName,
      ),
    ),
  );
}
