// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/screens/profile_screen.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.1;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    final store = context.read<ProfileStore>();
    final loginStore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();

    return Scaffold(
      bottomNavigationBar: Observer(builder: (_) {
        final model = store.profileModel;
        return ConstantWidget.getBottomButton(
          context: context,
          height: blockSizeVertical(context: context),
          func: () async {
            final phone = await DataBox().readPhoneNo();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                        value: store,
                        child: Provider.value(
                          value: loginStore,
                          child: Provider.value(
                            value: productStore,
                            child: Provider.value(
                              value: bottomNavigationStore,
                              child: ProfilePage(
                                model: model,
                                phone: phone,
                                // beginToFill: '',
                              ),
                            ),
                          ),
                        ))));
          },
          label: 'Update',
        );
      }),
      body: Column(
        children: [
          ConstantWidget.customAppBar(context: context, title: 'Profile'),
          Observer(builder: (_) {
            final adminStatus = loginStore.loginModel.adminStatus;
            return Offstage(
              offstage: adminStatus,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    ConstantWidget.adminStatusbanner(context),
                    // SizedBox(
                    //     height: blockSizeHorizontal(context: context) * 20),
                  ],
                ),
              ),
            );
          }),
          Expanded(
            child: Observer(builder: (_) {
              final model = store.profileModel;

              return RefreshIndicator(
                onRefresh: () async {
                  await store.getProfile();
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                        height: profileHeight + (profileHeight / 5),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: profileHeight,
                                  width: profileHeight,
                                  decoration: BoxDecoration(
                                      color: ConstantData.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ConstantData.primaryColor,
                                          width: ConstantWidget
                                              .getScreenPercentSize(
                                                  context, 0.2))),
                                  child: ClipOval(
                                    child: Material(
                                      // color: ConstantData.primaryColor,
                                      child: Image.asset(
                                        "${ConstantData.assetsPath}med_logo.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    FirmInfoModule(
                      defaultMargin: defaultMargin,
                      editTextHeight: editTextHeight,
                      model: model,
                      store: store,
                    ),
                    if (model.gstModel.toFill)
                      GSTInfoModule(
                        defaultMargin: defaultMargin,
                        editTextHeight: editTextHeight,
                        model: model,
                      ),
                    if (model.drugLicenseModel.toFill)
                      DrugLicenseInfoModule(
                        defaultMargin: defaultMargin,
                        editTextHeight: editTextHeight,
                        model: model,
                      ),
                    if (model.fssaiModel.toFill)
                      FSSAIInfoModule(
                        defaultMargin: defaultMargin,
                        editTextHeight: editTextHeight,
                        model: model,
                      )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class FSSAIInfoModule extends StatelessWidget {
  const FSSAIInfoModule({
    Key? key,
    required this.defaultMargin,
    required this.editTextHeight,
    required this.model,
  }) : super(key: key);

  final double defaultMargin;
  final double editTextHeight;
  final ProfileModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultMargin),
      color: ConstantData.cellColor,
      padding: EdgeInsets.all(defaultMargin),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstantWidget.getCustomTextWithoutAlign(
              'FSSAI License',
              ConstantData.mainTextColor,
              FontWeight.w500,
              font18Px(context: context) * 1.1,
            ),
          ),
          SizedBox(
            height: (defaultMargin) * 2,
          ),
          Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(
                //     vertical: (defaultMargin / 2)),
                padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                height: editTextHeight,
                child: Fields(
                  value: model.fssaiModel.number,
                  label: 'FSSAI Number',
                ),
              ),
            ],
          ),
          SizedBox(
            height: (defaultMargin) / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CertiifcateView(
                defaultMargin: defaultMargin,
                label: 'FSSAI Certificate',
                img: model.fssaiModel.fssaiImg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CertiifcateView extends StatelessWidget {
  const CertiifcateView({
    Key? key,
    required this.defaultMargin,
    required this.label,
    required this.img,
  }) : super(key: key);

  final double defaultMargin;
  final String label;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstantWidget.getCustomTextWithoutAlign(
          label,
          ConstantData.mainTextColor,
          FontWeight.w500,
          font15Px(context: context) * 1.1,
        ),
        SizedBox(
          height: (defaultMargin) / 2,
        ),
        InkWell(
          onTap: () async {
            final phone = await DataBox().readPhoneNo();
            showDialog(
                context: context,
                builder: (_) {
                  return CertificateDialog(
                    url: img,
                    phone: phone,
                  );
                });
          },
          child: SizedBox(
            width: ConstantWidget.getWidthPercentSize(context, 20),
            height: ConstantWidget.getScreenPercentSize(context, 8),
            child: ConstantWidget.getButtonWidget(
                context, 'View', ConstantData.primaryColor),
          ),
        ),
      ],
    );
  }
}

class DrugLicenseInfoModule extends StatelessWidget {
  const DrugLicenseInfoModule({
    Key? key,
    required this.defaultMargin,
    required this.editTextHeight,
    required this.model,
  }) : super(key: key);

  final double defaultMargin;
  final double editTextHeight;
  final ProfileModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultMargin),
      color: ConstantData.cellColor,
      padding: EdgeInsets.all(defaultMargin),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstantWidget.getCustomTextWithoutAlign(
              'Drug License',
              ConstantData.mainTextColor,
              FontWeight.w500,
              font18Px(context: context) * 1.1,
            ),
          ),
          SizedBox(
            height: (defaultMargin) * 2,
          ),
          Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(
                //     vertical: (defaultMargin / 2)),
                padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                height: editTextHeight,
                child: Fields(
                  value: model.drugLicenseModel.name,
                  label: 'Drug License Name',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.drugLicenseModel.number,
                        label: 'Drug License Number',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.drugLicenseModel.validity,
                        label: 'Drug License Validity',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: (defaultMargin) / 2,
          ),
          Padding(
            padding: EdgeInsets.only(right: defaultMargin / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CertiifcateView(
                  defaultMargin: defaultMargin,
                  label: 'DL Certificate 1',
                  img: model.drugLicenseModel.dlImg1,
                ),
                CertiifcateView(
                  defaultMargin: defaultMargin,
                  label: 'DL Certificate 2',
                  img: model.drugLicenseModel.dlImg2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CertificateDialog extends StatelessWidget {
  const CertificateDialog({
    Key? key,
    required this.phone,
    required this.url,
  }) : super(key: key);

  final String url;
  final String phone;

  @override
  Widget build(BuildContext context) {
    double height = ConstantWidget.getScreenPercentSize(context, 70);
    double radius = ConstantWidget.getPercentSize(height, 2);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(blockSizeHorizontal(context: context) * 5),
        width: ConstantWidget.getWidthPercentSize(context, 70),
        decoration: BoxDecoration(
          color: ConstantData.bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: CachedNetworkImage(
          imageUrl: '${ConstantData.licenseUrl}$phone/$url',
          fit: BoxFit.cover,
          errorWidget: (context, e, _) => SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 20),
            width: ConstantWidget.getWidthPercentSize(context, 40),
            child: ConstantWidget.errorWidget(
              context: context,
              height: 20,
              width: 25,
              // fontSize: font15Px(context: context),
            ),
          ),
          placeholder: (
            context,
            _,
          ) {
            return Image.asset('${ConstantData.assetsPath}med_logo.png');
          },
        ),
      ),
    );
  }
}

class GSTInfoModule extends StatelessWidget {
  const GSTInfoModule({
    Key? key,
    required this.defaultMargin,
    required this.editTextHeight,
    required this.model,
  }) : super(key: key);

  final double defaultMargin;
  final double editTextHeight;
  final ProfileModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultMargin),
      color: ConstantData.cellColor,
      padding: EdgeInsets.all(defaultMargin),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstantWidget.getCustomTextWithoutAlign(
              'GST Details',
              ConstantData.mainTextColor,
              FontWeight.w500,
              font18Px(context: context) * 1.1,
            ),
          ),
          SizedBox(
            height: (defaultMargin) * 2,
          ),
          Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(
                //     vertical: (defaultMargin / 2)),
                padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                height: editTextHeight,
                child: Fields(
                  value: model.gstModel.gstNo,
                  label: 'GST Number',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FirmInfoModule extends StatelessWidget {
  const FirmInfoModule({
    Key? key,
    required this.defaultMargin,
    required this.editTextHeight,
    required this.model,
    required this.store,
  }) : super(key: key);

  final double defaultMargin;
  final double editTextHeight;
  final ProfileModel model;
  final ProfileStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultMargin),
      color: ConstantData.cellColor,
      padding: EdgeInsets.all(defaultMargin),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstantWidget.getCustomTextWithoutAlign(
              'Firm Details',
              ConstantData.mainTextColor,
              FontWeight.w500,
              font18Px(context: context) * 1.1,
            ),
          ),
          SizedBox(
            height: (defaultMargin) * 2,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.firmInfoModel.firmName,
                        label: 'Name',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.firmInfoModel.phone,
                        label: 'Phone',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(
                //     vertical: (defaultMargin / 2)),
                padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                height: editTextHeight,
                child: Fields(
                  value: model.firmInfoModel.address,
                  label: 'Address',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: store.getCountry(
                            countryId: int.parse(model.firmInfoModel.country)),
                        label: 'Country',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: store.getState(
                            stateId: int.parse(model.firmInfoModel.state)),
                        label: 'State',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: store.getCityName(
                            cityId: int.parse(model.firmInfoModel.city)),
                        label: 'City',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: store.getArea(
                            areaId: int.parse(model.firmInfoModel.pin)),
                        label: 'Area',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(
                //     vertical: (defaultMargin / 2)),
                padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                height: editTextHeight,
                child: Fields(
                  value: model.firmInfoModel.contactName,
                  label: 'Contact Person',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.firmInfoModel.contactNo,
                        label: 'Person Number',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //     vertical: (defaultMargin / 2)),
                      padding: EdgeInsets.only(right: (defaultMargin / 1.5)),
                      height: editTextHeight,
                      child: Fields(
                        value: model.firmInfoModel.altContactNo,
                        label: 'Alternate Contact',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Fields extends StatelessWidget {
  const Fields({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: value,
      style: TextStyle(
        color: ConstantData.mainTextColor,
        fontFamily: ConstantData.fontFamily,
        fontSize: font18Px(context: context),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true,

        disabledBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: BorderSide(color: ConstantData.textColor, width: 0.5),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantData.mainTextColor, width: 1.0),
        ),

        labelStyle: TextStyle(
          fontFamily: ConstantData.fontFamily,
          color: ConstantData.mainTextColor,
        ),
        labelText: label,
        // hintText: hintText,
      ),
    );
  }
}
