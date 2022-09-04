import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class UpdateAppScreen extends StatelessWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: blockSizeHorizontal(context: context) * 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('${ConstantData.assetsPath}med_logo.png'),
              SizedBox(
                height: blockSizeVertical(context: context) * 3,
              ),
              ConstantWidget.getCustomText(
                'To continue, kindly update the app',
                ConstantData.mainTextColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font22Px(context: context),
              ),
              SizedBox(
                height: blockSizeVertical(context: context) * 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 5,
                ),
                child: ConstantWidget.getBottomButton(
                  context: context,
                  func: () async {
                    // const url =
                    //     'https://play.google.com/store/apps/details?id=com.mederpha.medclient';
                    // if (await canLaunchUrl(Uri.parse(url))) {
                    //   await launchUrl(Uri.parse(url));
                    // } else {
                    //   final snackBar = ConstantWidget.customSnackBar(
                    //     text:
                    //         'Failed to redirect to update the app. Please try again',
                    //     context: context,
                    //   );
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                    await LaunchReview.launch(
                        androidAppId: 'com.mederpha.medclient');
                  },
                  label: 'Update App',
                  height: blockSizeVertical(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
