// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class QuantityDialog extends StatefulWidget {
  QuantityDialog({
    Key? key,
    required this.model,
    required this.store,
    this.givenQty,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final String? givenQty;

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  final quantityController = TextEditingController();

  @override
  void initState() {
    quantityController.value = TextEditingValue(
      text: widget.model.cartQuantity.toString(),
      selection: TextSelection.collapsed(
          offset: widget.model.cartQuantity.toString().length),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Container(
        height: ConstantWidget.getScreenPercentSize(context, 25),
        decoration: BoxDecoration(
          color: ConstantData.bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: blockSizeHorizontal(context: context) * 3,
                vertical: blockSizeVertical(context: context) * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ConstantWidget.getCustomText(
                          'Enter Quantity',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font18Px(context: context),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: ConstantWidget.getCustomText(
                          'Avl qty : ${widget.model.quantity}',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font15Px(context: context) * 1.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: blockSizeVertical(context: context) * 2,
                  ),
                  Observer(builder: (_) {
                    return Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: blockSizeVertical(context: context) * 15,
                            height: blockSizeVertical(context: context) * 5,
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z]")),
                              ],
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              // cursorHeight:
                              //     blockSizeHorizontal(context: context),
                              cursorColor: Colors.black45,
                              style: TextStyle(
                                fontFamily: ConstantData.fontFamily,
                                color: ConstantData.mainTextColor,
                                fontSize: font18Px(context: context),
                                fontWeight: FontWeight.w500,
                              ),

                              onFieldSubmitted: (value) async {
                                if (value != '') {
                                  await widget.store.updateCartQunatity(
                                    model: widget.model,
                                    value: value.split('.')[0],
                                    context: context,
                                  );
                                  // Navigator.pop(context);
                                }
                              },
                              onChanged: (value) {},
                              // initialValue: '${model.cartQuantity}',
                              decoration: InputDecoration(
                                labelText: 'Qunatity',
                                labelStyle: TextStyle(
                                  fontSize: font18Px(context: context),
                                  color: ConstantData.textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: ConstantData.mainTextColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: blockSizeVertical(context: context),
                  ),
                  Row(
                    children: [
                      ConstantWidget.getCustomText(
                        "Order in multiples of ",
                        ConstantData.clrBorder,
                        1,
                        TextAlign.right,
                        FontWeight.w500,
                        font15Px(context: context) * 1.1,
                      ),
                      ConstantWidget.getCustomText(
                        " X ${widget.model.minQty}",
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.right,
                        FontWeight.w600,
                        font15Px(context: context) * 1.1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await widget.store.removeFromCart(model: widget.model);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        // horizontal: blockSizeHorizontal(context: context) * 5,
                        vertical: blockSizeVertical(context: context) * 2.5,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: ConstantData.viewColor,
                            width: 3,
                          ),
                          right: BorderSide(
                            color: ConstantData.viewColor,
                            width: 3,
                          ),
                        ),
                      ),
                      child: ConstantWidget.getCustomText(
                        'Remove',
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        font15Px(context: context) * 1.2,
                      ),
                    ),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  flex: 4,
                  child: Observer(
                    builder: (_) => InkWell(
                      onTap: () async {
                        if (quantityController.text.trim() != '' &&
                            widget.store.cartAddState == StoreState.SUCCESS) {
                          await widget.store.updateCartQunatity(
                            model: widget.model,
                            value: quantityController.text.trim().split('.')[0],
                            context: context,
                          );
                          // Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          // horizontal: blockSizeHorizontal(context: context) * 2,
                          vertical: blockSizeVertical(context: context) * 2.5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: ConstantData.viewColor,
                              width: 3,
                            ),
                            right: BorderSide(
                              color: ConstantData.viewColor,
                              width: 3,
                            ),
                          ),
                        ),
                        child: ConstantWidget.getCustomText(
                          'Confirm',
                          ConstantData.primaryColor,
                          1,
                          TextAlign.center,
                          FontWeight.w600,
                          font15Px(context: context) * 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
