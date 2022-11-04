// ignore_for_file: use_build_context_synchronously

// import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medrpha_customer/bottom_navigation/screens/landing_screen.dart';
import 'package:medrpha_customer/bottom_navigation/store/bottom_navigation_store.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/order_history/stores/order_history_store.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/models/profile_model.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/profile/utils/dropdown.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.model,
    required this.phone,
    this.beginToFill,
  }) : super(key: key);

  final ProfileModel model;
  final String phone;
  final String? beginToFill;

  @override
  // ignore: no_logic_in_create_state
  State<ProfilePage> createState() => _ProfilePageState(model);
}

class _ProfilePageState extends State<ProfilePage> {
  // List<AddressModel> addressList = DataFile.getAddressList()
  _ProfilePageState(this.model);

  ProfileModel model;

  /// ProfilePage controllers
  late final firmtNameController =
      TextEditingController(text: widget.model.firmInfoModel.firmName);
  late final mailController =
      TextEditingController(text: widget.model.firmInfoModel.email);
  late final addressController =
      TextEditingController(text: widget.model.firmInfoModel.address);
  late final phoneController =
      TextEditingController(text: widget.model.firmInfoModel.phone);
  // final pinController = TextEditingController();
  late final contactNameController =
      TextEditingController(text: widget.model.firmInfoModel.contactName);
  late final contactController =
      TextEditingController(text: widget.model.firmInfoModel.contactNo);
  late final altContactController =
      TextEditingController(text: widget.model.firmInfoModel.altContactNo);
  // late int country = int.parse(widget.model.firmInfoModel.country);
  String? country;
  String? state;
  String? city;
  String? area;
  // late int state = int.parse(widget.model.firmInfoModel.state);
  // late int city = int.parse(widget.model.firmInfoModel.city);
  // late int pinCode = int.parse(widget.model.firmInfoModel.pin);

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

  List<int> fssaiImgBytes = [];

  final _emailRegex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+");

  String? getLicenseValidation({required String value}) {
    if (value.isEmpty) {
      print(value);
      return 'This Field cannot be empty';
    }
    return null;
  }

  // String? getNumberValidation({required String value}) {
  //   if (value.isEmpty) {
  //     return 'This Field cannot be empty';
  //   } else if (value.length != 10) {
  //     return 'Invalid number';
  //   }
  //   return null;
  // }

  // String? getEmailValidation({required String value}) {
  //   if (value.isEmpty) {
  //     return 'This Field cannot be empty';
  //   } else if (!_emailRegex.hasMatch(value)) {
  //     return 'Invalid email';
  //   }
  //   return null;
  // }

  // String? getTextValidation({required String value}) {
  //   if (value.isEmpty) {
  //     return 'This Field cannot be empty';
  //   }
  //   return null;
  // }

