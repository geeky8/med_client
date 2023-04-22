// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medrpha_customer/api_service.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/enums/license_type.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/screens/post_profile_screen.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/profile/utils/dropdown.dart';
import 'package:medrpha_customer/profile/widgets/widgets.dart';
import 'package:medrpha_customer/signup_login/screens/phone_verification_screen.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../api_service.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen(
      {required this.model, required this.phone, this.beginToFill, Key? key})
      : super(key: key);

  final ProfileModel model;
  final String phone;
  final bool? beginToFill;

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  final contactDetailsGlobalKey = GlobalKey<FormState>();
  final areaDetailsGlobalKey = GlobalKey<FormState>();
  final firmInfoGlobalKey = GlobalKey<FormState>();
  final gstGlobalKey = GlobalKey<FormState>();
  final dlGlobalKey = GlobalKey<FormState>();
  final fssaiGlobalKey = GlobalKey<FormState>();

  late final firmtNameController =
      TextEditingController(text: widget.model.firmInfoModel.firmName);
  late final mailController =
      TextEditingController(text: widget.model.firmInfoModel.email);
  late final addressController =
      TextEditingController(text: widget.model.firmInfoModel.address);
  late final phoneController =
      TextEditingController(text: widget.model.firmInfoModel.phone);

  late final contactNameController =
      TextEditingController(text: widget.model.firmInfoModel.contactName);
  late final contactController =
      TextEditingController(text: widget.model.firmInfoModel.contactNo);
  late final altContactController =
      TextEditingController(text: widget.model.firmInfoModel.altContactNo);

  // GST Page controllers
  late final gstNoController =
      TextEditingController(text: widget.model.gstModel.gstNo);

  // Drug License Controllers
  late final drugLicenseName =
      TextEditingController(text: widget.model.drugLicenseModel.name);
  late final drugLiscenseNo =
      TextEditingController(text: widget.model.drugLicenseModel.number);
  late final drugLicenseValidity =
      TextEditingController(text: widget.model.drugLicenseModel.validity);
  List<int> drugImgBytes = [];

  // FSSAI controllers
  late final fssaiNoController =
      TextEditingController(text: widget.model.fssaiModel.number);

  String? country;
  String? state;
  String? city;
  String? area;

  final dropdownList = List.unmodifiable(['Yes', 'No']);
  String gstSelection = 'No';
  String fssaiSelection = 'No';

  @override
  void initState() {
    final profileStore = context.read<ProfileStore>();
    profileStore.page = 0;
    country = (widget.beginToFill == null)
        ? profileStore.getCountry(
            countryId: int.parse(widget.model.firmInfoModel.country))
        : null;
    state = (widget.beginToFill == null)
        ? profileStore.getState(
            stateId: int.parse(widget.model.firmInfoModel.state))
        : null;
    city = (widget.beginToFill == null)
        ? profileStore.getCityName(
            cityId: int.parse(widget.model.firmInfoModel.city))
        : null;
    area = (widget.beginToFill == null)
        ? profileStore.getArea(
            areaId: int.parse(widget.model.firmInfoModel.pin))
        : null;

    gstSelection = (profileStore.profileModel.gstModel.toFill) ? 'Yes' : 'No';
    fssaiSelection =
        (profileStore.profileModel.fssaiModel.toFill) ? 'Yes' : 'No';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<ProfileStore>();
    final loginstore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();
    return Scaffold(
      backgroundColor: ConstantData.bgColor,
      appBar: AppBar(
        leading: Observer(builder: (_) {
          return IconButton(
            onPressed: () {
              if (store.page == 0) {
                Navigator.pop(context);
              } else {
                store.page--;
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: font18Px(context: context),
              color: ConstantData.mainTextColor,
            ),
          );
        }),
        centerTitle: true,
        backgroundColor: ConstantData.bgColor,
        title: ConstantWidget.getCustomText(
          'Edit Profile',
          ConstantData.mainTextColor,
          1,
          TextAlign.center,
          FontWeight.w600,
          font22Px(context: context),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: blockSizeHorizontal(context: context) * 4,
        ),
        child: SizedBox(
          height: ConstantWidget.getScreenPercentSize(context, 7),
          child: Observer(
            builder: (_) {
              return Column(
                children: [
                  if (store.certificateUploadingState == StoreState.LOADING ||
                      store.saveState == ButtonState.LOADING)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: blockSizeVertical(context: context)),
                      child: LinearProgressIndicator(
                        color: ConstantData.primaryColor,
                      ),
                    ),
                  Expanded(
                    child: Observer(builder: (_) {
                      return InkWell(
                        onTap: () {
                          switch (store.page) {
                            case 0:
                              if (contactDetailsGlobalKey.currentState!
                                  .validate()) {
                                final model =
                                    store.profileModel.firmInfoModel.copyWith(
                                  contactName:
                                      contactNameController.text.trim(),
                                  contactNo: contactController.text.trim(),
                                  altContactNo:
                                      altContactController.text.trim(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(firmInfoModel: model);

                                store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please review the contact details');
                              }
                              break;
                            case 1:
                              if (firmInfoGlobalKey.currentState!.validate()) {
                                final model =
                                    store.profileModel.firmInfoModel.copyWith(
                                  firmName: firmtNameController.text.trim(),
                                  address: addressController.text.trim(),
                                  email: mailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(firmInfoModel: model);

                                store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please review the firm details');
                              }
                              break;
                            case 2:
                              final countryIndex = store.countryList.indexWhere(
                                  (element) => element.countryName == country);
                              final stateIndex = store.stateList.indexWhere(
                                  (element) => element.stateName == state);

                              final cityIndex = store.cityList.indexWhere(
                                  (element) => element.cityName == city);

                              final areaIndex = store.areaList.indexWhere(
                                  (element) => element.areaName == area);
                              if (countryIndex != -1 &&
                                  stateIndex != -1 &&
                                  cityIndex != -1 &&
                                  areaIndex != -1) {
                                final model =
                                    store.profileModel.firmInfoModel.copyWith(
                                  country: store
                                      .countryList[countryIndex].countryId
                                      .toString(),
                                  state: store.stateList[stateIndex].stateId
                                      .toString(),
                                  city: store.cityList[cityIndex].cityId
                                      .toString(),
                                  pin: store.areaList[areaIndex].areaId
                                      .toString(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(firmInfoModel: model);

                                store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please review the location details');
                              }
                              break;

                            case 3:
                              if (store.profileModel.drugLicenseModel.dlImg1 ==
                                  "") {
                                Fluttertoast.showToast(
                                    msg: 'Upload drug certificate 1');
                              }
                              if (store.profileModel.drugLicenseModel.dlImg2 ==
                                  "") {
                                Fluttertoast.showToast(
                                    msg: 'Upload drug certificate 2');
                              }
                              if (dlGlobalKey.currentState!.validate() &&
                                  store.profileModel.drugLicenseModel.dlImg1 !=
                                      "" &&
                                  store.profileModel.drugLicenseModel.dlImg2 !=
                                      "") {
                                final model = store
                                    .profileModel.drugLicenseModel
                                    .copyWith(
                                  name: drugLicenseName.text.trim(),
                                  number: drugLiscenseNo.text.trim(),
                                  validity: drugLicenseValidity.text.trim(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(drugLicenseModel: model);

                                store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please review the Drug License details');
                              }
                              break;

                            case 4:
                              if (gstSelection == 'No') {
                                gstNoController.clear();
                                store.page += 1;
                              } else if (gstSelection == 'Yes' &&
                                  gstGlobalKey.currentState!.validate()) {
                                final model =
                                    store.profileModel.gstModel.copyWith(
                                  gstNo: gstNoController.text.trim(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(gstModel: model);

                                store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please review the GST details');
                              }
                              break;

                            case 5:
                              if (fssaiSelection == 'No') {
                                // store.page += 1;
                                fssaiNoController.clear();
                                final model = store.profileModel.fssaiModel
                                    .copyWith(fssaiImg: '');
                                store.profileModel = store.profileModel
                                    .copyWith(fssaiModel: model);
                              } else if (store
                                      .profileModel.fssaiModel.fssaiImg ==
                                  '') {
                                Fluttertoast.showToast(
                                    msg: 'Upload Fssai Certificate');
                              } else if (fssaiSelection == 'Yes' &&
                                  fssaiGlobalKey.currentState!.validate()) {
                                final model =
                                    store.profileModel.fssaiModel.copyWith(
                                  number: fssaiNoController.text.trim(),
                                );
                                store.profileModel = store.profileModel
                                    .copyWith(fssaiModel: model);

                                // store.page += 1;
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please review the FSSAI details');
                              }
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return CustomAlertDialog(
                                    header: 'Submit Details',
                                    description:
                                        'Clicking on submit you will submit your profile',
                                    func: () async {
                                      store.saveState = ButtonState.LOADING;

                                      Navigator.pop(context);

                                      /// Profile uploading
                                      if (widget.beginToFill != null) {
                                        await store.updateProfile(
                                          context: context,
                                          beginToFill: true,
                                          loginStore: loginstore,
                                        );
                                      } else {
                                        await store.updateProfile(
                                          context: context,
                                          loginStore: loginstore,
                                        );
                                      }
                                      store.saveState = ButtonState.SUCCESS;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MultiProvider(
                                            providers: [
                                              Provider.value(value: store),
                                              Provider.value(
                                                  value: orderHistoryStore),
                                              Provider.value(value: loginstore),
                                              Provider.value(
                                                value: bottomNavigationStore
                                                  ..currentPage = 0,
                                              ),
                                              Provider.value(
                                                value: productStore,
                                              ),
                                            ],
                                            child: ProfileSubmission(
                                              beginToFill: widget.beginToFill,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    buttonText: 'Submit',
                                  );
                                },
                              );

                              // Navigator.pop(context);
                              break;
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ConstantData.primaryColor,
                            borderRadius: BorderRadius.circular(
                              font18Px(context: context),
                            ),
                          ),
                          child: Observer(builder: (_) {
                            if (store.page == 5) {
                              return ConstantWidget.getCustomText(
                                'Submit',
                                ConstantData.bgColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font22Px(context: context),
                              );
                            }
                            return ConstantWidget.getCustomText(
                              'Next',
                              ConstantData.bgColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              font22Px(context: context),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: blockSizeVertical(context: context) * 3,
          left: blockSizeHorizontal(context: context) * 4,
          right: blockSizeHorizontal(context: context) * 4,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  ConstantWidget.getCustomText(
                    'Profile Completetion / ',
                    ConstantData.clrBorder,
                    1,
                    TextAlign.left,
                    FontWeight.w600,
                    font18Px(context: context) * 1.1,
                  ),
                  Observer(builder: (_) {
                    switch (store.page) {
                      case 0:
                        return ConstantWidget.getCustomText(
                          'Contact Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      case 1:
                        return ConstantWidget.getCustomText(
                          'Firm Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      case 2:
                        return ConstantWidget.getCustomText(
                          'Area Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      case 3:
                        return ConstantWidget.getCustomText(
                          'Drug License Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      case 4:
                        return ConstantWidget.getCustomText(
                          'GST Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      case 5:
                        return ConstantWidget.getCustomText(
                          'FSSAI Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                      default:
                        return ConstantWidget.getCustomText(
                          'Contact Details',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.left,
                          FontWeight.w500,
                          font18Px(context: context) * 1.1,
                        );
                    }
                  }),
                  const Spacer(),
                  Observer(builder: (_) {
                    return ConstantWidget.getCustomText(
                      '${(((store.page) / 5) * 100).toStringAsFixed(2)}%',
                      ConstantData.primaryColor,
                      1,
                      TextAlign.left,
                      FontWeight.w600,
                      font18Px(context: context) * 1.1,
                    );
                  }),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: blockSizeVertical(context: context) * 2.5,
                ),
                child: Observer(builder: (_) {
                  return LinearProgressIndicator(
                    color: ConstantData.primaryColor,
                    backgroundColor: ConstantData.cellColor,
                    value: ((store.page) / 5),
                    minHeight: blockSizeVertical(context: context) / 1.5,
                  );
                }),
              ),
              Observer(builder: (_) {
                final page = store.page;

                switch (page) {
                  case 0:
                    return ContactDetailWidget(context);
                  case 1:
                    return FirmDetailWidget(context);
                  case 2:
                    return AreaDetailWidget(context, store);
                  case 3:
                    return DLDetailWidget(context, store);
                  case 4:
                    return GSTDetailWidget(context, store);
                  case 5:
                    return FSSAIDetailWidget(context, store);
                  default:
                    return ContactDetailWidget(context);
                }
              }),
              // ContactDetailWidget(context),
              // FirmDetailWidget(context),
              // AreaDetailWidget(context, store),
              // DLDetailWidget(context, store),
              // GSTDetailWidget(context, store),
            ],
          ),
        ),
      ),
    );
  }

  /// - [Contact-Name] [Contact-Number] [Alt Contact-Number]
  Widget ContactDetailWidget(
    BuildContext context,
  ) {
    return Form(
      key: contactDetailsGlobalKey,
      child: Column(
        children: [
          CustomTextField(
            context: context,
            hintName: 'Enter Name',
            labelName: 'Contact Name',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Invalid Name';
                }
              }
            },
            controller: contactNameController,
          ),
          CustomTextField(
            context: context,
            hintName: '847474777',
            labelName: 'Contact Number',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null) {
                if (value.length != 10) {
                  return 'Invalid Number';
                }
              }
            },
            controller: contactController,
          ),
          CustomTextField(
            context: context,
            hintName: '847474777',
            labelName: 'Alternate Contact Number',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null) {
                if (value.length != 10) {
                  return 'Invalid Number';
                }
              }
            },
            controller: altContactController,
          ),
        ],
      ),
    );
  }

  /// - [FirmName] [Address] [E-mail] [Phone-Number]
  Widget FirmDetailWidget(
    BuildContext context,
  ) {
    final emailRegex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+");
    return Form(
      key: firmInfoGlobalKey,
      child: Column(
        children: [
          CustomTextField(
            context: context,
            hintName: 'Enter Name',
            labelName: 'Firm Name',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Invalid Name';
                }
              }
            },
            controller: firmtNameController,
          ),
          CustomTextField(
            context: context,
            hintName: '4A Chor Bazar',
            labelName: 'Address',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value != null) {
                if (value.split(' ').length < 2) {
                  return 'Invalid Address';
                }
              }
            },
            controller: addressController,
          ),
          CustomTextField(
            context: context,
            hintName: 'abc@gmail.com',
            labelName: 'E-mail',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null) {
                if (!emailRegex.hasMatch(value)) {
                  return 'Invalid E-mail';
                }
              }
            },
            controller: mailController,
          ),
          CustomTextField(
            context: context,
            hintName: '857575777',
            labelName: 'Phone Number',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null) {
                if (value.length != 10) {
                  return 'Invalid Number';
                }
              }
            },
            controller: phoneController,
          ),
        ],
      ),
    );
  }

  /// - [Country] [State] [City] [Area]
  Widget AreaDetailWidget(
    BuildContext context,
    ProfileStore store,
  ) {
    return Form(
      key: areaDetailsGlobalKey,
      child: Observer(
        builder: (_) {
          return Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ConstantWidget.getCustomText(
                                  'Country ',
                                  ConstantData.mainTextColor,
                                  1,
                                  TextAlign.left,
                                  FontWeight.w500,
                                  font22Px(context: context),
                                ),
                                ConstantWidget.getCustomText(
                                  '(Required)*',
                                  ConstantData.color1,
                                  1,
                                  TextAlign.left,
                                  FontWeight.w500,
                                  font22Px(context: context),
                                ),
                              ],
                            ),
                            CustomDropDown(
                              value: country,
                              hint: 'Select Country',
                              dropDownValidte: (value) {
                                if (value == null) return 'Enter Country';
                              },
                              itemList: store.countryList
                                  .map<DropdownMenuItem<String>>((element) {
                                return DropdownMenuItem<String>(
                                  value: element.countryName,
                                  child: ConstantWidget.getCustomText(
                                    element.countryName,
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w600,
                                    font15Px(context: context),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  country = value;
                                });
                              },
                              selectFunc: (BuildContext context) =>
                                  store.countryList
                                      .map<Widget>(
                                        (element) => Center(
                                          child: ConstantWidget.getCustomText(
                                            element.countryName,
                                            ConstantData.mainTextColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            font18Px(context: context),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Observer(builder: (_) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ConstantWidget.getCustomText(
                                    'State ',
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                  ConstantWidget.getCustomText(
                                    '(Required)*',
                                    ConstantData.color1,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                ],
                              ),
                              CustomDropDown(
                                value: (country != null) ? state : null,
                                hint: 'Select State',
                                dropDownValidte: (value) {
                                  if (country == null) {
                                    return 'Enter Country First';
                                  }
                                  if (value == null) return 'Enter State';
                                },

                                /// if country is not selected user won't be able to select city.
                                itemList: (country != null)
                                    ? store.stateList
                                        .map<DropdownMenuItem<String>>(
                                            (element) {
                                        return DropdownMenuItem<String>(
                                          value: element.stateName,
                                          child: ConstantWidget.getCustomText(
                                            element.stateName,
                                            ConstantData.mainTextColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            font15Px(context: context),
                                          ),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) async {
                                  setState(() {
                                    state = value;
                                  });
                                  final index = store.stateList.indexWhere(
                                      (element) => element.stateName == state);
                                  await store.getStateCitySpecific(
                                    id: store.stateList[index].stateId
                                        .toString(),
                                  );
                                },
                                selectFunc: (BuildContext context) =>
                                    store.stateList
                                        .map<Widget>(
                                          (element) => Center(
                                            child: ConstantWidget.getCustomText(
                                              element.stateName,
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              font18Px(context: context),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Observer(builder: (_) {
                          if (store.cityFetching == StoreState.LOADING) {
                            city = null;
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ConstantWidget.getCustomText(
                                    'City ',
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                  ConstantWidget.getCustomText(
                                    '(Required)*',
                                    ConstantData.color1,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                ],
                              ),
                              CustomDropDown(
                                value: city,
                                hint: 'Select City',
                                dropDownValidte: (value) {
                                  if (state == null) {
                                    return 'Enter State First';
                                  }
                                  if (value == null) return 'Enter City';
                                },

                                /// if state is not selected user won't be able to select city.
                                itemList: (state != null)
                                    ? store.cityList
                                        .map<DropdownMenuItem<String>>(
                                            (element) {
                                        return DropdownMenuItem<String>(
                                          value: element.cityName,
                                          child: ConstantWidget.getCustomText(
                                            element.cityName,
                                            ConstantData.mainTextColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            font15Px(context: context),
                                          ),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) async {
                                  setState(() {
                                    city = value;
                                  });
                                  final index = store.cityList.indexWhere(
                                      (element) => element.cityName == city);
                                  await store.getAreaCitySpecific(
                                    id: store.cityList[index].cityId.toString(),
                                  );
                                },
                                selectFunc: (BuildContext context) =>
                                    store.cityList
                                        .map<Widget>(
                                          (element) => Center(
                                            child: ConstantWidget.getCustomText(
                                              element.cityName,
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              font18Px(context: context),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Observer(builder: (_) {
                          if (store.areaFetching == StoreState.LOADING ||
                              store.cityFetching == StoreState.LOADING) {
                            area = null;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ConstantWidget.getCustomText(
                                    'Area ',
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                  ConstantWidget.getCustomText(
                                    '(Required)*',
                                    ConstantData.color1,
                                    1,
                                    TextAlign.left,
                                    FontWeight.w500,
                                    font22Px(context: context),
                                  ),
                                ],
                              ),
                              CustomDropDown(
                                value: area,
                                onTap: () {
                                  if (city == null) {
                                    Fluttertoast.showToast(
                                        msg: 'Enter City First');
                                  }
                                },
                                hint: 'Select Area',
                                dropDownValidte: (value) {
                                  if (city == null) return 'Enter City First';
                                  if (value == null) return 'Enter Area';
                                },

                                /// if city is not selected user won't be able to select area pincode.
                                itemList: (city != null)
                                    ? store.areaList
                                        .map<DropdownMenuItem<String>>(
                                            (element) {
                                        return DropdownMenuItem<String>(
                                          value: element.areaName,
                                          child: ConstantWidget.getCustomText(
                                            element.areaName,
                                            ConstantData.mainTextColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            font15Px(context: context),
                                          ),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) {
                                  setState(() {
                                    area = value;
                                  });
                                },
                                selectFunc: (BuildContext context) =>
                                    store.areaList
                                        .map<Widget>(
                                          (element) => Center(
                                            child: ConstantWidget.getCustomText(
                                              element.areaName,
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              font18Px(context: context),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              if (store.areaFetching == StoreState.LOADING ||
                  store.cityFetching == StoreState.LOADING)
                Container(
                  decoration:
                      BoxDecoration(color: Colors.grey[200]!.withOpacity(0.5)),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
            ],
          );
        },
      ),
    );
  }

  /// [Drug License Name] [License Number] [License Validity] [DL-1] [DL-2]
  Widget DLDetailWidget(
    BuildContext context,
    ProfileStore store,
  ) {
    return Form(
      key: dlGlobalKey,
      child: Column(
        children: [
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 25),
            child: Stack(children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  '${ConstantData.assetsPath}image_background.png',
                  fit: BoxFit.fill,
                  height: ConstantWidget.getScreenPercentSize(context, 25),
                ),
              ),
              Positioned(
                top: blockSizeVertical(context: context) * 3.5,
                left: blockSizeHorizontal(context: context) * 4,
                right: blockSizeHorizontal(context: context) * 4,
                child: Image.asset(
                  '${ConstantData.assetsPath}dl.jpg',
                  height: ConstantWidget.getScreenPercentSize(context, 12),

                  // fit: BoxFit.fill,
                ),
              ),
            ]),
          ),
          CustomTextField(
            context: context,
            hintName: 'Enter Drug License Number',
            labelName: 'Drug License Number',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Invalid Name';
                }
              }
            },
            controller: drugLiscenseNo,
          ),
          CustomTextField(
            context: context,
            hintName: 'Enter Drug License Name',
            labelName: 'Drug License Name',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Invalid Name';
                }
              }
            },
            controller: drugLicenseName,
          ),
          CustomTextField(
            context: context,
            hintName: 'DD/MM/YYYY',
            labelName: 'Drug License Validity',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Invalid';
                }
              }
            },
            controller: drugLicenseValidity,
            onTap: true,
          ),
          SizedBox(
            height: blockSizeVertical(context: context) * 2,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: blockSizeHorizontal(context: context) * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getCustomText(
                  'Upload License Certificate',
                  ConstantData.mainTextColor,
                  2,
                  TextAlign.left,
                  FontWeight.w500,
                  font22Px(context: context),
                ),
                SizedBox(
                  height: blockSizeVertical(context: context),
                ),
                Row(
                  children: [
                    ConstantWidget.getCustomText(
                      'Tap to re-upload / ',
                      ConstantData.primaryColor,
                      2,
                      TextAlign.left,
                      FontWeight.w500,
                      font18Px(context: context),
                    ),
                    ConstantWidget.getCustomText(
                      'Tap-Hold to delete',
                      ConstantData.color1,
                      2,
                      TextAlign.left,
                      FontWeight.w500,
                      font18Px(context: context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Observer(builder: (_) {
            if (store.profileModel.drugLicenseModel.dlImg1 == '') {
              return UploadLicense(
                certificateType: LicenseType.DL1,
                store: store,
                url: dl1ImgUrl,
                descp: '(Upload from Gallery)',
                label: 'Certificate DL1',
              );
            }
            return CustomImageWidget(
                store: store,
                certificateType: LicenseType.DL1,
                url: dl1ImgUrl,
                imageUrl:
                    '$licenseUrl${widget.phone}/${store.profileModel.drugLicenseModel.dlImg1}');
          }),
          Observer(builder: (_) {
            if (store.profileModel.drugLicenseModel.dlImg2 == '') {
              return UploadLicense(
                certificateType: LicenseType.DL2,
                store: store,
                url: dl2ImgUrl,
                descp: '(Upload from Gallery)',
                label: 'Certificate DL2',
              );
            }
            return CustomImageWidget(
                store: store,
                certificateType: LicenseType.DL2,
                url: dl2ImgUrl,
                imageUrl:
                    '$licenseUrl${widget.phone}/${store.profileModel.drugLicenseModel.dlImg2}');
          }),
        ],
      ),
    );
  }

  /// [GST-Number]
  Widget GSTDetailWidget(
    BuildContext context,
    ProfileStore store,
  ) {
    return Form(
      key: gstGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 25),
            child: Image.asset(
              '${ConstantData.assetsPath}gst_1.png',
              fit: BoxFit.fill,

              // fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: blockSizeVertical(context: context) * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstantWidget.getCustomText(
                'Do you want to fill GST details?',
                ConstantData.mainTextColor,
                2,
                TextAlign.left,
                FontWeight.w500,
                font18Px(context: context) * 1.1,
              ),
              ConstantWidget.getCustomText(
                'Not Compulsory*',
                ConstantData.color1,
                2,
                TextAlign.left,
                FontWeight.w500,
                font18Px(context: context),
              ),
            ],
          ),
          CustomDropDown(
            hint: 'Select Option',
            value: gstSelection,
            itemList: dropdownList.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: ConstantWidget.getCustomText(
                  value,
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font22Px(context: context),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                gstSelection = value!;
                final model = store.profileModel;
                store.profileModel = model.copyWith(
                  gstModel: store.profileModel.gstModel
                      .copyWith(toFill: (value == 'Yes') ? true : false),
                );
              });
            },
            selectFunc: (BuildContext context) => dropdownList
                .map(
                  (e) => Center(
                    child: ConstantWidget.getCustomText(
                      e,
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.left,
                      FontWeight.w600,
                      font22Px(context: context),
                    ),
                  ),
                )
                .toList(),
            dropDownValidte: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Required';
                }
              }
            },
          ),
          if (gstSelection == 'Yes')
            CustomTextField(
              context: context,
              hintName: 'Enter GST Number',
              labelName: 'GST Number',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return 'Enter GST number';
                  } else {
                    if (!ConstantData.gstValidate.hasMatch(value)) {
                      return 'Enter a valid gst licesne';
                    } else {
                      return null;
                    }
                  }
                }
                return null;
              },
              controller: gstNoController,
            ),
        ],
      ),
    );
  }

  /// [Fssai-Number] [Fssai-img]
  Widget FSSAIDetailWidget(
    BuildContext context,
    ProfileStore store,
  ) {
    return Form(
      key: fssaiGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image box
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 25),
            child: Stack(children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  '${ConstantData.assetsPath}image_background.png',
                  fit: BoxFit.fill,
                  height: ConstantWidget.getScreenPercentSize(context, 25),
                ),
              ),
              Positioned(
                top: blockSizeVertical(context: context) * 3.5,
                left: blockSizeHorizontal(context: context) * 4,
                right: blockSizeHorizontal(context: context) * 4,
                child: Image.asset(
                  '${ConstantData.assetsPath}fssai.png',
                  height: ConstantWidget.getScreenPercentSize(context, 15),
                  // fit: BoxFit.c,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: blockSizeVertical(context: context) * 2,
          ),

          /// Selection -> Yes / No
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstantWidget.getCustomText(
                'Do you want to fill FSSAI details?',
                ConstantData.mainTextColor,
                2,
                TextAlign.left,
                FontWeight.w500,
                font18Px(context: context) * 1.1,
              ),
              ConstantWidget.getCustomText(
                'Not Compulsory*',
                ConstantData.color1,
                2,
                TextAlign.left,
                FontWeight.w500,
                font18Px(context: context),
              ),
            ],
          ),
          CustomDropDown(
            hint: 'Select Option',
            value: fssaiSelection,
            itemList: dropdownList.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: ConstantWidget.getCustomText(
                  value,
                  ConstantData.mainTextColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  font22Px(context: context),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                fssaiSelection = value!;
                final model = store.profileModel;
                store.profileModel = model.copyWith(
                  fssaiModel: store.profileModel.fssaiModel
                      .copyWith(toFill: (value == 'Yes') ? true : false),
                );
              });
            },
            selectFunc: (BuildContext context) => dropdownList
                .map(
                  (e) => Center(
                    child: ConstantWidget.getCustomText(
                      e,
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.left,
                      FontWeight.w600,
                      font22Px(context: context),
                    ),
                  ),
                )
                .toList(),
            dropDownValidte: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Required';
                }
              }
              return null;
            },
          ),
          if (fssaiSelection == 'Yes')
            Column(
              children: [
                CustomTextField(
                  context: context,
                  hintName: 'Enter FSSAI Number',
                  labelName: 'FSSAI Number',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'Enter FSSAI number';
                      }
                    }
                    return null;
                  },
                  controller: fssaiNoController,
                ),
                SizedBox(
                  height: blockSizeVertical(context: context) * 2,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: blockSizeHorizontal(context: context) * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstantWidget.getCustomText(
                        'Upload FSSAI Certificate',
                        ConstantData.mainTextColor,
                        2,
                        TextAlign.left,
                        FontWeight.w500,
                        font22Px(context: context),
                      ),
                      SizedBox(
                        height: blockSizeVertical(context: context),
                      ),
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                            'Tap to re-upload / ',
                            ConstantData.primaryColor,
                            2,
                            TextAlign.left,
                            FontWeight.w500,
                            font18Px(context: context),
                          ),
                          ConstantWidget.getCustomText(
                            'Tap-Hold to delete',
                            ConstantData.color1,
                            2,
                            TextAlign.left,
                            FontWeight.w500,
                            font18Px(context: context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Observer(builder: (_) {
                  if (store.profileModel.fssaiModel.fssaiImg == '') {
                    return UploadLicense(
                      certificateType: LicenseType.FSSAI_CAMERA,
                      store: store,
                      url: fssaiImgUrl,
                      descp: '(Upload from Camera)',
                      label: 'FSSAI Certificate',
                    );
                  }
                  return CustomImageWidget(
                      store: store,
                      certificateType: LicenseType.FSSAI_CAMERA,
                      url: fssaiImgUrl,
                      imageUrl:
                          '$licenseUrl${widget.phone}/${store.profileModel.fssaiModel.fssaiImg}');
                }),
                Observer(
                  builder: (_) {
                    if (store.profileModel.fssaiModel.fssaiImg == '') {
                      return ConstantWidget.getCustomText(
                        'OR',
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        font22Px(context: context),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                Observer(builder: (_) {
                  if (store.profileModel.fssaiModel.fssaiImg == '') {
                    return UploadLicense(
                      certificateType: LicenseType.FSSAI_GALLERY,
                      store: store,
                      url: fssaiImgUrl,
                      descp: '(Upload from Gallery)',
                      label: 'FSSAI Certificate',
                    );
                  }

                  return const SizedBox();
                }),
              ],
            ),
        ],
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget(
      {Key? key,
      required this.url,
      required this.store,
      required this.certificateType,
      required this.imageUrl})
      : super(key: key);

  final String imageUrl;
  final ProfileStore store;
  final LicenseType certificateType;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (_) {
              return CustomAlertDialog(
                header: 'Remove Certificate',
                description: 'Are you sure? Once done you have to re-upload',
                func: () {
                  switch (certificateType) {
                    case LicenseType.DL1:
                      final model = store.profileModel;
                      store.profileModel = model.copyWith(
                        drugLicenseModel:
                            model.drugLicenseModel.copyWith(dlImg1: ''),
                      );
                      break;
                    case LicenseType.DL2:
                      final model = store.profileModel;
                      store.profileModel = model.copyWith(
                        drugLicenseModel:
                            model.drugLicenseModel.copyWith(dlImg2: ''),
                      );
                      break;
                    case LicenseType.FSSAI_CAMERA:
                      final model = store.profileModel;
                      store.profileModel = model.copyWith(
                        fssaiModel: model.fssaiModel.copyWith(fssaiImg: ''),
                      );
                      break;
                    case LicenseType.FSSAI_GALLERY:
                      final model = store.profileModel;
                      store.profileModel = model.copyWith(
                        fssaiModel: model.fssaiModel.copyWith(fssaiImg: ''),
                      );
                      break;
                  }
                  Navigator.pop(context);
                },
                buttonText: 'Delete',
              );
            });
      },
      onTap: () async {
        await uploadLicenses(certificateType, store, url);
      },
      child: SizedBox(
        height: ConstantWidget.getScreenPercentSize(context, 40),
        width: ConstantWidget.getWidthPercentSize(context, 40),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, _) {
            return Image.asset('${ConstantData.assetsPath}no_image.png');
          },
        ),
      ),
    );
  }
}

