// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/storage.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: blockSizeHorizontal(context: context) * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ConstantData.assetsPath + 'med_logo_text_img.png',
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: blockSizeVertical(context: context) * 8,
              ),
              InkWell(
                onTap: () async {
                  // await DataBox().removeDataBox();
                },
                child: ConstantWidget.getButtonWidget(
                    context, 'Remove Data', ConstantData.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