  final profileGlobalKey = GlobalKey<FormState>();

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
    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    final store = context.read<ProfileStore>();
    final loginstore = context.read<LoginStore>();
    final productStore = context.read<ProductsStore>();
    final bottomNavigationStore = context.read<BottomNavigationStore>();
    final orderHistoryStore = context.read<OrderHistoryStore>();

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          floatingActionButton: Observer(builder: (_) {
            final page = store.page;

            switch (page) {
              case 0:
                return const SizedBox();
              case 1:
                return FloatingActionButton(
                  onPressed: () {
                    store.page -= 1;
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: font25Px(context: context),
                    color: ConstantData.bgColor,
                  ),
                );
              case 2:
                return FloatingActionButton(
                  onPressed: () {
                    store.page -= 1;
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: font25Px(context: context),
                    color: ConstantData.bgColor,
                  ),
                );
              case 3:
                return FloatingActionButton(
                  onPressed: () {
                    store.page -= 1;
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: font25Px(context: context),
                    color: ConstantData.bgColor,
                  ),
                );
              default:
                return FloatingActionButton(
                  onPressed: () {
                    store.page -= 1;
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: font25Px(context: context),
                    color: ConstantData.bgColor,
                  ),
                );
            }
          }),
          bottomNavigationBar: Observer(builder: (_) {
            if (store.saveState == ButtonState.LOADING) {
              return ConstantWidget.getCustomText(
                'UPLOADING..........',
                ConstantData.primaryColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font22Px(context: context),
              );
            } else {
              return ConstantWidget.getBottomButton(
                context: context,
                func: () async {
                  switch (store.page) {
                    case 0:
                      // if (firmtNameController.text.isNotEmpty &&
                      //     addressController.text.isNotEmpty &&
                      //     mailController.text.isNotEmpty &&
                      //     (phoneController.text.isNotEmpty &&
                      //         phoneController.text.trim().length == 10) &&
                      //     // pinController.text.isNotEmpty &&
                      //     (country != null) &&
                      //     (city != null) &&
                      //     (state != null) &&
                      //     (area != null) &&
                      //     contactNameController.text.isNotEmpty &&
                      //     (contactController.text.isNotEmpty &&
                      //         contactController.text.trim().length == 10) &&
                      //     (altContactController.text.isNotEmpty &&
                      //         altContactController.text.trim().length == 10)) {
                      if (profileGlobalKey.currentState!.validate()) {
                        final countryIndex = store.countryList.indexWhere(
                            (element) => element.countryName == country);
                        final stateIndex = store.stateList.indexWhere(
                            (element) => element.stateName == state);

                        final cityIndex = store.cityList
                            .indexWhere((element) => element.cityName == city);

                        final areaIndex = store.areaList
                            .indexWhere((element) => element.areaName == area);
                        if (countryIndex != -1 &&
                            stateIndex != -1 &&
                            cityIndex != -1 &&
                            areaIndex != -1) {
                          final firmInfoModel = FirmInfoModel(
                            firmName: firmtNameController.text.trim(),
                            email: mailController.text.trim(),
                            phone: phoneController.text.trim(),
                            country: store.countryList[countryIndex].countryId
                                .toString(),
                            city: store.cityList[cityIndex].cityId.toString(),
                            state:
                                store.stateList[stateIndex].stateId.toString(),
                            pin: store.areaList[areaIndex].areaId.toString(),
                            address: addressController.text.trim(),
                            contactName: contactNameController.text.trim(),
                            contactNo: contactController.text.trim(),
                            altContactNo: altContactController.text.trim(),
                          );

                          store.profileModel = store.profileModel
                              .copyWith(firmInfoModel: firmInfoModel);

                          store.page += 1;
                        }
                      } else {
                        final snackBar =
                            ConstantData().snackBarValidation(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      break;
                    case 1:
                      if (store.profileModel.gstModel.toFill) {
                        if (gstNoController.text.isNotEmpty) {
                          final gstModel = store.profileModel.gstModel
                              .copyWith(gstNo: gstNoController.text.trim());
                          store.profileModel =
                              store.profileModel.copyWith(gstModel: gstModel);
                          store.page += 1;
                        } else {
                          final snackBar =
                              ConstantData().snackBarValidation(context);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        // } else {
                        //   store.page += 1;
                      } else {
                        store.profileModel = store.profileModel.copyWith(
                          gstModel: ConstantData().initGstModel,
                        );
                        store.page += 1;
                      }
                      break;
                    case 2:
                      // if (store
                      //         .profileModel.drugLicenseModel.toFill) {
                      final license1 =
                          store.profileModel.drugLicenseModel.dlImg1;
                      final license2 =
                          store.profileModel.drugLicenseModel.dlImg2;
                      // print(license1);
                      // print(license2);
                      if ((drugLiscenseNo.text.isNotEmpty ||
                                  drugLiscenseNo.text != '') &&
                              (drugLicenseName.text.isNotEmpty ||
                                  drugLicenseName.text != '') &&
                              (drugLicenseValidity.text.isNotEmpty ||
                                  drugLicenseValidity.text != '') &&
                              license1.isNotEmpty &&
                              license2.isNotEmpty
                          // &&
                          // getLicenseValidation(value: drugLiscenseNo.text) ==
                          //     null &&
                          // getTextValidation(value: drugLicenseName.text) ==
                          //     null &&
                          // getTextValidation(value: drugLicenseValidity.text) ==
                          //     null
                          ) {
                        final drugLicenseModel =
                            store.profileModel.drugLicenseModel.copyWith(
                          name: drugLicenseName.text.trim(),
                          number: drugLiscenseNo.text.trim(),
                          validity: drugLicenseValidity.text.trim(),
                          // licenseBytes: drugImgBytes,
                        );
                        store.profileModel = store.profileModel
                            .copyWith(drugLicenseModel: drugLicenseModel);
                        store.page += 1;
                      } else {
                        final snackBar =
                            ConstantData().snackBarValidation(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      break;
                    case 3:

                      /// Checking if fssai needs to be filled.
                      store.saveState = ButtonState.LOADING;
                      if (store.profileModel.fssaiModel.toFill) {
                        if (fssaiNoController.text.isNotEmpty) {
                          final fssaiModel =
                              store.profileModel.fssaiModel.copyWith(
                            number: fssaiNoController.text.trim(),
                            numberBytes: [],
                          );

                          store.profileModel = store.profileModel
                              .copyWith(fssaiModel: fssaiModel);
                        } else {
                          final snackBar =
                              ConstantData().snackBarValidation(context);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        final fssaiModel = ConstantData().initFssaiModel;
                        store.profileModel =
                            store.profileModel.copyWith(fssaiModel: fssaiModel);
                      }

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

                      if (widget.beginToFill != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Provider.value(
                              value: store,
                              child: Provider.value(
                                value: loginstore,
                                child: Provider.value(
                                  value: productStore,
                                  child: Provider.value(
                                    value: bottomNavigationStore
                                      ..currentPage = 0,
                                    child: Provider.value(
                                      value: orderHistoryStore,
                                      child: const HomeScreen(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    // }
                  }
                },
                label: store.page == 3 ? 'Save' : 'Next',
                height: blockSizeVertical(context: context),
              );
            }
          }),
          body: Column(
            children: [
              Observer(builder: (_) {
                final page = store.page;
                switch (page) {
                  case 0:
                    return ConstantWidget.customAppBar(
                      context: context,
                      title: 'EDIT FIRM PROFILE',
                    );
                  case 1:
                    return ConstantWidget.customAppBar(
                      context: context,
                      title: 'EDIT GST PROFILE',
                      widgetList: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: blockSizeVertical(context: context) * 1.5,
                            horizontal:
                                blockSizeHorizontal(context: context) * 4,
                          ),
                          child: InkWell(
                            onTap: () {
                              final gstModel =
                                  store.profileModel.gstModel.copyWith(
                                toFill: !store.profileModel.gstModel.toFill,
                              );
                              store.profileModel = store.profileModel
                                  .copyWith(gstModel: gstModel);
                            },
                            child: Observer(builder: (_) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ConstantData.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    font22Px(context: context),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      blockSizeHorizontal(context: context) * 4,
                                ),
                                alignment: Alignment.center,
                                child: ConstantWidget.getCustomText(
                                  (store.profileModel.gstModel.toFill)
                                      ? 'Remove'
                                      : 'Fill',
                                  ConstantData.bgColor,
                                  1,
                                  TextAlign.center,
                                  FontWeight.w600,
                                  font15Px(context: context),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  case 2:
                    return ConstantWidget.customAppBar(
                      context: context,
                      title: 'EDIT DL PROFILE',
                      widgetList: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: blockSizeVertical(context: context) * 1.5,
                            horizontal:
                                blockSizeHorizontal(context: context) * 4,
                          ),
                          child: InkWell(
                            onTap: () {
                              final dlModel =
                                  store.profileModel.drugLicenseModel.copyWith(
                                toFill:
                                    !store.profileModel.drugLicenseModel.toFill,
                              );
                              store.profileModel = store.profileModel
                                  .copyWith(drugLicenseModel: dlModel);
                            },
                            child: Observer(builder: (_) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ConstantData.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    font22Px(context: context),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      blockSizeHorizontal(context: context) * 4,
                                ),
                                alignment: Alignment.center,
                                child: ConstantWidget.getCustomText(
                                  (store.profileModel.gstModel.toFill)
                                      ? 'Remove'
                                      : 'Fill',
                                  ConstantData.bgColor,
                                  1,
                                  TextAlign.center,
                                  FontWeight.w600,
                                  font15Px(context: context),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  case 3:
                    return ConstantWidget.customAppBar(
                      context: context,
                      title: 'EDIT FSSAI PROFILE',
                      widgetList: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: blockSizeVertical(context: context) * 1.5,
                            horizontal:
                                blockSizeHorizontal(context: context) * 4,
                          ),
                          child: InkWell(
                            onTap: () {
                              final fssaiModel = store.profileModel.fssaiModel
                                  .copyWith(
                                      toFill: !store
                                          .profileModel.fssaiModel.toFill);
                              store.profileModel = store.profileModel
                                  .copyWith(fssaiModel: fssaiModel);
                            },
                            child: Observer(builder: (_) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ConstantData.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    font22Px(context: context),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      blockSizeHorizontal(context: context) * 4,
                                ),
                                alignment: Alignment.center,
                                child: ConstantWidget.getCustomText(
                                  (store.profileModel.fssaiModel.toFill)
                                      ? 'Remove'
                                      : 'Fill',
                                  ConstantData.bgColor,
                                  1,
                                  TextAlign.center,
                                  FontWeight.w600,
                                  font15Px(context: context),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  default:
                    return ConstantWidget.customAppBar(
                        context: context, title: 'EDIT FIRM PROFILE');
                }
              }),
              Observer(builder: (_) {
                final page = store.page;

                switch (page) {
                  case 0:
                    return profile(store: store);

                  case 1:
                    return gstProfile(store: store);
                  case 2:
                    return drugLicenseProfile(store: store);
                  case 3:
                    return fssaiProfile(store: store);
                  default:
                    return profile(store: store);
                }
              }),
            ],
          ),
        ),
        // }),
        onWillPop: () {
          // Navigator.pop(context);
          return Future.value(true);
        });
  }

  Widget fssaiProfile({required ProfileStore store}) {
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      final toFill = store.profileModel.fssaiModel.toFill;
      return Expanded(
        flex: 1,
        child: ListView(
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
                                  width: ConstantWidget.getScreenPercentSize(
                                      context, 0.2))),
                          child: ClipOval(
                            child: Material(
                              // color: ConstantData.primaryColor,
                              child: Image.asset(
                                "${ConstantData.assetsPath}fssai.png",
                                // fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Offstage(
              offstage: toFill,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal(context: context) * 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidget.getTextWidget(
                      'Do you want to fill FSSAI License details?',
                      ConstantData.mainTextColor,
                      TextAlign.center,
                      FontWeight.w600,
                      font18Px(context: context),
                    ),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 2,
                    ),
                    ConstantWidget.getTextWidget(
                        'Please select the appropriate option below',
                        ConstantData.mainTextColor,
                        TextAlign.center,
                        FontWeight.w600,
                        font18Px(context: context)),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final model = store.profileModel.fssaiModel
                                      .copyWith(toFill: true);
                                  store.profileModel = store.profileModel
                                      .copyWith(fssaiModel: model);
                                },
                                icon: Icon(
                                  (store.profileModel.fssaiModel.toFill)
                                      ? CupertinoIcons.circle_fill
                                      : CupertinoIcons.circle,
                                  color: (store.profileModel.fssaiModel.toFill)
                                      ? ConstantData.primaryColor
                                      : null,
                                  size: font25Px(context: context),
                                ),
                              ),
                              ConstantWidget.getCustomText(
                                'Yes',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font22Px(context: context),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final model = store.profileModel.fssaiModel
                                      .copyWith(toFill: false);
                                  store.profileModel = store.profileModel
                                      .copyWith(fssaiModel: model);
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: ConstantData.mainTextColor),
                                  ),
                                  // alignment: Alignment.center,
                                  child: Icon(
                                    (!store.profileModel.fssaiModel.toFill)
                                        ? CupertinoIcons.circle_fill
                                        : CupertinoIcons.circle,
                                    color:
                                        (!store.profileModel.fssaiModel.toFill)
                                            ? ConstantData.primaryColor
                                            : null,
                                    size: font25Px(context: context),
                                  ),
                                ),
                              ),
                              ConstantWidget.getCustomText(
                                'No',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font22Px(context: context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !toFill,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: defaultMargin),
                    color: ConstantData.cellColor,
                    padding: EdgeInsets.all(defaultMargin),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ConstantWidget.getCustomTextWithoutAlign(
                              'FSSAI Details',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: (defaultMargin / 2),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: InputField(
                                controller: fssaiNoController,
                                action: TextInputAction.next,
                                hint: 'FSSAI Number',
                                keyboardType: TextInputType.number,
                                label: "FSSAI Number",
                                obscure: false,
                                func: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter FSSAI number';
                                    } else {
                                      if (value.length != 14) {
                                        return 'Enter a valid license number';
                                      } else {
                                        return null;
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width:
                                    blockSizeHorizontal(context: context) * 7,
                                child: InkWell(
                                    onTap: () {
                                      fssaiNoController.clear();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: blockSizeHorizontal(
                                              context: context) *
                                          7,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: defaultMargin),
                    color: ConstantData.cellColor,
                    padding: EdgeInsets.all(defaultMargin),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ConstantWidget.getCustomTextWithoutAlign(
                              'Upload FSSAI Certificate',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Observer(builder: (_) {
                              return UploadIconButton(
                                context: context,
                                icon: Icons.camera,
                                color: Colors.orange,
                                source: ImageSource.camera,
                                text: 'Camera',
                                store: store,
                                certificateType: 2,
                              );
                            }),
                            Observer(builder: (_) {
                              return UploadIconButton(
                                context: context,
                                icon: Icons.photo_album_outlined,
                                color: Colors.blue,
                                source: ImageSource.gallery,
                                store: store,
                                text: 'Gallery',
                                certificateType: 3,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: defaultMargin),
                    color: ConstantData.cellColor,
                    padding: EdgeInsets.all(defaultMargin),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ConstantWidget.getCustomTextWithoutAlign(
                              'Certificate',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: defaultMargin,
                        ),
                        Observer(builder: (_) {
                          final model = store.profileModel;

                          return SizedBox(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 40),
                            width:
                                ConstantWidget.getWidthPercentSize(context, 40),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${ConstantData.licenseUrl}${widget.phone}/${model.fssaiModel.fssaiImg}',
                              fit: BoxFit.cover,
                              errorWidget: (context, e, _) =>
                                  CachedNetworkImage(
                                imageUrl:
                                    '${ConstantData.licenseUrl}${widget.phone}/${widget.model.fssaiModel.fssaiImg}',
                                errorWidget: (context, s, _) {
                                  return ConstantWidget.errorWidget(
                                      context: context, height: 20, width: 25);
                                },
                                placeholder: (context, _) {
                                  return ConstantWidget.errorWidget(
                                      context: context, height: 20, width: 25);
                                },
                              ),
                            ),
                          );
                          // }
                        }),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget drugLicenseProfile({required ProfileStore store}) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.1;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      return Expanded(
        flex: 1,
        child: ListView(
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
                                  width: ConstantWidget.getScreenPercentSize(
                                      context, 0.2))),
                          child: ClipOval(
                            child: Material(
                              // color: ConstantData.primaryColor,
                              child: Image.asset(
                                "${ConstantData.assetsPath}dl.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: defaultMargin),
                  color: ConstantData.cellColor,
                  padding: EdgeInsets.all(defaultMargin),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ConstantWidget.getCustomTextWithoutAlign(
                            'Drug License Details',
                            ConstantData.mainTextColor,
                            FontWeight.w600,
                            font22Px(context: context)),
                      ),
                      SizedBox(
                        height: (defaultMargin / 2),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InputField(
                              controller: drugLiscenseNo,
                              action: TextInputAction.next,
                              hint: 'Drug License Number',
                              keyboardType: TextInputType.text,
                              label: "Drug License Number",
                              obscure: false,
                              func: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Enter DL number';
                                  } else {
                                    return null;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InputField(
                              controller: drugLicenseName,
                              action: TextInputAction.next,
                              hint: 'Drug License Name',
                              keyboardType: TextInputType.text,
                              label: "Drug License Name",
                              obscure: false,
                              func: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Enter DL name';
                                  } else {
                                    return null;
                                  }
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: (defaultMargin / 2)),
                        height: editTextHeight,
                        child: TextFormField(
                          maxLines: 1,
                          controller: drugLicenseValidity,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              drugLicenseValidity.text =
                                  formattedDate.toString();
                            }
                          },
                          style: TextStyle(
                            fontFamily: ConstantData.fontFamily,
                            color: ConstantData.mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: font18Px(context: context),
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: BorderSide(
                                  color: ConstantData.textColor, width: 0.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ConstantData.textColor, width: 0.0),
                            ),
                            labelStyle: TextStyle(
                                fontFamily: ConstantData.fontFamily,
                                color: ConstantData.textColor),
                            labelText: 'Drug License Validity',
                            // hintText: hintText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: defaultMargin),
                  color: ConstantData.cellColor,
                  padding: EdgeInsets.all(defaultMargin),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ConstantWidget.getCustomTextWithoutAlign(
                            'Upload License Certificate',
                            ConstantData.mainTextColor,
                            FontWeight.w600,
                            font22Px(context: context)),
                      ),
                      SizedBox(
                        height: blockSizeVertical(context: context) * 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Observer(builder: (_) {
                            final state = store.certi1;
                            switch (state) {
                              case StoreState.LOADING:
                                return const CircularProgressIndicator();
                              case StoreState.SUCCESS:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.orange,
                                  source: ImageSource.camera,
                                  text: 'DL1',
                                  store: store,
                                  certificateType: 0,
                                );
                              case StoreState.ERROR:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.orange,
                                  source: ImageSource.camera,
                                  text: 'DL1',
                                  store: store,
                                  certificateType: 0,
                                );
                              case StoreState.EMPTY:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.orange,
                                  source: ImageSource.camera,
                                  text: 'DL1',
                                  store: store,
                                  certificateType: 0,
                                );
                            }
                          }),
                          Observer(builder: (_) {
                            final state = store.certi2;

                            switch (state) {
                              case StoreState.LOADING:
                                return const CircularProgressIndicator();
                              case StoreState.SUCCESS:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.blue,
                                  source: ImageSource.gallery,
                                  store: store,
                                  text: 'DL2',
                                  certificateType: 1,
                                );
                              case StoreState.ERROR:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.blue,
                                  source: ImageSource.gallery,
                                  store: store,
                                  text: 'DL2',
                                  certificateType: 1,
                                );
                              case StoreState.EMPTY:
                                return UploadIconButton(
                                  context: context,
                                  icon: Icons.note_add_outlined,
                                  color: Colors.blue,
                                  source: ImageSource.gallery,
                                  store: store,
                                  text: 'DL2',
                                  certificateType: 1,
                                );
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: defaultMargin),
                  color: ConstantData.cellColor,
                  padding: EdgeInsets.all(defaultMargin),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ConstantWidget.getCustomTextWithoutAlign(
                            'Certificate',
                            ConstantData.mainTextColor,
                            FontWeight.w600,
                            font22Px(context: context)),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      Observer(builder: (_) {
                        final model = store.profileModel;

                        if ((model.drugLicenseModel.dlImg1 == '' &&
                            model.drugLicenseModel.dlImg2 == '')) {
                          return Column(
                            children: [
                              Icon(
                                Icons.note_add,
                                color: ConstantData.bgColor,
                                size:
                                    blockSizeHorizontal(context: context) * 13,
                              ),
                              SizedBox(
                                height: blockSizeVertical(context: context) * 2,
                              ),
                              ConstantWidget.getTextWidget(
                                'No Document',
                                ConstantData.mainTextColor,
                                TextAlign.center,
                                FontWeight.w400,
                                font18Px(context: context),
                              )
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: ConstantWidget.getScreenPercentSize(
                                    context, 40),
                                width: ConstantWidget.getWidthPercentSize(
                                    context, 40),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ConstantData.licenseUrl}${widget.phone}/${store.profileModel.drugLicenseModel.dlImg1}',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, s, _) {
                                    return ConstantWidget.errorWidget(
                                        context: context,
                                        height: 20,
                                        width: 25);
                                  },
                                  placeholder: (context, _) {
                                    return ConstantWidget.errorWidget(
                                        context: context,
                                        height: 20,
                                        width: 25);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: ConstantWidget.getScreenPercentSize(
                                    context, 40),
                                width: ConstantWidget.getWidthPercentSize(
                                    context, 40),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ConstantData.licenseUrl}${widget.phone}/${store.profileModel.drugLicenseModel.dlImg2}',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, s, _) {
                                    return ConstantWidget.errorWidget(
                                        context: context,
                                        height: 20,
                                        width: 25);
                                  },
                                  placeholder: (context, _) {
                                    return ConstantWidget.errorWidget(
                                        context: context,
                                        height: 20,
                                        width: 25);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                      // SizedBox(
                      //   height: blockSizeVertical(context: context) * 4,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: blockSizeVertical(context: context) * 4,
            ),
          ],
        ),
      );
    });
  }

  Widget gstProfile({required ProfileStore store}) {
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      final toFill = store.profileModel.gstModel.toFill;

      return Expanded(
        flex: 1,
        child: ListView(
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
                              width: ConstantWidget.getScreenPercentSize(
                                  context, 0.2),
                            ),
                          ),
                          child: ClipOval(
                            child: Material(
                              // color: ConstantData.primaryColor,
                              child: Image.asset(
                                "${ConstantData.assetsPath}gst.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: blockSizeVertical(context: context) * 10,
            ),
            Offstage(
              offstage: toFill,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal(context: context) * 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidget.getTextWidget(
                      'Do you want to fill GST details?',
                      ConstantData.mainTextColor,
                      TextAlign.center,
                      FontWeight.w600,
                      font18Px(context: context),
                    ),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 2,
                    ),
                    ConstantWidget.getTextWidget(
                        'Please select the appropriate option below',
                        ConstantData.mainTextColor,
                        TextAlign.center,
                        FontWeight.w600,
                        font18Px(context: context)),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final model = store.profileModel.gstModel
                                      .copyWith(toFill: true);
                                  store.profileModel = store.profileModel
                                      .copyWith(gstModel: model);
                                },
                                icon: Icon(
                                  (store.profileModel.gstModel.toFill)
                                      ? CupertinoIcons.circle_fill
                                      : CupertinoIcons.circle,
                                  color: (store.profileModel.gstModel.toFill)
                                      ? ConstantData.primaryColor
                                      : null,
                                  size: font25Px(context: context),
                                ),
                              ),
                              ConstantWidget.getCustomText(
                                'Yes',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font22Px(context: context),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final model = store.profileModel.gstModel
                                      .copyWith(toFill: false);
                                  store.profileModel = store.profileModel
                                      .copyWith(gstModel: model);
                                },
                                icon: Container(
                                  // padding: EdgeInsets.all(
                                  //     font12Px(context: context)),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: ConstantData.mainTextColor),
                                  ),
                                  // alignment: Alignment.center,
                                  child: Icon(
                                    (!store.profileModel.gstModel.toFill)
                                        ? CupertinoIcons.circle_fill
                                        : CupertinoIcons.circle,
                                    color: (!store.profileModel.gstModel.toFill)
                                        ? ConstantData.primaryColor
                                        : null,
                                    size: font25Px(context: context),
                                  ),
                                ),
                              ),
                              ConstantWidget.getCustomText(
                                'No',
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                font22Px(context: context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !toFill,
              child: Container(
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
                          FontWeight.w600,
                          font22Px(context: context)),
                    ),
                    SizedBox(
                      height: (defaultMargin / 2),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: InputField(
                            controller: gstNoController,
                            action: TextInputAction.next,
                            hint: 'GST Number',
                            keyboardType: TextInputType.text,
                            label: "GST Number",
                            obscure: false,
                            func: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Enter GST number';
                                } else {
                                  if (!ConstantData.gstValidate
                                      .hasMatch(value)) {
                                    return 'Enter a valid gst licesne';
                                  } else {
                                    return null;
                                  }
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: blockSizeHorizontal(context: context) * 7,
                            child: InkWell(
                                onTap: () {
                                  gstNoController.clear();
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size:
                                      blockSizeHorizontal(context: context) * 7,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget profile({required ProfileStore store}) {
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Expanded(
      flex: 1,
      child: Container(
        child: Stack(
          children: [
            Form(
              key: profileGlobalKey,
              child: ListView(
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
                                      width:
                                          ConstantWidget.getScreenPercentSize(
                                              context, 0.2))),
                              child: ClipOval(
                                child: Material(
                                  // color: ConstantData.primaryColor,
                                  child: Image.asset(
                                    "${ConstantData.assetsPath}med_logo.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: defaultMargin),
                    color: ConstantData.cellColor,
                    padding: EdgeInsets.all(defaultMargin),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ConstantWidget.getCustomTextWithoutAlign(
                              'Firm Info',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 2,
                        ),
                        InputField(
                          controller: firmtNameController,
                          action: TextInputAction.next,
                          hint: 'Firm Name',
                          keyboardType: TextInputType.name,
                          label: "Firm Name",
                          obscure: false,
                          func: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Enter name';
                              } else {
                                return null;
                              }
                            }
                            return null;
                          },
                        ),
                        InputField(
                          controller: addressController,
                          action: TextInputAction.next,
                          hint: 'Address',
                          keyboardType: TextInputType.streetAddress,
                          label: "Address",
                          obscure: false,
                          func: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Enter address';
                              } else {
                                return null;
                              }
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: InputField(
                                controller: mailController,
                                action: TextInputAction.next,
                                hint: 'abc@gmail.com',
                                keyboardType: TextInputType.emailAddress,
                                font: font15Px(context: context),
                                // maxLine: 3,
                                label: "Email",
                                obscure: false,
                                func: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter email';
                                    } else {
                                      if (!ConstantData.emailValidate
                                          .hasMatch(value)) {
                                        return 'Enter a valid email';
                                      } else {
                                        return null;
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 4,
                              child: InputField(
                                controller: phoneController,
                                action: TextInputAction.next,
                                hint: '9.......01',
                                keyboardType: TextInputType.phone,
                                label: "Contact",
                                obscure: false,
                                func: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter phone number';
                                    } else {
                                      if (value.length != 10) {
                                        return 'Enter a valid number';
                                      } else {
                                        return null;
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CustomDropDown(
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
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 4,
                              child: Observer(builder: (_) {
                                return CustomDropDown(
                                  value: (country != null) ? state : null,
                                  hint: 'Select State',
                                  dropDownValidte: (value) {
                                    if (value == null) return 'Enter State';
                                  },
                                  itemList: store.stateList
                                      .map<DropdownMenuItem<String>>((element) {
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
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      state = value;
                                    });
                                    final index = store.stateList.indexWhere(
                                        (element) =>
                                            element.stateName == state);
                                    await store.getStateCitySpecific(
                                      id: store.stateList[index].stateId
                                          .toString(),
                                    );
                                  },
                                  selectFunc: (BuildContext context) => store
                                      .stateList
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
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Observer(builder: (_) {
                                if (store.cityFetching == StoreState.LOADING) {
                                  city = null;
                                }
                                return CustomDropDown(
                                  value: city,
                                  hint: 'Select City',
                                  dropDownValidte: (value) {
                                    if (value == null) return 'Enter City';
                                  },
                                  itemList: store.cityList
                                      .map<DropdownMenuItem<String>>((element) {
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
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      city = value;
                                    });
                                    final index = store.cityList.indexWhere(
                                        (element) => element.cityName == city);
                                    await store.getAreaCitySpecific(
                                      id: store.cityList[index].cityId
                                          .toString(),
                                    );
                                  },
                                  selectFunc: (BuildContext context) => store
                                      .cityList
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
                                );
                              }),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 4,
                              child: Observer(builder: (_) {
                                if (store.areaFetching == StoreState.LOADING ||
                                    store.cityFetching == StoreState.LOADING) {
                                  area = null;
                                }
                                return CustomDropDown(
                                  value: area,
                                  hint: 'Select Area',
                                  dropDownValidte: (value) {
                                    if (value == null) return 'Enter Area';
                                  },
                                  itemList: store.areaList
                                      .map<DropdownMenuItem<String>>((element) {
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
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      area = value;
                                    });
                                  },
                                  selectFunc: (BuildContext context) => store
                                      .areaList
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
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: defaultMargin),
                    color: ConstantData.cellColor,
                    padding: EdgeInsets.all(defaultMargin),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ConstantWidget.getCustomTextWithoutAlign(
                              'Contact Details',
                              ConstantData.mainTextColor,
                              FontWeight.w600,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: (defaultMargin / 2),
                        ),
                        InputField(
                          controller: contactNameController,
                          action: TextInputAction.next,
                          hint: 'Contact Name',
                          keyboardType: TextInputType.name,
                          label: "Contact Name",
                          obscure: false,
                          func: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Enter name';
                              } else {
                                return null;
                              }
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: InputField(
                                controller: contactController,
                                action: TextInputAction.next,
                                hint: 'Contact',
                                keyboardType: TextInputType.phone,
                                label: "Contact",
                                obscure: false,
                                func: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter contact';
                                    } else {
                                      if (value.length != 10) {
                                        return 'Enter a valid number';
                                      } else {
                                        return null;
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 4,
                              child: InputField(
                                controller: altContactController,
                                action: TextInputAction.next,
                                hint: 'Alternate Contact',
                                keyboardType: TextInputType.phone,
                                label: "Alternate Contact",
                                obscure: false,
                                func: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter contact';
                                    } else {
                                      if (value.length != 10) {
                                        return 'Enter a valid number';
                                      } else {
                                        return null;
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // if (store.areaFetching == StoreState.LOADING)
            //   Container(
            //     decoration:
            //         BoxDecoration(color: Colors.grey[200]!.withOpacity(0.5)),
            //     alignment: Alignment.center,
            //     child: const CircularProgressIndicator(),
            //   )
          ],
        ),
      ),
    );
  }
}

class UploadIconButton extends StatelessWidget {
  const UploadIconButton({
    Key? key,
    required this.context,
    required this.source,
    required this.store,
    required this.icon,
    required this.color,
    required this.text,
    required this.certificateType,
  }) : super(key: key);

  final BuildContext context;
  final ProfileStore store;
  final ImageSource source;
  final IconData icon;
  final Color color;
  final String text;
  final int certificateType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        switch (certificateType) {
          case 0:
            final img =
                await store.takeCertificate(source: ImageSource.gallery);

            store.certi1 = StoreState.LOADING;

            if (img != null) {
              // const uploadDLImage2 =
              //     'https://medrpha.com/api/register/registerdl1';
              const uploadDLImage2 =
                  'https://test.medrpha.com/api/register/registerdl1';
              final bytes = await img.readAsBytes();
              store.saveCertificate(
                path: img.path,
                bytes: bytes,
                url: uploadDLImage2,
                context: context,
              );
              final model = store.profileModel.drugLicenseModel
                  .copyWith(license1Bytes: bytes);
              store.profileModel =
                  store.profileModel.copyWith(drugLicenseModel: model);
              store.certi1 = StoreState.SUCCESS;
            } else {
              final snackBar = ConstantWidget.customSnackBar(
                  text: 'No Image Uploaded', context: context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              store.certi1 = StoreState.ERROR;
            }
            // }
            break;
          case 1:
            // if (store
            //     .profileModel.drugLicenseModel.license2Bytes.isNotEmpty) {
            //   final snackBar = ConstantWidget.customSnackBar(
            //       text: 'Already Uploaded', context: context);
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // } else {
            final img =
                await store.takeCertificate(source: ImageSource.gallery);

            store.certi2 = StoreState.LOADING;

            if (img != null) {
              // const uploadDLImage2 =
              //     'https://medrpha.com/api/register/registerdl2';
              const uploadDLImage2 =
                  'https://test.medrpha.com/api/register/registerdl2';
              final bytes = await img.readAsBytes();
              store.saveCertificate(
                path: img.path,
                bytes: bytes,
                url: uploadDLImage2,
                context: context,
              );
              final model = store.profileModel.drugLicenseModel
                  .copyWith(license2Bytes: bytes);
              store.profileModel =
                  store.profileModel.copyWith(drugLicenseModel: model);
              store.certi2 = StoreState.SUCCESS;
            } else {
              final snackBar = ConstantWidget.customSnackBar(
                  text: 'No Image Uploaded', context: context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              store.certi2 = StoreState.ERROR;
            }
            // }
            break;
          case 2:
            // if (store.profileModel.fssaiModel.numberBytes.isNotEmpty) {
            //   final snackBar = ConstantWidget.customSnackBar(
            //       text: 'Already Uploaded', context: context);
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // } else {
            final img = await store.takeCertificate(source: ImageSource.camera);
            if (img != null) {
              // const uploadFSSAIImage1 =
              //     'https://medrpha.com/api/register/registerfssaiimg';
              const uploadFSSAIImage1 =
                  'https://test.medrpha.com/api/register/registerfssaiimg';
              final bytes = await img.readAsBytes();
              store.saveCertificate(
                path: img.path,
                bytes: bytes,
                url: uploadFSSAIImage1,
                context: context,
              );
              final model =
                  store.profileModel.fssaiModel.copyWith(numberBytes: bytes);
              store.profileModel =
                  store.profileModel.copyWith(fssaiModel: model);
            } else {
              final snackBar = ConstantWidget.customSnackBar(
                  text: 'No Image Uploaded', context: context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            // }
            break;
          case 3:
            // if (store.profileModel.fssaiModel.numberBytes.isNotEmpty) {
            //   final snackBar = ConstantWidget.customSnackBar(
            //       text: 'Already Uploaded', context: context);
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // } else {
            final img =
                await store.takeCertificate(source: ImageSource.gallery);
            if (img != null) {
              // const uploadFSSAIImage1 =
              //     'https://medrpha.com/api/register/registerfssaiimg';
              const uploadFSSAIImage1 =
                  'https://test.medrpha.com/api/register/registerfssaiimg';
              final bytes = await img.readAsBytes();
              store.saveCertificate(
                path: img.path,
                bytes: bytes,
                url: uploadFSSAIImage1,
                context: context,
              );
              final model =
                  store.profileModel.fssaiModel.copyWith(numberBytes: bytes);
              store.profileModel =
                  store.profileModel.copyWith(fssaiModel: model);
            } else {
              final snackBar = ConstantWidget.customSnackBar(
                  text: 'No Image Uploaded', context: context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            // }
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.all(blockSizeHorizontal(context: context) * 4),
        decoration: BoxDecoration(
          color: ConstantData.bgColor,
          borderRadius:
              BorderRadius.circular(blockSizeHorizontal(context: context) * 5),
          border: Border.all(
            color: ConstantData.mainTextColor,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.note_add_outlined,
              color: color,
              size: blockSizeHorizontal(context: context) * 12,
            ),
            ConstantWidget.getTextWidget(
              text,
              ConstantData.mainTextColor,
              TextAlign.center,
              FontWeight.w500,
              font18Px(context: context),
            )
          ],
        ),
      ),
    );
  }
}

// class InputDropDown extends StatelessWidget {
//   const InputDropDown({
//     Key? key,
//     required this.itemsList,
//     required this.label,
//     required this.func,
//     required this.value,
//     // this.modelType,
//   }) : super(key: key);

//   final List<String> itemsList;
//   final String value;
//   final Function(String) func;
//   final String label;
//   // final dynamic modelType;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           vertical: blockSizeVertical(context: context) * 1),
//       child: SizedBox(
//         height: blockSizeVertical(context: context) * 6,
//         child: DropdownSearch<String>(
//           // focusNode: country,
//           autoValidateMode: AutovalidateMode.onUserInteraction,

//           // mode: Mode.BOTTOM_SHEET,
//           items: itemsList,
//           popupProps: const PopupProps.modalBottomSheet(),
//           dropdownDecoratorProps:
//               const DropDownDecoratorProps(textAlign: TextAlign.center),

//           dropdownBuilder: (_, value) {
//             return ConstantWidget.getTextWidget(
//               value ?? label,
//               ConstantData.mainTextColor,
//               TextAlign.center,
//               FontWeight.w600,
//               font18Px(context: context),
//             );
//           },
//           // hint: "Select Country",
//           onChanged: (value) {
//             func(value!);
//           },
//           selectedItem: value,
//         ),
//       ),
//     );
//   }
// }

typedef Validator = String? Function(String?);

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.action,
    required this.hint,
    required this.keyboardType,
    required this.label,
    required this.obscure,
    this.func,
    this.errorText,
    this.maxLine,
    this.font,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction action;
  final bool obscure;
  final String? errorText;
  final Validator? func;
  final double? font;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: blockSizeVertical(context: context),
      ),
      child: SizedBox(
        height: ConstantWidget.getScreenPercentSize(context, 8.5),
        child: TextFormField(
          controller: controller,
          maxLines: maxLine ?? 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscure,
          obscuringCharacter: '*',
          validator: func,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            fontSize: font ?? font18Px(context: context),
            fontWeight: FontWeight.w500,
            color: ConstantData.mainTextColor,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: font18Px(context: context),
              fontWeight: FontWeight.w500,
              color: ConstantData.mainTextColor,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: ConstantData.borderColor,
              fontSize: font18Px(context: context),
              fontWeight: FontWeight.w500,
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: font12Px(context: context) * 1.1,
              fontFamily: ConstantData.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ConstantData.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ConstantData.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ConstantData.primaryColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
