import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/store_state.dart';
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
        return (index != -1) ? store.ethicalProductList[index] : model;

      case 'Generic':
        final index = store.genericProductList
            .indexWhere((element) => element.pid == model.pid);
        return (index != -1) ? store.genericProductList[index] : model;

      case 'Surgical':
        final index = store.surgicalProductList
            .indexWhere((element) => element.pid == model.pid);
        return (index != -1) ? store.surgicalProductList[index] : model;

      case 'Veterinary':
        final index = store.veterinaryProductList
            .indexWhere((element) => element.pid == model.pid);
        return (index != -1) ? store.veterinaryProductList[index] : model;

      case 'Ayurvedic':
        final index = store.ayurvedicProductList
            .indexWhere((element) => element.pid == model.pid);
        return (index != -1) ? store.ayurvedicProductList[index] : model;

      case 'General':
        final index = store.generalProductList
            .indexWhere((element) => element.pid == model.pid);
        return (index != -1) ? store.generalProductList[index] : model;

      default:
        final index = store.generalProductList
            .indexWhere((element) => element.pid == model.pid);
        return model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          (iconSize != null) ? MainAxisAlignment.center : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Observer(builder: (_) {
          ProductModel currModel = model;
          if (model.subTotal != '0.00') {
            currModel =
                updateCurrProduct(category: model.category, store: store);
          }
          return InkWell(
            onTap: () async {
              if (model.cartQuantity! > 0) {
                store.minusRemoveState = StoreState.LOADING;
                await store.minusToCart(
                  model: currModel,
                  context: context,
                );
                store.minusRemoveState = StoreState.SUCCESS;
              }
            },
            child: PlusMinusButton(
              icon: CupertinoIcons.minus,
              iconSize: iconSize,
            ),
          );
        }),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => QuantityDialog(
                model: model,
                store: store,
              ),
            );
          },
          child: Observer(builder: (_) {
            ProductModel? currModel = model;
            if (model.subTotal != '0.00') {
              currModel =
                  updateCurrProduct(category: model.category, store: store);
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 3,
                vertical: (iconSize != null)
                    ? blockSizeVertical(context: context)
                    : 0,
              ),
              child: ConstantWidget.getCustomText(
                '${(currModel!.cartQuantity!.toString().length > 4) ? '${currModel.cartQuantity!.toString().substring(0, 3)}...' : currModel.cartQuantity!}',
                ConstantData.mainTextColor,
                2,
                TextAlign.center,
                FontWeight.w600,
                fontSize ?? font15Px(context: context),
              ),
            );
          }),
        ),
        Observer(builder: (_) {
          ProductModel? currModel = model;
          if (model.subTotal != '0.00') {
            currModel =
                updateCurrProduct(category: model.category, store: store);
          }
          return InkWell(
            onTap: () async {
              store.plusState = StoreState.LOADING;
              await store.plusToCart(
                model: currModel ?? model,
                context: context,
              );
              store.plusState = StoreState.SUCCESS;
            },
            child: PlusMinusButton(
              icon: CupertinoIcons.plus,
              iconSize: iconSize,
            ),
          );
        }),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: (iconSize != null)
          ? EdgeInsets.all(
              blockSizeHorizontal(context: context) * 2,
            )
          : null,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
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
    required this.contextReq,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double width;
  final double height;
  final double fontSize;
  final BuildContext contextReq;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final index = store.cartModel.productList
            .indexWhere((element) => element.pid == model.pid);
        SnackBar snackBar;
        if (index == -1) {
          await store.addToCart(model: model, context: contextReq);
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
          vertical: height,
          horizontal: width,
        ),
        decoration: BoxDecoration(
          color: ConstantData.primaryColor,
          borderRadius: BorderRadius.circular(
            font25Px(context: context) * 1.1,
          ),
        ),
        child: ConstantWidget.getCustomText(
          'Add',
          ConstantData.bgColor,
          1,
          TextAlign.center,
          FontWeight.w600,
          fontSize,
        ),
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
        store.removeState = StoreState.LOADING;
        await store.removeFromCart(
          model: model,
          context: context,
        );
        store.removeState = StoreState.SUCCESS;
      },
      child: Container(
        decoration: BoxDecoration(
          color: ConstantData.primaryColor,
          shape: (isDetailPage ?? false) ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: (isDetailPage ?? false)
              ? BorderRadius.circular(font25Px(context: context) * 1.1)
              : null,
        ),
        padding: (isDetailPage ?? false)
            ? EdgeInsets.symmetric(
                // horizontal: blockSizeHorizontal(context: context) * 8,
                vertical: blockSizeVertical(context: context) * 2.5,
              )
            : EdgeInsets.all(
                blockSizeHorizontal(context: context) * 1.8,
              ),
        child: (isDetailPage ?? false)
            ? ConstantWidget.getCustomText(
                'Remove',
                ConstantData.bgColor,
                1,
                TextAlign.center,
                FontWeight.w600,
                font18Px(context: context),
              )
            : Icon(
                Icons.delete_rounded,
                size: font22Px(context: context),
                color: ConstantData.bgColor,
              ),
      ),
    );
  }
}
