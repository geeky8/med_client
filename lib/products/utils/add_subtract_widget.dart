import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrpha_customer/enums/categories.dart';
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
  Future<ProductModel> updateCurrProduct(ProductModel model) async {
    final stopWatch = Stopwatch()..start();
    switch (categoriesfromValue(model.category)) {
      case CategoriesType.ETHICAL:
        widget.store.ethicalProducts[model.pid] = model;
        break;
      case CategoriesType.GENERIC:
        final index = widget.store.genericProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.genericProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1) ? widget.store.genericProductList[index] : model;
      case CategoriesType.SURGICAL:
        final index = widget.store.surgicalProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.surgicalProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1) ? widget.store.surgicalProductList[index] : model;
      case CategoriesType.VETERINARY:
        final index = widget.store.veterinaryProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.veterinaryProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1)
            ? widget.store.veterinaryProductList[index]
            : model;
      case CategoriesType.AYURVEDIC:
        final index = widget.store.ayurvedicProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.ayurvedicProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1) ? widget.store.ayurvedicProductList[index] : model;
      case CategoriesType.GENERAL:
        final index = widget.store.generalProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.generalProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1) ? widget.store.generalProductList[index] : model;
      case CategoriesType.VACCINE:
        final index = widget.store.vaccineProductList
            .indexWhere((element) => element.pid == widget.model.pid);
        widget.store.vaccineProductList
          ..removeAt(index)
          ..insert(index, model);
        return (index != -1) ? widget.store.vaccineProductList[index] : model;
    }
    stopWatch.stop();
    debugPrint(
        '---- elaspsed time while adding ${stopWatch.elapsedMicroseconds}');
    return model;
  }

  late ProductModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (widget.iconSize != null)
          ? MainAxisAlignment.center
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              widget.model.cartQuantity -= widget.model.minQty;
            });
            await widget.store.minusToCart(
              model: widget.model,
              context: context,
            );
          },
          child: PlusMinusButton(
            icon: CupertinoIcons.minus,
            iconSize: widget.iconSize,
          ),
        ),
        Observer(builder: (_) {
          // final updatedModel = updateCurrProduct(model);
          return InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => QuantityDialog(
                  model: model,
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
                '${(model.cartQuantity.toString().length > 4) ? '${model.cartQuantity.toString().substring(0, 3)}...' : model.cartQuantity}',
                ConstantData.mainTextColor,
                2,
                TextAlign.center,
                FontWeight.w600,
                widget.fontSize ?? font15Px(context: context),
              ),
            ),
          );
        }),
        InkWell(
          onTap: () async {
            setState(() {
              model.cartQuantity += model.minQty;
              final subTotal = model.cartQuantity * double.parse(model.newMrp);
              model = model.copyWith(subTotal: subTotal.toStringAsFixed(2));
            });
            if (model.cartQuantity > int.parse(model.quantity)) {
              Fluttertoast.showToast(msg: 'Quantity Not Available');
              setState(() {
                model.cartQuantity -= model.minQty;
              });
            } else {
              await widget.store.plusToCart(
                model: model,
                context: context,
              );
            }
          },
          child: PlusMinusButton(
            icon: CupertinoIcons.plus,
            iconSize: widget.iconSize,
          ),
        )
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
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final double width;
  final double height;
  final double fontSize;
  final BuildContext contextReq;
  final bool? isDetailScreen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final updatedModel = await store.addToCart(
          model: model,
          context: context,
        );
        showDialog(
          context: context,
          builder: (_) => QuantityDialog(
            model: updatedModel,
            store: store,
          ),
        );
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
                  color: ConstantData.color1, shape: BoxShape.circle),
              child: Icon(
                CupertinoIcons.delete,
                color: ConstantData.bgColor,
                size: font25Px(context: context) * 1.18,
              ),
            ),
    );
  }
}
