// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductsStore on _ProductsStore, Store {
  late final _$catStateAtom =
      Atom(name: '_ProductsStore.catState', context: context);

  @override
  StoreState get catState {
    _$catStateAtom.reportRead();
    return super.catState;
  }

  @override
  set catState(StoreState value) {
    _$catStateAtom.reportWrite(value, super.catState, () {
      super.catState = value;
    });
  }

  late final _$categoriesAtom =
      Atom(name: '_ProductsStore.categories', context: context);

  @override
  List<CategoryModel> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(List<CategoryModel> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$prodStateAtom =
      Atom(name: '_ProductsStore.prodState', context: context);

  @override
  StoreState get prodState {
    _$prodStateAtom.reportRead();
    return super.prodState;
  }

  @override
  set prodState(StoreState value) {
    _$prodStateAtom.reportWrite(value, super.prodState, () {
      super.prodState = value;
    });
  }

  late final _$ethicalProductListAtom =
      Atom(name: '_ProductsStore.ethicalProductList', context: context);

  @override
  ObservableList<ProductModel> get ethicalProductList {
    _$ethicalProductListAtom.reportRead();
    return super.ethicalProductList;
  }

  @override
  set ethicalProductList(ObservableList<ProductModel> value) {
    _$ethicalProductListAtom.reportWrite(value, super.ethicalProductList, () {
      super.ethicalProductList = value;
    });
  }

  late final _$genericProductListAtom =
      Atom(name: '_ProductsStore.genericProductList', context: context);

  @override
  ObservableList<ProductModel> get genericProductList {
    _$genericProductListAtom.reportRead();
    return super.genericProductList;
  }

  @override
  set genericProductList(ObservableList<ProductModel> value) {
    _$genericProductListAtom.reportWrite(value, super.genericProductList, () {
      super.genericProductList = value;
    });
  }

  late final _$surgicalProductListAtom =
      Atom(name: '_ProductsStore.surgicalProductList', context: context);

  @override
  ObservableList<ProductModel> get surgicalProductList {
    _$surgicalProductListAtom.reportRead();
    return super.surgicalProductList;
  }

  @override
  set surgicalProductList(ObservableList<ProductModel> value) {
    _$surgicalProductListAtom.reportWrite(value, super.surgicalProductList, () {
      super.surgicalProductList = value;
    });
  }

  late final _$veterinaryProductListAtom =
      Atom(name: '_ProductsStore.veterinaryProductList', context: context);

  @override
  ObservableList<ProductModel> get veterinaryProductList {
    _$veterinaryProductListAtom.reportRead();
    return super.veterinaryProductList;
  }

  @override
  set veterinaryProductList(ObservableList<ProductModel> value) {
    _$veterinaryProductListAtom.reportWrite(value, super.veterinaryProductList,
        () {
      super.veterinaryProductList = value;
    });
  }

  late final _$ayurvedicProductListAtom =
      Atom(name: '_ProductsStore.ayurvedicProductList', context: context);

  @override
  ObservableList<ProductModel> get ayurvedicProductList {
    _$ayurvedicProductListAtom.reportRead();
    return super.ayurvedicProductList;
  }

  @override
  set ayurvedicProductList(ObservableList<ProductModel> value) {
    _$ayurvedicProductListAtom.reportWrite(value, super.ayurvedicProductList,
        () {
      super.ayurvedicProductList = value;
    });
  }

  late final _$generalProductListAtom =
      Atom(name: '_ProductsStore.generalProductList', context: context);

  @override
  ObservableList<ProductModel> get generalProductList {
    _$generalProductListAtom.reportRead();
    return super.generalProductList;
  }

  @override
  set generalProductList(ObservableList<ProductModel> value) {
    _$generalProductListAtom.reportWrite(value, super.generalProductList, () {
      super.generalProductList = value;
    });
  }

  late final _$allProductsAtom =
      Atom(name: '_ProductsStore.allProducts', context: context);

  @override
  ObservableList<ProductModel> get allProducts {
    _$allProductsAtom.reportRead();
    return super.allProducts;
  }

  @override
  set allProducts(ObservableList<ProductModel> value) {
    _$allProductsAtom.reportWrite(value, super.allProducts, () {
      super.allProducts = value;
    });
  }

  late final _$cartItemsListAtom =
      Atom(name: '_ProductsStore.cartItemsList', context: context);

  @override
  ObservableList<ProductModel> get cartItemsList {
    _$cartItemsListAtom.reportRead();
    return super.cartItemsList;
  }

  @override
  set cartItemsList(ObservableList<ProductModel> value) {
    _$cartItemsListAtom.reportWrite(value, super.cartItemsList, () {
      super.cartItemsList = value;
    });
  }

  late final _$cartModelAtom =
      Atom(name: '_ProductsStore.cartModel', context: context);

  @override
  CartModel get cartModel {
    _$cartModelAtom.reportRead();
    return super.cartModel;
  }

  @override
  set cartModel(CartModel value) {
    _$cartModelAtom.reportWrite(value, super.cartModel, () {
      super.cartModel = value;
    });
  }

  late final _$getCategoriesAsyncAction =
      AsyncAction('_ProductsStore.getCategories', context: context);

  @override
  Future<void> getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  late final _$getEthicalProductsAsyncAction =
      AsyncAction('_ProductsStore.getEthicalProducts', context: context);

  @override
  Future<void> getEthicalProducts() {
    return _$getEthicalProductsAsyncAction
        .run(() => super.getEthicalProducts());
  }

  late final _$getGenericProductsAsyncAction =
      AsyncAction('_ProductsStore.getGenericProducts', context: context);

  @override
  Future<void> getGenericProducts() {
    return _$getGenericProductsAsyncAction
        .run(() => super.getGenericProducts());
  }

  late final _$getSurgicalProductsAsyncAction =
      AsyncAction('_ProductsStore.getSurgicalProducts', context: context);

  @override
  Future<void> getSurgicalProducts() {
    return _$getSurgicalProductsAsyncAction
        .run(() => super.getSurgicalProducts());
  }

  late final _$getVeterinaryProductsAsyncAction =
      AsyncAction('_ProductsStore.getVeterinaryProducts', context: context);

  @override
  Future<void> getVeterinaryProducts() {
    return _$getVeterinaryProductsAsyncAction
        .run(() => super.getVeterinaryProducts());
  }

  late final _$getAyurvedicProductsAsyncAction =
      AsyncAction('_ProductsStore.getAyurvedicProducts', context: context);

  @override
  Future<void> getAyurvedicProducts() {
    return _$getAyurvedicProductsAsyncAction
        .run(() => super.getAyurvedicProducts());
  }

  late final _$getGenerallProductsAsyncAction =
      AsyncAction('_ProductsStore.getGenerallProducts', context: context);

  @override
  Future<void> getGenerallProducts() {
    return _$getGenerallProductsAsyncAction
        .run(() => super.getGenerallProducts());
  }

  late final _$getCartItemsAsyncAction =
      AsyncAction('_ProductsStore.getCartItems', context: context);

  @override
  Future<void> getCartItems() {
    return _$getCartItemsAsyncAction.run(() => super.getCartItems());
  }

  late final _$plusMinusToCartAsyncAction =
      AsyncAction('_ProductsStore.plusMinusToCart', context: context);

  @override
  Future<void> plusMinusToCart({required ProductModel model}) {
    return _$plusMinusToCartAsyncAction
        .run(() => super.plusMinusToCart(model: model));
  }

  late final _$plusMinusCartManualAsyncAction =
      AsyncAction('_ProductsStore.plusMinusCartManual', context: context);

  @override
  Future<void> plusMinusCartManual(
      {required ProductModel model, required String value}) {
    return _$plusMinusCartManualAsyncAction
        .run(() => super.plusMinusCartManual(model: model, value: value));
  }

  late final _$plusToCartAsyncAction =
      AsyncAction('_ProductsStore.plusToCart', context: context);

  @override
  Future<void> plusToCart({required ProductModel model}) {
    return _$plusToCartAsyncAction.run(() => super.plusToCart(model: model));
  }

  late final _$minusToCartAsyncAction =
      AsyncAction('_ProductsStore.minusToCart', context: context);

  @override
  Future<void> minusToCart({required ProductModel model}) {
    return _$minusToCartAsyncAction.run(() => super.minusToCart(model: model));
  }

  late final _$addToCartAsyncAction =
      AsyncAction('_ProductsStore.addToCart', context: context);

  @override
  Future<void> addToCart({required ProductModel model}) {
    return _$addToCartAsyncAction.run(() => super.addToCart(model: model));
  }

  late final _$removeFromCartAsyncAction =
      AsyncAction('_ProductsStore.removeFromCart', context: context);

  @override
  Future<void> removeFromCart({required ProductModel model}) {
    return _$removeFromCartAsyncAction
        .run(() => super.removeFromCart(model: model));
  }

  @override
  String toString() {
    return '''
catState: ${catState},
categories: ${categories},
prodState: ${prodState},
ethicalProductList: ${ethicalProductList},
genericProductList: ${genericProductList},
surgicalProductList: ${surgicalProductList},
veterinaryProductList: ${veterinaryProductList},
ayurvedicProductList: ${ayurvedicProductList},
generalProductList: ${generalProductList},
allProducts: ${allProducts},
cartItemsList: ${cartItemsList},
cartModel: ${cartModel}
    ''';
  }
}
