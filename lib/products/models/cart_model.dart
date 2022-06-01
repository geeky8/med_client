import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:mobx/mobx.dart';

class CartModel {
  CartModel({
    required this.totalSalePrice,
    required this.noOfProducts,
    required this.productList,
  });

  CartModel copyWith({
    double? totalSalePrice,
    int? noOfProducts,
    ObservableList<ProductModel>? productList,
  }) {
    return CartModel(
      totalSalePrice: totalSalePrice ?? this.totalSalePrice,
      noOfProducts: noOfProducts ?? this.noOfProducts,
      productList: productList ?? this.productList,
    );
  }

  final double totalSalePrice;
  final int noOfProducts;
  final ObservableList<ProductModel> productList;
}
