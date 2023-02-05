import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/products/utils/quantity_dialog.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class PlusMinusWidget extends StatefulWidget {
  /// Button to increment or decrement the quantity of [ProductModel] as per cart
  const PlusMinusWidget({
    Key? key,
    required this.model,
    required this.store,
    this.iconSize,
    this.fontSize,
    this.detailScreen,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double? iconSize;
  final double? fontSize;
  final bool? detailScreen;

  @override
  State<PlusMinusWidget> createState() => _PlusMinusWidgetState();
}

class _PlusMinusWidgetState extends State<PlusMinusWidget> {
  ProductModel updateCurrProduct({
    required String category,
    required ProductsStore store,
  }) {
    switch (category) {
      case 'Ethical':
        final index = store.ethicalProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1) ? store.ethicalProductList[index] : widget.model;

      case 'Generic':
        final index = store.genericProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1) ? store.genericProductList[index] : widget.model;

      case 'Surgical':
        final index = store.surgicalProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1) ? store.surgicalProductList[index] : widget.model;

      case 'Veterinary':
        final index = store.veterinaryProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1)
            ? store.veterinaryProductList[index]
            : widget.model;

      case 'Ayurvedic':
        final index = store.ayurvedicProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1) ? store.ayurvedicProductList[index] : widget.model;

      case 'General':
        final index = store.generalProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        return (index != -1) ? store.generalProductList[index] : widget.model;

      default:
        return widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (widget.iconSize != null)
          ? MainAxisAlignment.center
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Observer(builder: (_) {
          ProductModel currModel = widget.model;
          if (widget.model.subTotal != '0.00') {
            currModel = updateCurrProduct(
                category: widget.model.category, store: widget.store);
          }
          return InkWell(
            onTap: () async {
              // print(-1);
              // if (widget.model.cartQuantity > widget.model.minQty) {
              // widget.store.minusRemoveState = StoreState.LOADING;
              setState(() {
                widget.model.cartQuantity -= widget.model.minQty;
              });
              await widget.store.minusToCart(
                model: widget.model,
                context: context,
              );
              // widget.store.minusRemoveState = StoreState.SUCCESS;
              // }
            },
            child: PlusMinusButton(
              icon: CupertinoIcons.minus,
              iconSize: widget.iconSize,
            ),
          );
        }),
        Observer(builder: (_) {
          ProductModel currModel = widget.model;
          if (widget.model.subTotal != '0.00') {
            currModel = updateCurrProduct(
                category: widget.model.category, store: widget.store);
          }
          // print('------- checking --------${currModel.cartQuantity}');
          return InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => QuantityDialog(
                  model: widget.model,
                  store: widget.store,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 3,
                vertical: (widget.iconSize != null)
                    ? blockSizeVertical(context: context)
                    : 0,
              ),
              child: ConstantWidget.getCustomText(
                '${(widget.model.cartQuantity.toString().length > 4) ? '${widget.model.cartQuantity.toString().substring(0, 3)}...' : widget.model.cartQuantity}',
                ConstantData.mainTextColor,
                2,
                TextAlign.center,
                FontWeight.w600,
                widget.fontSize ?? font15Px(context: context),
              ),
            ),
          );
        }),
        Observer(builder: (_) {
          ProductModel currModel = widget.model;
          if (widget.model.subTotal != '0.00') {
            currModel = updateCurrProduct(
                category: widget.model.category, store: widget.store);
          }
          return InkWell(
            onTap: () async {
              setState(() {
                widget.model.cartQuantity += widget.model.minQty;
              });
              if (widget.model.cartQuantity >
                  int.parse(widget.model.quantity)) {
                Fluttertoast.showToast(msg: 'Quantity Not Available');
                setState(() {
                  widget.model.cartQuantity -= widget.model.minQty;
                });
              } else {
                await widget.store.plusToCart(
                  model: widget.model,
                  context: context,
                );
              }
            },
            child: PlusMinusButton(
              icon: CupertinoIcons.plus,
              iconSize: widget.iconSize,
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
        size: iconSize ?? blockSizeVertical(context: context) * 2,
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
    this.isDetailScreen,
    this.detailScreenFunc,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double width;
  final double height;
  final double fontSize;
  final BuildContext contextReq;
  final bool? isDetailScreen;
  final Function? detailScreenFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await store.addToCart(
          model: model,
          context: context,
        );
        if (detailScreenFunc != null) {
          detailScreenFunc;
        }
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
          (isDetailScreen != null) ? 'Add to cart' : 'Add',
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
        // store.removeState = StoreState.LOADING;
        await store.removeFromCart(
          model: model,
          context: context,
        );
        // store.removeState = StoreState.SUCCESS;
      },
      child: (isDetailPage == null)
          ? Container(
              decoration: BoxDecoration(
                color: ConstantData.color1,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(
                blockSizeHorizontal(context: context) * 1.8,
              ),
              child: Icon(
                CupertinoIcons.delete,
                size: font22Px(context: context) * 1.12,
                color: ConstantData.bgColor,
              ),
            )
          : Container(
              padding: EdgeInsets.all(
                blockSizeHorizontal(context: context) * 3,
              ),
              decoration: BoxDecoration(
                color: ConstantData.color1,
                borderRadius: BorderRadius.circular(
                  font22Px(context: context),
                ),
              ),
              child: Icon(
                CupertinoIcons.delete,
                color: ConstantData.bgColor,
                size: font25Px(context: context) * 1.18,
              ),
            ),
    );
  }
}
