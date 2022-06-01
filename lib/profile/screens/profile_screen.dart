import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/profile/models/firm_info_model.dart';
import 'package:medrpha_customer/profile/store/profile_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/size_config.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List<AddressModel> addressList = DataFile.getAddressList();

  /// ProfilePage controllers
  final firmtNameController = TextEditingController();
  final mailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactController = TextEditingController();
  final altContactController = TextEditingController();
  String country = '';
  String state = '';
  String city = '';

  // GST Page controllers
  final gstNoController = TextEditingController();

  // Drug License Controllers
  final drugLicenseName = TextEditingController();
  final drugLiscenseNo = TextEditingController();
  final drugLicenseValidity = TextEditingController();
  List<int> drugImgBytes = [];

  // FSSAI controllers
  final fssaiNoController = TextEditingController();
  List<int> fssaiImgBytes = [];

  // @override
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);

    return WillPopScope(
        child: Provider<ProfileStore>(
            create: (_) => ProfileStore(),
            builder: (context, _) {
              final store = context.read<ProfileStore>();
              return Scaffold(
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
                        child: ConstantWidget.getTextWidget(
                            'Back',
                            ConstantData.bgColor,
                            TextAlign.center,
                            FontWeight.w400,
                            font18Px(context: context)),
                      );
                    case 2:
                      return FloatingActionButton(
                        onPressed: () {
                          store.page -= 1;
                        },
                        child: ConstantWidget.getTextWidget(
                            'Back',
                            ConstantData.bgColor,
                            TextAlign.center,
                            FontWeight.w400,
                            font18Px(context: context)),
                      );
                    case 3:
                      return FloatingActionButton(
                        onPressed: () {
                          store.page -= 1;
                        },
                        child: ConstantWidget.getTextWidget(
                            'Back',
                            ConstantData.bgColor,
                            TextAlign.center,
                            FontWeight.w400,
                            font18Px(context: context)),
                      );
                    default:
                      return FloatingActionButton(
                        onPressed: () {
                          store.page -= 1;
                        },
                        child: ConstantWidget.getTextWidget(
                            'Back',
                            ConstantData.bgColor,
                            TextAlign.center,
                            FontWeight.w400,
                            font18Px(context: context)),
                      );
                  }
                }),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal(context: context) * 3,
                  ),
                  child: Row(
                    children: [
                      Observer(builder: (_) {
                        return Expanded(
                          child: Container(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 7.5),
                            // margin: EdgeInsets.symmetric(
                            //     vertical: ConstantWidget.getScreenPercentSize(
                            //         context, 1.2)),
                            decoration: BoxDecoration(
                              color: ConstantData.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(ConstantWidget.getPercentSize(
                                    ConstantWidget.getScreenPercentSize(
                                        context, 7.5),
                                    20)),
                              ),
                            ),
                            child: Observer(builder: (_) {
                              final page = store.page;
                              final dlToFill =
                                  store.profileModel.drugLicenseModel.toFill;
                              final gstToFIll =
                                  store.profileModel.gstModel.toFill;
                              final fssaiToFill =
                                  store.profileModel.fssaiModel.toFill;

                              switch (page) {
                                case 0:
                                  return InkWell(
                                    onTap: () {
                                      if (firmtNameController.text.isNotEmpty &&
                                          addressController.text.isNotEmpty &&
                                          mailController.text.isNotEmpty &&
                                          phoneController.text.isNotEmpty &&
                                          pinController.text.isNotEmpty &&
                                          country != '' &&
                                          city != '' &&
                                          state != '' &&
                                          contactNameController
                                              .text.isNotEmpty &&
                                          contactController.text.isNotEmpty &&
                                          altContactController
                                              .text.isNotEmpty) {
                                        final firmInfoModel = FirmInfoModel(
                                          firmName:
                                              firmtNameController.text.trim(),
                                          email: mailController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          country: country,
                                          city: city,
                                          state: state,
                                          pin: pinController.text.trim(),
                                          address:
                                              addressController.text.trim(),
                                          contactName:
                                              contactNameController.text.trim(),
                                          contactNo:
                                              contactController.text.trim(),
                                          altContactNo:
                                              altContactController.text.trim(),
                                        );

                                        store.profileModel = store.profileModel
                                            .copyWith(
                                                firmInfoModel: firmInfoModel);

                                        store.page += 1;
                                      } else {
                                        // print(firmtNameController.text);
                                        // print(contactController.text);
                                        // print(mailController.text);
                                        // print(altContactController.text);
                                        // print(addressController.text);
                                        // print(phoneController.text);
                                        // print(contactNameController.text);
                                        // print(pinController.text);
                                        final snackBar = ConstantData()
                                            .snackBarValidation(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: ConstantWidget.getButtonWidget(
                                      context,
                                      'Next',
                                      ConstantData.primaryColor,
                                      // ConstantData.bgColor,
                                      // Icons.arrow_back_ios_new,
                                      // 12,
                                    ),
                                  );
                                case 1:
                                  return InkWell(
                                    onTap: () {
                                      if (gstToFIll) {
                                        if (gstNoController.text.isNotEmpty) {
                                          final gstModel = store
                                              .profileModel.gstModel
                                              .copyWith(
                                                  gstNo: gstNoController.text
                                                      .trim());
                                          store.profileModel = store
                                              .profileModel
                                              .copyWith(gstModel: gstModel);
                                          store.page += 1;
                                        } else {
                                          final snackBar = ConstantData()
                                              .snackBarValidation(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      } else {
                                        store.page += 1;
                                      }
                                    },
                                    child: ConstantWidget.getButtonWidget(
                                      context,
                                      'Next',
                                      ConstantData.primaryColor,
                                      // ConstantData.bgColor,
                                      // Icons.arrow_back_ios_new,
                                      // 12,
                                    ),
                                  );
                                case 2:
                                  return InkWell(
                                    onTap: () {
                                      if (dlToFill) {
                                        final license1 = store.profileModel
                                            .drugLicenseModel.license1Bytes;
                                        final license2 = store.profileModel
                                            .drugLicenseModel.license2Bytes;
                                        // print(license1);
                                        // print(license2);
                                        if (drugLiscenseNo.text.isNotEmpty &&
                                            drugLicenseName.text.isNotEmpty &&
                                            drugLicenseValidity
                                                .text.isNotEmpty &&
                                            license1.isNotEmpty &&
                                            license2.isNotEmpty) {
                                          final drugLicenseModel = store
                                              .profileModel.drugLicenseModel
                                              .copyWith(
                                            name: drugLicenseName.text.trim(),
                                            number: drugLiscenseNo.text.trim(),
                                            validity:
                                                drugLicenseValidity.text.trim(),
                                            // licenseBytes: drugImgBytes,
                                          );
                                          store.profileModel =
                                              store.profileModel.copyWith(
                                                  drugLicenseModel:
                                                      drugLicenseModel);
                                          store.page += 1;
                                        } else {
                                          final snackBar = ConstantData()
                                              .snackBarValidation(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      } else {
                                        store.page += 1;
                                      }
                                    },
                                    child: ConstantWidget.getButtonWidget(
                                      context,
                                      'Next',
                                      ConstantData.primaryColor,
                                      // ConstantData.bgColor,
                                      // Icons.arrow_back_ios_new,
                                      // 12,
                                    ),
                                  );
                                case 3:
                                  return Center(child: Observer(builder: (_) {
                                    final state = store.saveState;

                                    switch (state) {
                                      case ButtonState.LOADING:
                                        return CircularProgressIndicator(
                                          color: ConstantData.bgColor,
                                        );
                                      case ButtonState.ERROR:
                                        // final _snackBar =
                                        //     ConstantWidget.customSnackBar(
                                        //         text:
                                        //             'Failed to Update Profile please try again',
                                        //         context: context);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(_snackBar);
                                        return InkWell(
                                          onTap: () async {
                                            if (fssaiToFill) {
                                              final license = store.profileModel
                                                  .fssaiModel.numberBytes;
                                              if (fssaiNoController
                                                      .text.isNotEmpty &&
                                                  license.isNotEmpty) {
                                                final fssaiModel = store
                                                    .profileModel.fssaiModel
                                                    .copyWith(
                                                  number: fssaiNoController.text
                                                      .trim(),
                                                );

                                                store.profileModel =
                                                    store.profileModel.copyWith(
                                                        fssaiModel: fssaiModel);
                                              } else {
                                                final snackBar = ConstantData()
                                                    .snackBarValidation(
                                                        context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                            await store.updateProfile(
                                                context: context);
                                          },
                                          child: ConstantWidget
                                              .getDefaultTextWidget(
                                                  'Save',
                                                  TextAlign.center,
                                                  FontWeight.w500,
                                                  font22Px(context: context),
                                                  ConstantData.bgColor),
                                        );
                                      case ButtonState.SUCCESS:
                                        return InkWell(
                                          onTap: () async {
                                            if (fssaiToFill) {
                                              if (fssaiNoController
                                                  .text.isNotEmpty) {
                                                final fssaiModel = store
                                                    .profileModel.fssaiModel
                                                    .copyWith(
                                                  number: fssaiNoController.text
                                                      .trim(),
                                                  numberBytes: [],
                                                );

                                                store.profileModel =
                                                    store.profileModel.copyWith(
                                                        fssaiModel: fssaiModel);

                                                // await store.updateProfile(
                                                //     context: context);
                                              } else {
                                                final snackBar = ConstantData()
                                                    .snackBarValidation(
                                                        context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                            await store.updateProfile(
                                                context: context);
                                          },
                                          child: ConstantWidget.getButtonWidget(
                                              context,
                                              'Save',
                                              ConstantData.primaryColor),
                                        );
                                    }
                                  }));
                                default:
                                  return FloatingActionButton(
                                      onPressed: () {
                                        store.page -= 1;
                                      },
                                      child: ConstantWidget.getTextWidget(
                                          'Back',
                                          ConstantData.bgColor,
                                          TextAlign.center,
                                          FontWeight.w400,
                                          font18Px(context: context)));
                              }
                            }),
                          ),
                          flex: 1,
                        );
                      }),
                    ],
                  ),
                ),
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: ConstantData.bgColor,
                  title: Observer(builder: (_) {
                    final page = store.page;

                    switch (page) {
                      case 0:
                        return ConstantWidget.getAppBarText('Profile', context);
                      case 1:
                        return ConstantWidget.getAppBarText('GST', context);
                      case 2:
                        return ConstantWidget.getAppBarText(
                            'Drug License', context);
                      case 3:
                        return ConstantWidget.getAppBarText('FASSAI', context);
                      default:
                        return ConstantWidget.getAppBarText('Profile', context);
                    }
                  }),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: ConstantWidget.getAppBarIcon(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                // bottomNavigationBar:
                //     ConstantWidget.getBottomText(context, 'save', () {
                //   // Navigator.of(context).pop(true);

                // }),
                body: Column(
                  children: [
                    Observer(builder: (_) {
                      final page = store.page;

                      switch (page) {
                        case 0:
                          return profile(store: store);
                        // return drugLicenseProfile(store: store);
                        // return fssaiProfile(store: store);
                        // return gstProfile(store: store);
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
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: blockSizeHorizontal(context: context) * 3,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Observer(builder: (_) {
                    //         return Expanded(
                    //           child: InkWell(
                    //             onTap: () {
                    //               if (store.page < 3) {
                    //                 store.page += 1;
                    //               }
                    //             },
                    //             child: ConstantWidget.getButtonWidget(
                    //               context,
                    //               'Next',
                    //               ConstantData.primaryColor,
                    //               // ConstantData.bgColor,
                    //               // Icons.arrow_back_ios_new,
                    //               // 12,
                    //             ),
                    //           ),
                    //           flex: 1,
                    //         );
                    //       }),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: blockSizeHorizontal(context: context) * 3,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Observer(builder: (_) {
                    //         final page = store.page;

                    //         switch (page) {
                    //           case 0:
                    //             return const SizedBox();
                    //           case 1:
                    //             return Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   if (store.page > 0) {
                    //                     store.page -= 1;
                    //                   }
                    //                 },
                    //                 child: ConstantWidget.getButtonWidget(
                    //                   context,
                    //                   'Previous',
                    //                   ConstantData.primaryColor,
                    //                   // ConstantData.bgColor,
                    //                   // Icons.arrow_back_ios_new,
                    //                   // 12,
                    //                 ),
                    //               ),
                    //               flex: 1,
                    //             );
                    //           case 2:
                    //             return Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   if (store.page > 0) {
                    //                     store.page -= 1;
                    //                   }
                    //                 },
                    //                 child: ConstantWidget.getButtonWidget(
                    //                   context,
                    //                   'Previous',
                    //                   ConstantData.primaryColor,
                    //                   // ConstantData.bgColor,
                    //                   // Icons.arrow_back_ios_new,
                    //                   // 12,
                    //                 ),
                    //               ),
                    //               flex: 1,
                    //             );
                    //           case 3:
                    //             return Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   if (store.page > 0) {
                    //                     store.page -= 1;
                    //                   }
                    //                 },
                    //                 child: ConstantWidget.getButtonWidget(
                    //                   context,
                    //                   'Previous',
                    //                   ConstantData.primaryColor,
                    //                   // ConstantData.bgColor,
                    //                   // Icons.arrow_back_ios_new,
                    //                   // 12,
                    //                 ),
                    //               ),
                    //               flex: 1,
                    //             );
                    //           default:
                    //             return Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   if (store.page > 0) {
                    //                     store.page -= 1;
                    //                   }
                    //                 },
                    //                 child: ConstantWidget.getButtonWidget(
                    //                   context,
                    //                   'Previous',
                    //                   ConstantData.primaryColor,
                    //                   // ConstantData.bgColor,
                    //                   // Icons.arrow_back_ios_new,
                    //                   // 12,
                    //                 ),
                    //               ),
                    //               flex: 1,
                    //             );
                    //         }
                    //       }),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: defaultMargin,
                    // ),
                    // InkWell(
                    //   child: Container(
                    //       margin: EdgeInsets.only(top: 10, bottom: leftMargin),
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //           color: ConstantData.primaryColor,
                    //           borderRadius: BorderRadius.all(Radius.circular(8))),
                    //       child: InkWell(
                    //         child: Center(
                    //           child: ConstantWidget.getCustomTextWithoutAlign(
                    //               S.of(context)!.save,
                    //               Colors.white,
                    //               FontWeight.w900,
                    //               ConstantData.font15Px),
                    //
                    //           // child: Text(
                    //           //   S.of(context)!.save,
                    //           //   style: TextStyle(
                    //           //       fontFamily: ConstantData.fontFamily,
                    //           //       fontWeight: FontWeight.w900,
                    //           //       fontSize: ConstantData.font15Px,
                    //           //       color: Colors.white,
                    //           //       decoration: TextDecoration.none),
                    //           // ),
                    //         ),
                    //       )),
                    //   onTap: () {
                    //     Navigator.of(context).pop(true);
                    //   },
                    // ),
                  ],
                ),
              );
            }),
        onWillPop: () {
          // Navigator.pop(context);
          return Future.value(true);
        });
  }

  Widget fssaiProfile({required ProfileStore store}) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.06;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      final toFill = store.profileModel.fssaiModel.toFill;
      return Expanded(
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
                                ConstantData.assetsPath + "fssai.png",
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
                        FontWeight.w500,
                        font18Px(context: context)),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 5,
                    ),
                    InkWell(
                      onTap: () {
                        final model = store.profileModel.fssaiModel
                            .copyWith(toFill: !toFill);
                        store.profileModel =
                            store.profileModel.copyWith(fssaiModel: model);
                      },
                      child: ConstantWidget.getButtonWidget(
                        context,
                        'Yes',
                        ConstantData.accentColor,
                      ),
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
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: (defaultMargin / 2),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: (defaultMargin / 2)),
                                height: editTextHeight,
                                child: InputField(
                                  controller: fssaiNoController,
                                  inputType: TextInputType.number,
                                  label: 'FSSAI NO',
                                ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
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
                              flex: 1,
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
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            UploadIconButton(
                              context: context,
                              icon: Icons.camera,
                              color: Colors.orange,
                              source: ImageSource.camera,
                              text: 'Camera',
                              store: store,
                              // func: () async {
                              //   if (store.profileModel.fssaiModel.numberBytes
                              //       .isNotEmpty) {
                              //     final _snackBar =
                              //         ConstantWidget.customSnackBar(
                              //             text: 'Already Uploaded',
                              //             context: context);
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(_snackBar);
                              //   } else {
                              //     final img = await store.takeCertificate(
                              //         source: ImageSource.camera);
                              //     if (img != null) {
                              //       const _uploadFSSAIImage1 =
                              //           'https://medrpha.com/api/register/registerfssaiimg';
                              //       final _bytes = await img.readAsBytes();
                              //       store.saveCertificate(
                              //         path: img.path,
                              //         bytes: _bytes,
                              //         url: _uploadFSSAIImage1,
                              //       );
                              //     } else {
                              //       final _snackBar =
                              //           ConstantWidget.customSnackBar(
                              //               text: 'No Image Uploaded',
                              //               context: context);
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(_snackBar);
                              //     }
                              //   }
                              // },
                              certificateType: 2,
                            ),
                            UploadIconButton(
                              context: context,
                              icon: Icons.photo_album_outlined,
                              color: Colors.blue,
                              source: ImageSource.gallery,
                              store: store,
                              text: 'Gallery',
                              // func: () async {
                              //   if (store.profileModel.fssaiModel.numberBytes
                              //       .isNotEmpty) {
                              //     final _snackBar =
                              //         ConstantWidget.customSnackBar(
                              //             text: 'Already Uploaded',
                              //             context: context);
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(_snackBar);
                              //   } else {
                              //     final img = await store.takeCertificate(
                              //         source: ImageSource.gallery);
                              //     if (img != null) {
                              //       const _uploadFSSAIImage1 =
                              //           'https://medrpha.com/api/register/registerfssaiimg';
                              //       final _bytes = await img.readAsBytes();
                              //       store.saveCertificate(
                              //         path: img.path,
                              //         bytes: _bytes,
                              //         url: _uploadFSSAIImage1,
                              //       );
                              //     } else {
                              //       final _snackBar =
                              //           ConstantWidget.customSnackBar(
                              //               text: 'No Image Uploaded',
                              //               context: context);
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(_snackBar);
                              //     }
                              //   }
                              // },
                              certificateType: 3,
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
                              'Certificate',
                              ConstantData.mainTextColor,
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: defaultMargin,
                        ),
                        Observer(builder: (_) {
                          final model = store.profileModel;

                          if (model.fssaiModel.numberBytes.isEmpty) {
                            return Column(
                              children: [
                                Icon(
                                  Icons.note_add,
                                  color: ConstantData.bgColor,
                                  size: blockSizeHorizontal(context: context) *
                                      13,
                                ),
                                SizedBox(
                                  height:
                                      blockSizeVertical(context: context) * 2,
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
                            return const SizedBox();
                          }
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

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         return Expanded(
            //           child: Container(
            //             height:
            //                 ConstantWidget.getScreenPercentSize(context, 7.5),
            //             margin: EdgeInsets.symmetric(
            //                 vertical: ConstantWidget.getScreenPercentSize(
            //                     context, 1.2)),
            //             decoration: BoxDecoration(
            //               color: ConstantData.primaryColor,
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(ConstantWidget.getPercentSize(
            //                     ConstantWidget.getScreenPercentSize(
            //                         context, 7.5),
            //                     20)),
            //               ),
            //             ),
            //             child: Center(child: Observer(builder: (_) {
            //               final state = store.saveState;

            //               switch (state) {
            //                 case ButtonState.LOADING:
            //                   return CircularProgressIndicator(
            //                     color: ConstantData.bgColor,
            //                   );
            //                 case ButtonState.ERROR:
            //                   final _snackBar = ConstantWidget.customSnackBar(
            //                       text:
            //                           'Failed to Update Profile please try again',
            //                       context: context);
            //                   ScaffoldMessenger.of(context)
            //                       .showSnackBar(_snackBar);
            //                   return InkWell(
            //                     onTap: () async {
            //                       if (fssaiNoController.text.isNotEmpty) {
            //                         final fssaiModel =
            //                             store.profileModel.fssaiModel.copyWith(
            //                           number: fssaiNoController.text.trim(),
            //                           numberBytes: [],
            //                         );

            //                         store.profileModel = store.profileModel
            //                             .copyWith(fssaiModel: fssaiModel);

            //                         await store.updateProfile();
            //                       } else {
            //                         final snackBar = ConstantData()
            //                             .snackBarValidation(context);
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(snackBar);
            //                       }
            //                     },
            //                     child: ConstantWidget.getDefaultTextWidget(
            //                         'Save',
            //                         TextAlign.center,
            //                         FontWeight.w500,
            //                         font22Px(context: context),
            //                         ConstantData.bgColor),
            //                   );
            //                 case ButtonState.SUCCESS:
            //                   return InkWell(
            //                     onTap: () async {
            //                       if (toFill) {
            //                         if (fssaiNoController.text.isNotEmpty) {
            //                           final fssaiModel = store
            //                               .profileModel.fssaiModel
            //                               .copyWith(
            //                             number: fssaiNoController.text.trim(),
            //                             numberBytes: [],
            //                           );

            //                           store.profileModel = store.profileModel
            //                               .copyWith(fssaiModel: fssaiModel);

            //                           await store.updateProfile();
            //                         } else {
            //                           final snackBar = ConstantData()
            //                               .snackBarValidation(context);
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(snackBar);
            //                         }
            //                       }
            //                     },
            //                     child: ConstantWidget.getButtonWidget(
            //                         context, 'Save', ConstantData.primaryColor),
            //                   );
            //               }
            //             })),
            //           ),
            //           flex: 1,
            //         );
            //       }),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         final page = store.page;

            //         switch (page) {
            //           case 0:
            //             return const SizedBox();
            //           case 1:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 2:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 3:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           default:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //         }
            //       }),
            //     ],
            //   ),
            // ),

            // SizedBox(
            //   height: defaultMargin,
            // ),
          ],
        ),
        flex: 1,
      );
    });
  }

  Widget drugLicenseProfile({required ProfileStore store}) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.06;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      final toFill = store.profileModel.drugLicenseModel.toFill;
      return Expanded(
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
                                ConstantData.assetsPath + "dl.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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
                              'Drug License Details',
                              ConstantData.mainTextColor,
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: (defaultMargin / 2),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: (defaultMargin / 2)),
                                    padding: EdgeInsets.only(
                                        right: (defaultMargin / 1.5)),
                                    height: editTextHeight,
                                    child: InputField(
                                      controller: drugLiscenseNo,
                                      inputType: TextInputType.number,
                                      // hintText: 'XYZ',
                                      label: 'Drug License Number',
                                    ),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: (defaultMargin / 2)),
                                    padding: EdgeInsets.only(
                                        left: (defaultMargin / 1.5)),
                                    height: editTextHeight,
                                    child: InputField(
                                      controller: drugLicenseName,
                                      inputType: TextInputType.name,
                                      label: 'Drug License Name',
                                    ),
                                  ),
                                ],
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: (defaultMargin / 2)),
                          height: editTextHeight,
                          // child: InputField(
                          //   controller: drugLicenseValidity,
                          //   label: 'Drug License Validity',
                          // ),
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
                                fontWeight: FontWeight.w400,
                                fontSize: font18Px(context: context)),
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
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: blockSizeVertical(context: context) * 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            UploadIconButton(
                              context: context,
                              icon: Icons.note_add_outlined,
                              color: Colors.orange,
                              source: ImageSource.camera,
                              text: 'DL1',
                              store: store,
                              // func: () async {
                              //   print('1');
                              //   if (store.profileModel.drugLicenseModel
                              //       .license1Bytes.isNotEmpty) {
                              //     final _snackBar =
                              //         ConstantWidget.customSnackBar(
                              //             text: 'Already Uploaded',
                              //             context: context);
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(_snackBar);
                              //   } else {
                              //     final img = await store.takeCertificate(
                              //         source: ImageSource.gallery);
                              //     if (img != null) {
                              //       const _uploadDLImage1 =
                              //           'https://medrpha.com/api/register/registerdl1';
                              //       final _bytes = await img.readAsBytes();
                              //       store.saveCertificate(
                              //         path: img.path,
                              //         bytes: _bytes,
                              //         url: _uploadDLImage1,
                              //       );
                              //     } else {
                              //       final _snackBar =
                              //           ConstantWidget.customSnackBar(
                              //               text: 'No Image Uploaded',
                              //               context: context);
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(_snackBar);
                              //     }
                              //   }
                              // },
                              certificateType: 0,
                            ),
                            UploadIconButton(
                              context: context,
                              icon: Icons.note_add_outlined,
                              color: Colors.blue,
                              source: ImageSource.gallery,
                              store: store,
                              text: 'DL2',
                              // func: () async {
                              //   if (store.profileModel.drugLicenseModel
                              //       .license2Bytes.isNotEmpty) {
                              //     final _snackBar =
                              //         ConstantWidget.customSnackBar(
                              //             text: 'Already Uploaded',
                              //             context: context);
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(_snackBar);
                              //   } else {
                              //     final img = await store.takeCertificate(
                              //         source: ImageSource.gallery);
                              //     if (img != null) {
                              //       const _uploadDLImage2 =
                              //           'https://medrpha.com/api/register/registerdl2';
                              //       final _bytes = await img.readAsBytes();
                              //       store.saveCertificate(
                              //         path: img.path,
                              //         bytes: _bytes,
                              //         url: _uploadDLImage2,
                              //       );
                              //     } else {
                              //       final _snackBar =
                              //           ConstantWidget.customSnackBar(
                              //               text: 'No Image Uploaded',
                              //               context: context);
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(_snackBar);
                              //     }
                              //   }
                              // },
                              certificateType: 1,
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
                              'Certificate',
                              ConstantData.mainTextColor,
                              FontWeight.bold,
                              font22Px(context: context)),
                        ),
                        SizedBox(
                          height: defaultMargin,
                        ),
                        Observer(builder: (_) {
                          final model = store.profileModel;

                          if (model.drugLicenseModel.license1Bytes.isEmpty &&
                              model.drugLicenseModel.license2Bytes.isNotEmpty) {
                            return Column(
                              children: [
                                Icon(
                                  Icons.note_add,
                                  color: ConstantData.bgColor,
                                  size: blockSizeHorizontal(context: context) *
                                      13,
                                ),
                                SizedBox(
                                  height:
                                      blockSizeVertical(context: context) * 2,
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
                            return const SizedBox();
                          }
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
                        'Do you want to fill Drug License details?',
                        ConstantData.mainTextColor,
                        TextAlign.center,
                        FontWeight.w500,
                        font18Px(context: context)),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 5,
                    ),
                    InkWell(
                      onTap: () {
                        final model = store.profileModel.drugLicenseModel
                            .copyWith(toFill: !toFill);
                        store.profileModel = store.profileModel
                            .copyWith(drugLicenseModel: model);
                      },
                      child: ConstantWidget.getButtonWidget(
                        context,
                        'Yes',
                        ConstantData.accentColor,
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: blockSizeVertical(context: context) * 4,
            ),

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         return Expanded(
            //           child: InkWell(
            //             onTap: () {
            //               if (toFill) {
            //                 if (drugLiscenseNo.text.isNotEmpty &&
            //                     drugLicenseName.text.isNotEmpty &&
            //                     drugLicenseValidity.text.isNotEmpty &&
            //                     drugImgBytes.isNotEmpty) {
            //                   final drugLicenseModel =
            //                       store.profileModel.drugLicenseModel.copyWith(
            //                     name: drugLicenseName.text.trim(),
            //                     number: drugLiscenseNo.text.trim(),
            //                     validity: drugLicenseValidity.text.trim(),
            //                     // licenseBytes: drugImgBytes,
            //                   );
            //                   store.profileModel = store.profileModel
            //                       .copyWith(drugLicenseModel: drugLicenseModel);
            //                   store.page += 1;
            //                 } else {
            //                   final snackBar =
            //                       ConstantData().snackBarValidation(context);
            //                   ScaffoldMessenger.of(context)
            //                       .showSnackBar(snackBar);
            //                 }
            //               } else {
            //                 store.page += 1;
            //               }
            //             },
            //             child: ConstantWidget.getButtonWidget(
            //               context,
            //               'Next',
            //               ConstantData.primaryColor,
            //               // ConstantData.bgColor,
            //               // Icons.arrow_back_ios_new,
            //               // 12,
            //             ),
            //           ),
            //           flex: 1,
            //         );
            //       }),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         final page = store.page;

            //         switch (page) {
            //           case 0:
            //             return const SizedBox();
            //           case 1:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 2:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 3:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           default:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //         }
            //       }),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: defaultMargin,
            // ),
          ],
        ),
        flex: 1,
      );
    });
  }

  Widget gstProfile({required ProfileStore store}) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.06;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Observer(builder: (_) {
      final toFill = store.profileModel.gstModel.toFill;

      return Expanded(
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
                                ConstantData.assetsPath + "gst.png",
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
                        FontWeight.w500,
                        font18Px(context: context)),
                    SizedBox(
                      height: blockSizeVertical(context: context) * 5,
                    ),
                    InkWell(
                      onTap: () {
                        final model = store.profileModel.gstModel
                            .copyWith(toFill: !toFill);
                        store.profileModel =
                            store.profileModel.copyWith(gstModel: model);
                      },
                      child: ConstantWidget.getButtonWidget(
                        context,
                        'Yes',
                        ConstantData.accentColor,
                      ),
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
                          FontWeight.bold,
                          font22Px(context: context)),
                    ),
                    SizedBox(
                      height: (defaultMargin / 2),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            height: editTextHeight,
                            child: InputField(
                              controller: gstNoController,
                              inputType: TextInputType.number,
                              label: 'GST NO',
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
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
                          flex: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(
            //   height: blockSizeVertical(context: context) * 30,
            // ),

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         return Expanded(
            //           child: InkWell(
            //             onTap: () {
            // if (toFill) {
            //   if (gstNoController.text.isNotEmpty) {
            //     final gstModel = store.profileModel.gstModel
            //         .copyWith(gstNo: gstNoController.text.trim());
            //     store.profileModel = store.profileModel
            //         .copyWith(gstModel: gstModel);
            //     store.page += 1;
            //   } else {
            //     final snackBar =
            //         ConstantData().snackBarValidation(context);
            //     ScaffoldMessenger.of(context)
            //         .showSnackBar(snackBar);
            //   }
            // } else {
            //   store.page += 1;
            // }
            //             },
            //             child: ConstantWidget.getButtonWidget(
            //               context,
            //               'Next',
            //               ConstantData.primaryColor,
            //               // ConstantData.bgColor,
            //               // Icons.arrow_back_ios_new,
            //               // 12,
            //             ),
            //           ),
            //           flex: 1,
            //         );
            //       }),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: blockSizeHorizontal(context: context) * 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Observer(builder: (_) {
            //         final page = store.page;

            //         switch (page) {
            //           case 0:
            //             return const SizedBox();
            //           case 1:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 2:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           case 3:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //           default:
            //             return Expanded(
            //               child: InkWell(
            //                 onTap: () {
            //                   if (store.page > 0) {
            //                     store.page -= 1;
            //                   }
            //                 },
            //                 child: ConstantWidget.getButtonWidget(
            //                   context,
            //                   'Previous',
            //                   ConstantData.primaryColor,
            //                   // ConstantData.bgColor,
            //                   // Icons.arrow_back_ios_new,
            //                   // 12,
            //                 ),
            //               ),
            //               flex: 1,
            //             );
            //         }
            //       }),
            //     ],
            //   ),
            // ),

            // SizedBox(
            //   height: defaultMargin,
            // ),
          ],
        ),
        flex: 1,
      );
    });
  }

  Widget profile({required ProfileStore store}) {
    double editTextHeight = MediaQuery.of(context).size.height * 0.06;
    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Expanded(
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
                              ConstantData.assetsPath + "med_logo.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
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
                      FontWeight.bold,
                      font22Px(context: context)),
                ),
                SizedBox(
                  height: (defaultMargin / 2),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(right: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: firmtNameController,
                              inputType: TextInputType.name,
                              // hintText: 'XYZ',
                              label: 'Firm Name',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                    // Expanded(
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         margin: EdgeInsets.symmetric(
                    //             vertical: (defaultMargin / 2)),
                    //         padding:
                    //             EdgeInsets.only(left: (defaultMargin / 1.5)),
                    //         height: editTextHeight,
                    //         child: InputField(
                    //           controller: lastNameController,
                    //           label: 'Last Name',
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   flex: 1,
                    // )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: (defaultMargin / 2)),
                  height: editTextHeight,
                  child: InputField(
                    controller: addressController,
                    inputType: TextInputType.streetAddress,
                    label: 'Address',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(right: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: mailController,
                              inputType: TextInputType.emailAddress,
                              label: 'E-mail',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(left: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: phoneController,
                              inputType: TextInputType.number,
                              label: 'Phone',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InputDropDown(
                            itemsList: const ['India'],
                            label: 'Country',
                            func: (value) {
                              setState(() {
                                country = value;
                              });
                            },
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                    SizedBox(
                      width: blockSizeHorizontal(context: context) * 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          InputDropDown(
                            itemsList: const ['UttarPradhesh', 'Maharashtra'],
                            label: 'State',
                            func: (value) {
                              setState(() {
                                state = value;
                              });
                            },
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InputDropDown(
                            itemsList: const ['Aligarh', 'Mumbai'],
                            label: 'City',
                            func: (value) {
                              setState(() {
                                city = value;
                              });
                            },
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(left: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: pinController,
                              inputType: TextInputType.number,
                              label: 'PinCode',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
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
                      FontWeight.bold,
                      font22Px(context: context)),
                ),
                SizedBox(
                  height: (defaultMargin / 2),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: (defaultMargin / 2)),
                  height: editTextHeight,
                  child: InputField(
                    controller: contactNameController,
                    inputType: TextInputType.name,
                    label: 'Contact Name',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(right: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: contactController,
                              inputType: TextInputType.number,
                              // hintText: 'XYZ',
                              label: 'Contact',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (defaultMargin / 2)),
                            padding:
                                EdgeInsets.only(left: (defaultMargin / 1.5)),
                            height: editTextHeight,
                            child: InputField(
                              controller: altContactController,
                              inputType: TextInputType.number,
                              label: 'Alternate Contact',
                            ),
                          ),
                        ],
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ],
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: blockSizeHorizontal(context: context) * 3,
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: InkWell(
          //           onTap: () {
          //             if (firmtNameController.text.isNotEmpty &&
          //                 addressController.text.isNotEmpty &&
          //                 mailController.text.isNotEmpty &&
          //                 phoneController.text.isNotEmpty &&
          //                 pinController.text.isNotEmpty &&
          //                 country == '' &&
          //                 city == '' &&
          //                 state == '' &&
          //                 contactNameController.text.isNotEmpty &&
          //                 contactController.text.isNotEmpty &&
          //                 altContactController.text.isNotEmpty) {
          //               final firmInfoModel = FirmInfoModel(
          //                 firmName: firmtNameController.text.trim(),
          //                 email: mailController.text.trim(),
          //                 phone: phoneController.text.trim(),
          //                 country: country,
          //                 city: city,
          //                 state: state,
          //                 pin: pinController.text.trim(),
          //                 address: addressController.text.trim(),
          //                 contactName: contactNameController.text.trim(),
          //                 contactNo: contactController.text.trim(),
          //                 altContactNo: altContactController.text.trim(),
          //               );

          //               store.profileModel = store.profileModel
          //                   .copyWith(firmInfoModel: firmInfoModel);

          //               store.page += 1;
          //             } else {
          //               final snackBar =
          //                   ConstantData().snackBarValidation(context);
          //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //             }
          //           },
          //           child: ConstantWidget.getButtonWidget(
          //             context,
          //             'Next',
          //             ConstantData.primaryColor,
          //             // ConstantData.bgColor,
          //             // Icons.arrow_back_ios_new,
          //             // 12,
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: blockSizeHorizontal(context: context) * 3,
          //   ),
          //   child: Row(
          //     children: [
          //       Observer(builder: (_) {
          //         final page = store.page;

          //         switch (page) {
          //           case 0:
          //             return const SizedBox();
          //           case 1:
          //             return Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   if (store.page > 0) {
          //                     store.page -= 1;
          //                   }
          //                 },
          //                 child: ConstantWidget.getButtonWidget(
          //                   context,
          //                   'Previous',
          //                   ConstantData.primaryColor,
          //                   // ConstantData.bgColor,
          //                   // Icons.arrow_back_ios_new,
          //                   // 12,
          //                 ),
          //               ),
          //               flex: 1,
          //             );
          //           case 2:
          //             return Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   if (store.page > 0) {
          //                     store.page -= 1;
          //                   }
          //                 },
          //                 child: ConstantWidget.getButtonWidget(
          //                   context,
          //                   'Previous',
          //                   ConstantData.primaryColor,
          //                   // ConstantData.bgColor,
          //                   // Icons.arrow_back_ios_new,
          //                   // 12,
          //                 ),
          //               ),
          //               flex: 1,
          //             );
          //           case 3:
          //             return Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   if (store.page > 0) {
          //                     store.page -= 1;
          //                   }
          //                 },
          //                 child: ConstantWidget.getButtonWidget(
          //                   context,
          //                   'Previous',
          //                   ConstantData.primaryColor,
          //                   // ConstantData.bgColor,
          //                   // Icons.arrow_back_ios_new,
          //                   // 12,
          //                 ),
          //               ),
          //               flex: 1,
          //             );
          //           default:
          //             return Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   if (store.page > 0) {
          //                     store.page -= 1;
          //                   }
          //                 },
          //                 child: ConstantWidget.getButtonWidget(
          //                   context,
          //                   'Previous',
          //                   ConstantData.primaryColor,
          //                   // ConstantData.bgColor,
          //                   // Icons.arrow_back_ios_new,
          //                   // 12,
          //                 ),
          //               ),
          //               flex: 1,
          //             );
          //         }
          //       }),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: defaultMargin,
          // ),
        ],
      ),
      flex: 1,
    );
  }
}

//  /// For Drug License Certificates.
//           if (modelType == 1) {
// if (store.profileModel.drugLicenseModel.licenseBytes.isNotEmpty) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: ConstantWidget.getTextWidget(
//           'Already Uploaded',
//           ConstantData.bgColor,
//           TextAlign.left,
//           FontWeight.w500,
//           font18Px(context: context))));
// } else {
//   final imgBytes = await store.uploadertificate(source: source);
//   final model = store.profileModel.drugLicenseModel;
//   store.profileModel = store.profileModel.copyWith(
//       drugLicenseModel: model.copyWith(licenseBytes: imgBytes));
// }
//           } else {
//             /// For FSSAI Certificate.
//             if (store.profileModel.fssaiModel.numberBytes.isNotEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: ConstantWidget.getTextWidget(
//                       'Already Uploaded',
//                       ConstantData.bgColor,
//                       TextAlign.left,
//                       FontWeight.w500,
//                       font18Px(context: context))));
//             } else {
//               final imgBytes = await store.uploadertificate(source: source);
//               final model = store.profileModel.fssaiModel;
//               store.profileModel = store.profileModel
//                   .copyWith(fssaiModel: model.copyWith(numberBytes: imgBytes));
//             }
//           }

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
              if (store
                  .profileModel.drugLicenseModel.license2Bytes.isNotEmpty) {
                final _snackBar = ConstantWidget.customSnackBar(
                    text: 'Already Uploaded', context: context);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else {
                final img =
                    await store.takeCertificate(source: ImageSource.gallery);
                if (img != null) {
                  const _uploadDLImage2 =
                      'https://test.com/api/register/registerdl2';
                  final _bytes = await img.readAsBytes();
                  store.saveCertificate(
                    path: img.path,
                    bytes: _bytes,
                    url: _uploadDLImage2,
                  );
                  final model = store.profileModel.drugLicenseModel
                      .copyWith(license1Bytes: _bytes);
                  store.profileModel =
                      store.profileModel.copyWith(drugLicenseModel: model);
                } else {
                  final _snackBar = ConstantWidget.customSnackBar(
                      text: 'No Image Uploaded', context: context);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              }
              break;
            case 1:
              if (store
                  .profileModel.drugLicenseModel.license2Bytes.isNotEmpty) {
                final _snackBar = ConstantWidget.customSnackBar(
                    text: 'Already Uploaded', context: context);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else {
                final img =
                    await store.takeCertificate(source: ImageSource.gallery);
                if (img != null) {
                  const _uploadDLImage2 =
                      'https://test.com/api/register/registerdl2';
                  final _bytes = await img.readAsBytes();
                  store.saveCertificate(
                    path: img.path,
                    bytes: _bytes,
                    url: _uploadDLImage2,
                  );
                  final model = store.profileModel.drugLicenseModel
                      .copyWith(license2Bytes: _bytes);
                  store.profileModel =
                      store.profileModel.copyWith(drugLicenseModel: model);
                } else {
                  final _snackBar = ConstantWidget.customSnackBar(
                      text: 'No Image Uploaded', context: context);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              }
              break;
            case 2:
              if (store.profileModel.fssaiModel.numberBytes.isNotEmpty) {
                final _snackBar = ConstantWidget.customSnackBar(
                    text: 'Already Uploaded', context: context);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else {
                final img =
                    await store.takeCertificate(source: ImageSource.camera);
                if (img != null) {
                  const _uploadFSSAIImage1 =
                      'https://test.com/api/register/registerfssaiimg';
                  final _bytes = await img.readAsBytes();
                  store.saveCertificate(
                    path: img.path,
                    bytes: _bytes,
                    url: _uploadFSSAIImage1,
                  );
                  final model = store.profileModel.fssaiModel
                      .copyWith(numberBytes: _bytes);
                  store.profileModel =
                      store.profileModel.copyWith(fssaiModel: model);
                } else {
                  final _snackBar = ConstantWidget.customSnackBar(
                      text: 'No Image Uploaded', context: context);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              }
              break;
            case 3:
              if (store
                  .profileModel.drugLicenseModel.license2Bytes.isNotEmpty) {
                final _snackBar = ConstantWidget.customSnackBar(
                    text: 'Already Uploaded', context: context);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else {
                final img =
                    await store.takeCertificate(source: ImageSource.gallery);
                if (img != null) {
                  const _uploadDLImage2 =
                      'https://medrpha.com/api/register/registerdl2';
                  final _bytes = await img.readAsBytes();
                  store.saveCertificate(
                    path: img.path,
                    bytes: _bytes,
                    url: _uploadDLImage2,
                  );
                  final model = store.profileModel.fssaiModel
                      .copyWith(numberBytes: _bytes);
                  store.profileModel =
                      store.profileModel.copyWith(fssaiModel: model);
                } else {
                  final _snackBar = ConstantWidget.customSnackBar(
                      text: 'No Image Uploaded', context: context);
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                }
              }
          }
        },
        child: Container(
          padding: EdgeInsets.all(blockSizeHorizontal(context: context) * 4),
          decoration: BoxDecoration(
            color: ConstantData.bgColor,
            borderRadius: BorderRadius.circular(
                blockSizeHorizontal(context: context) * 5),
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
        ));
  }
}

class InputDropDown extends StatelessWidget {
  const InputDropDown({
    Key? key,
    required this.itemsList,
    required this.label,
    required this.func,
  }) : super(key: key);

  final List<String> itemsList;
  final String label;
  final Function(String) func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: blockSizeVertical(context: context) * 1),
      child: SizedBox(
        height: blockSizeVertical(context: context) * 6,
        child: DropdownSearch<String>(
          // focusNode: country,
          mode: Mode.BOTTOM_SHEET,
          items: itemsList,
          popupTitle: ConstantWidget.getTextWidget(
            label,
            ConstantData.mainTextColor,
            TextAlign.center,
            FontWeight.w500,
            font18Px(context: context),
          ),
          // hint: "Select Country",
          onChanged: (value) {
            func(value!);
          },
          selectedItem: label,
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.inputType,
    // required this.hintText,
    required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  // final String hintText;
  final TextInputType inputType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      keyboardType: inputType,
      controller: controller,
      style: TextStyle(
          fontFamily: ConstantData.fontFamily,
          color: ConstantData.mainTextColor,
          fontWeight: FontWeight.w400,
          fontSize: font18Px(context: context)),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: BorderSide(color: ConstantData.textColor, width: 0.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantData.textColor, width: 0.0),
        ),
        labelStyle: TextStyle(
            fontFamily: ConstantData.fontFamily, color: ConstantData.textColor),
        labelText: label,
        // hintText: hintText,
      ),
    );
  }
}
