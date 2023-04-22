import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/categories.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/signup_login/store/login_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

import '../../api_service.dart';

class CategoryList extends StatelessWidget {
  /// List of all categories based on [CategoryModel]
  const CategoryList({
    Key? key,
    required this.list,
    required this.sideMargin,
    required this.store,
    required this.loginStore,
  }) : super(key: key);

  final List<CategoryModel> list;
  final double sideMargin;
  final ProductsStore store;
  final LoginStore loginStore;

  Color getShadow({required String categoryName}) {
    final categoryType = categoriesfromValue(categoryName);
    switch (categoryType) {
      case CategoriesType.ETHICAL:
        if (store.ethicalProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.GENERIC:
        if (store.genericProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.SURGICAL:
        if (store.surgicalProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.VETERINARY:
        if (store.veterinaryProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.AYURVEDIC:
        if (store.ayurvedicProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.GENERAL:
        if (store.generalProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
      case CategoriesType.VACCINE:
        if (store.vaccineProductList.isEmpty) {
          return ConstantData.cartColor.withOpacity(0.6);
        }
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: safeBlockHorizontal(context: context) * 20,
      child: ListView.builder(
        padding: EdgeInsets.only(right: sideMargin),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          double height = safeBlockHorizontal(context: context) * 20;
          double imageSize = ConstantWidget.getPercentSize(height, 65);
          double remainSize = height - imageSize;

          return InkWell(
            onTap: () {
              store.categoriesType =
                  categoriesfromValue(list[index].categoryName);
            },
            child: SizedBox(
              width: height,
              child: Container(
                margin: EdgeInsets.only(left: sideMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Observer(
                      builder: (_) {
                        return Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                  ConstantWidget.getPercentSize(imageSize, 25)),
                              height: imageSize,
                              width: imageSize,
                              decoration: BoxDecoration(
                                // color: ConstantData.color1,

                                border: (store.categoriesType ==
                                        categoriesfromValue(
                                            list[index].categoryName))
                                    ? Border.all(
                                        color: ConstantData.primaryColor,
                                        width: 4,
                                      )
                                    : Border.all(
                                        color: ConstantData.mainTextColor,
                                        width: 1.5),
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    catImgUrl + list[index].categoryImgUrl,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  ConstantWidget.getPercentSize(imageSize, 25)),
                              height: imageSize,
                              width: imageSize,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getShadow(
                                    categoryName: list[index].categoryName,
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: ConstantWidget.getPercentSize(remainSize, 20),
                        ),
                        child: ConstantWidget.getCustomText(
                            list[index].categoryName,
                            ConstantData.mainTextColor,
                            1,
                            TextAlign.start,
                            FontWeight.w400,
                            font15Px(context: context)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
