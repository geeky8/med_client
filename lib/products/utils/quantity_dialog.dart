// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/store/products_store.dart';
import 'package:medrpha_customer/utils/constant_data.dart';
import 'package:medrpha_customer/utils/constant_widget.dart';
import 'package:medrpha_customer/utils/size_config.dart';

class QuantityDialog extends StatelessWidget {
  QuantityDialog({
    Key? key,
    required this.model,
    required this.store,
  }) : super(key: key);

  final ProductModel model;
  final ProductsStore store;
  final quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    quantityController.value = TextEditingValue(
        text: model.cartQuantity.toString(),
        selection: TextSelection.collapsed(
            offset: model.cartQuantity.toString().length));

    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Container(
        height: ConstantWidget.getScreenPercentSize(context, 23),
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
                vertical: blockSizeVertical(context: context) * 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ConstantWidget.getCustomText(
                        'Enter Quantity',
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        font18Px(context: context),
                      ),
                      const Spacer(),
                      Expanded(
                        child: ConstantWidget.getCustomText(
                          'Avl qty: ${model.quantity}',
                          ConstantData.mainTextColor,
                          1,
                          TextAlign.center,
                          FontWeight.bold,
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
                                  await store.updateCartQunatity(
                                    model: model,
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
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
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
                        'Cancel',
                        ConstantData.primaryColor,
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
                  child: InkWell(
                    onTap: () async {
                      if (quantityController.text.trim() != '') {
                        await store.updateCartQunatity(
                          model: model,
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
                        ConstantData.mainTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        font15Px(context: context) * 1.2,
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