Future<void> uploadLicenses(
    LicenseType certificateType, ProfileStore store, String url) async {
  XFile? image;
  if (certificateType == LicenseType.DL1 ||
      certificateType == LicenseType.DL2 ||
      certificateType == LicenseType.FSSAI_GALLERY) {
    image = await store.takeCertificate(source: ImageSource.gallery);
  } else {
    image = await store.takeCertificate(source: ImageSource.camera);
  }

  store.certificateUploadingState = StoreState.LOADING;

  if (image != null) {
    final bytes = await image.readAsBytes();
    await store.saveCertificate(
      path: image.path,
      bytes: bytes,
      url: url,
    );
  } else {
    Fluttertoast.showToast(msg: 'Image not uploaded');
  }
  store.certificateUploadingState = StoreState.SUCCESS;
}

class UploadLicense extends StatelessWidget {
  const UploadLicense({
    Key? key,
    required this.certificateType,
    required this.store,
    required this.url,
    required this.descp,
    required this.label,
  }) : super(key: key);

  final LicenseType certificateType;
  final ProfileStore store;
  final String url;
  final String label;
  final String descp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context) * 2,
      ),
      child: InkWell(
        onTap: () async {
          await uploadLicenses(certificateType, store, url);
        },
        child: Container(
          width: screenWidth(context: context),
          height: ConstantWidget.getScreenPercentSize(context, 22),
          padding: EdgeInsets.all(
            blockSizeHorizontal(context: context) * 4,
          ),
          decoration: BoxDecoration(
            color: ConstantData.cellColor,
            borderRadius: BorderRadius.circular(
              font18Px(context: context),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                font18Px(context: context),
              ),
            ),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(font22Px(context: context)),
              dashPattern: const [7, 1],
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.square_list_fill,
                      color: Colors.black87,
                    ),
                    SizedBox(
                      height: blockSizeVertical(context: context),
                    ),
                    ConstantWidget.getCustomText(
                      label,
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.center,
                      FontWeight.w500,
                      font15Px(context: context) * 1.1,
                    ),
                    ConstantWidget.getCustomText(
                      descp,
                      ConstantData.mainTextColor,
                      1,
                      TextAlign.center,
                      FontWeight.w400,
                      font15Px(context: context) * 1.1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
