import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/quantity_dialog.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class PlusMinusWidget extends StatelessWidget {
  /// Button to increment or decrement the quantity of [ProductModel] as per cart
  const PlusMinusWidget({
    Key? key,
    required this.model,
    required this.store,
    this.iconSize,
    this.fontSize,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double? iconSize;
  final double? fontSize;

  ProductModel updateCurrProduct({
    required String category,
    required ProductsStore store,
  }) {
    switch (category) {
      case 'Ethical':
        final index = store.ethicalProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.ethicalProductList[index];

      case 'Generic':
        final index = store.genericProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.genericProductList[index];

      case 'Surgical':
        final index = store.surgicalProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.surgicalProductList[index];

      case 'Veterinary':
        final index = store.veterinaryProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.veterinaryProductList[index];

      case 'Ayurvedic':
        final index = store.ayurvedicProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.ayurvedicProductList[index];

      case 'General':
        final index = store.generalProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.generalProductList[index];

      default:
        final index = store.generalProductList
            .indexWhere((element) => element.pid == model.pid);
        return store.generalProductList[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () async {
            if (model.cartQuantity! > 0) {
              await store.minusToCart(
                model: model,
                context: context,
              );
            }
          },
          child: PlusMinusButton(
            icon: CupertinoIcons.minus,
            iconSize: iconSize,
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => QuantityDialog(
                      model: model,
                      store: store,
                    ));
          },
          child: Observer(builder: (_) {
            final category = model.category;
            final currModel =
                updateCurrProduct(category: category, store: store);
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 3),
              child: ConstantWidget.getCustomText(
                '${(currModel.cartQuantity!.toString().length > 4) ? '${currModel.cartQuantity!.toString().substring(0, 3)}...' : currModel.cartQuantity!}',
                ConstantData.mainTextColor,
                2,
                TextAlign.center,
                FontWeight.w500,
                fontSize ?? font15Px(context: context),
              ),
            );
          }),
        ),
        InkWell(
          onTap: () async {
            await store.plusToCart(
              model: model,
              context: context,
            );
          },
          child: PlusMinusButton(
            icon: CupertinoIcons.plus,
            iconSize: iconSize,
          ),
        ),
      ],
    );
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    Key? key,
    required this.icon,
    this.iconSize,
  }) : super(key: key);

  final IconData icon;
  final double? iconSize;
  // final Function function;

  @override
  Widget build(BuildContext context) {
    // double height = iconSize;

    return Container(
      // height: height,
      // // margin: EdgeInsets.symmetric(horizontal: ConstantWidget.getPercentSize(height, 30)),
      // width: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 1.5)),
      child: Icon(
        icon,
        size: iconSize ?? blockSizeVertical(context: context) * 1.5,
        color: Colors.grey,
      ),
    );
  }
}

class AddProductButton extends StatelessWidget {
  /// Button to add a [ProductModel] to cart
  const AddProductButton({
    Key? key,
    required this.store,
    required this.model,
    required this.width,
    required this.height,
    required this.fontSize,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final index = store.cartModel.productList
            .indexWhere((element) => element.pid == model.pid);
        SnackBar snackBar;
        if (index == -1) {
          await store.addToCart(model: model);
          snackBar = ConstantWidget.customSnackBar(
              text: 'Added To Cart', context: context);
        } else {
          snackBar = ConstantWidget.customSnackBar(
              text: 'Item Already in Cart', context: context);
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: width,
          horizontal: height,
        ),
        decoration: BoxDecoration(
          color: ConstantData.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstantWidget.getCustomText('Add', ConstantData.bgColor, 1,
            TextAlign.center, FontWeight.w500, fontSize),
      ),
    );
  }
}

class RemoveButton extends StatelessWidget {
  const RemoveButton({
    Key? key,
    required this.store,
    required this.model,
    required this.width,
    required this.height,
    required this.fontSize,
    this.isDetailPage,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double width;
  final double height;
  final double fontSize;
  final bool? isDetailPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await store.removeFromCart(model: model);
      },
      // child: Container(
      //   padding: EdgeInsets.symmetric(
      //     vertical: width,
      //     horizontal: height,
      //   ),
      //   decoration: BoxDecoration(
      //     color: ConstantData.primaryColor,
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   // child: ConstantWidget.getCustomText('Remove', ConstantData.bgColor, 1,
      //   //     TextAlign.center, FontWeight.w500, fontSize),
      //   child: Icon(
      //     Icons.delete_rounded,
      //     size: font22Px(context: context),
      //     color: ConstantData.clrBlack20,
      //   ),
      // ),
      child: Padding(
        padding: EdgeInsets.only(
          left: blockSizeHorizontal(context: context) * 2,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ConstantData.primaryColor,
            shape:
                (isDetailPage ?? false) ? BoxShape.rectangle : BoxShape.circle,
            borderRadius:
                (isDetailPage ?? false) ? BorderRadius.circular(12) : null,
          ),
          padding: (isDetailPage ?? false)
              ? EdgeInsets.symmetric(
                  horizontal: blockSizeHorizontal(context: context) * 8,
                  vertical: blockSizeVertical(context: context),
                )
              : EdgeInsets.all(
                  blockSizeHorizontal(context: context) * 1.8,
                ),
          child: (isDetailPage ?? false)
              ? ConstantWidget.getCustomText(
                  'Delete',
                  ConstantData.bgColor,
                  1,
                  TextAlign.center,
                  FontWeight.w500,
                  font18Px(context: context),
                )
              : Icon(
                  Icons.delete_rounded,
                  size: font22Px(context: context),
                  color: ConstantData.bgColor,
                ),
        ),
      ),
    );
  }
}
