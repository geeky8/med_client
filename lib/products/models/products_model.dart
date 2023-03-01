import 'package:flutter/foundation.dart';

class ProductModel {
  ProductModel({
    required this.pid,
    required this.wpid,
    required this.priceId,
    required this.salePrice,
    required this.productImg,
    required this.productName,
    required this.category,
    required this.company,
    required this.newMrp,
    required this.oldMrp,
    required this.percentDiscount,
    required this.saleQtyType,
    required this.prodSaleTypeDetails,
    required this.quantity,
    required this.cartQuantity,
    required this.mrp,
    required this.subTotal,
    required this.expiryDate,
    required this.description,
    required this.totalQtyPrice,
    required this.minQty,
    this.warehouseId,
  });

  factory ProductModel.fromJson(
      {required Map<String, dynamic> json, bool? isCart}) {
    int getMinimumQuantity(var value) {
      if (value != null && value != "") {
        return int.parse(value);
      } else {
        return 1;
      }
    }

    return ProductModel(
      pid: int.parse((json['pid'] ?? '-1') as String),
      wpid: (json['wpid'] ?? '') as String,
      priceId: (json['priceID'] ?? '') as String,
      salePrice: (json['saleprice'] ?? '') as String,
      productImg: (json['product_img'] ?? '') as String,
      productName: (json['product_name'] != null)
          ? (((json['product_name']) as String) != '')
              ? (((json['product_name']) as String)[0] +
                  (json['product_name'] as String).substring(1).toLowerCase())
              : ''
          : '',
      category: (json['categorystr'] ?? '') as String,
      company: (json['compnaystr'] ?? '') as String,
      newMrp:
          double.parse((json['newmrp'] ?? '0.0') as String).toStringAsFixed(2),
      oldMrp:
          double.parse((json['oldmrp'] ?? '0.0') as String).toStringAsFixed(2),
      percentDiscount: (json['percent'] ?? '') as String,
      saleQtyType: (json['saleqtytypestr'] ?? '') as String,
      prodSaleTypeDetails: (json['prodsaletypedetails'] ?? '') as String,
      quantity: ((json['quantity'] ?? '') as String),
      cartQuantity: int.parse(
          (json['cartquantity'] == '' || json['cartquantity'] == null)
              ? '0'
              : json['cartquantity']),
      mrp: (json['mrp'] ?? '') as String,
      subTotal: (json['subtotal'] ?? '') as String,
      expiryDate: '',
      description: '',
      totalQtyPrice: (json['totalqtymrp'] ?? '') as String,
      minQty: getMinimumQuantity(json['minqty']),
      warehouseId: (json['warehouse_id'] ?? '') as String,
    );
  }

  ProductModel copyWith({
    int? cartQuantity,
    String? expiryDate,
    String? productName,
    String? productImg,
    String? saleQtyType,
    String? company,
    String? prodSaleTypeDetails,
    String? category,
    String? description,
    String? subTotal,
    int? minQty,
    String? totalQtyPrice,
  }) {
    return ProductModel(
      pid: pid,
      wpid: wpid,
      priceId: priceId,
      salePrice: salePrice,
      productImg: productImg ?? this.productImg,
      productName: (productName ?? this.productName)[0] +
          (productName ?? this.productName).substring(1).toLowerCase(),
      category: category ?? this.category,
      company: company ?? this.company,
      newMrp: newMrp,
      oldMrp: oldMrp,
      percentDiscount: percentDiscount,
      saleQtyType: saleQtyType ?? this.saleQtyType,
      prodSaleTypeDetails: prodSaleTypeDetails ?? this.prodSaleTypeDetails,
      quantity: quantity,
      cartQuantity: cartQuantity ?? this.cartQuantity,
      mrp: mrp,
      subTotal: subTotal ?? this.subTotal,
      expiryDate: expiryDate ?? this.expiryDate,
      description: description ?? this.description,
      totalQtyPrice: totalQtyPrice ?? this.totalQtyPrice,
      minQty: minQty ?? this.minQty,
    );
  }

  final int pid;
  final String wpid;
  final String priceId;
  final String salePrice;
  final String productImg;
  final String productName;
  final String category;
  final String company;
  final String newMrp;
  final String oldMrp;
  final String percentDiscount;
  final String saleQtyType;
  final String prodSaleTypeDetails;
  final String quantity;
  int cartQuantity;
  final String mrp;
  String subTotal;
  final String expiryDate;
  final String description;
  final String totalQtyPrice;
  final int minQty;
  final String? warehouseId;
}
