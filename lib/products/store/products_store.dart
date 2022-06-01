import 'package:medrpha_customer/enums/store_state.dart';
import 'package:medrpha_customer/products/models/cart_model.dart';
import 'package:medrpha_customer/products/models/category_model.dart';
import 'package:medrpha_customer/products/models/products_model.dart';
import 'package:medrpha_customer/products/repository/products_repository.dart';
import 'package:mobx/mobx.dart';

part 'products_store.g.dart';

class ProductsStore = _ProductsStore with _$ProductsStore;

abstract class _ProductsStore with Store {
  final _productsRepository = ProductsRepository();

  @observable
  StoreState catState = StoreState.SUCCESS;

  // @observable
  // StoreState state = StoreState.SUCCESS;

  @observable
  List<CategoryModel> categories = <CategoryModel>[];

  @observable
  StoreState prodState = StoreState.SUCCESS;

  @observable
  ObservableList<ProductModel> ethicalProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> genericProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> surgicalProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> veterinaryProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> ayurvedicProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> generalProductList =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> allProducts =
      ObservableList<ProductModel>.of([]);

  @observable
  ObservableList<ProductModel> cartItemsList = ObservableList.of([]);

  Future<void> init() async {
    await getCategories();
    await _getProducts();
    allProducts
      ..clear()
      ..addAll(ethicalProductList)
      ..addAll(genericProductList)
      ..addAll(surgicalProductList)
      ..addAll(veterinaryProductList)
      ..addAll(ayurvedicProductList)
      ..addAll(generalProductList);
    await getCartItems();
    // print('Parth');
  }

  Future<void> _getProducts() async {
    await getEthicalProducts();
    await getGenericProducts();
    await getSurgicalProducts();
    await getVeterinaryProducts();
    await getAyurvedicProducts();
    await getGenerallProducts();
  }

  @action
  Future<void> getCategories() async {
    catState = StoreState.LOADING;
    final _list = await _productsRepository.getCategories();
    if (_list.isNotEmpty) {
      categories
        ..clear()
        ..addAll(_list);

      catState = StoreState.SUCCESS;
    } else {
      catState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getEthicalProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '1');
    if (_list.isNotEmpty) {
      ethicalProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getGenericProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '2');
    if (_list.isNotEmpty) {
      genericProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getSurgicalProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '3');
    if (_list.isNotEmpty) {
      surgicalProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getVeterinaryProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '4');
    if (_list.isNotEmpty) {
      veterinaryProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getAyurvedicProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '5');
    if (_list.isNotEmpty) {
      ayurvedicProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  @action
  Future<void> getGenerallProducts() async {
    prodState = StoreState.LOADING;
    final _list = await _productsRepository.getProducts(categoryId: '6');
    if (_list.isNotEmpty) {
      generalProductList
        ..clear()
        ..addAll(_list);
      prodState = StoreState.SUCCESS;
    } else {
      prodState = StoreState.EMPTY;
    }
  }

  /// Cart-Screen
  @observable
  CartModel cartModel = CartModel(
    totalSalePrice: 0,
    noOfProducts: 0,
    productList: ObservableList<ProductModel>.of([]),
  );

  @action
  Future<void> getCartItems() async {
    final model = await _productsRepository.getCart();
    cartModel = model;
  }

  @action
  Future<void> plusMinusToCart({required ProductModel model}) async {
    final category = model.category;
    // print(model.cartQuantity);
    switch (category) {
      case 'Ethical':
        final index = ethicalProductList
            .indexWhere((element) => element.pid == model.pid);
        ethicalProductList
          ..removeAt(index)
          ..insert(index, model);
        // print(ethicalProductList[index].cartQuantity);
        break;
      case 'Generic':
        final index = genericProductList
            .indexWhere((element) => element.pid == model.pid);
        genericProductList
          ..removeAt(index)
          ..insert(index, model);
        break;
      case 'Surgical':
        final index = surgicalProductList
            .indexWhere((element) => element.pid == model.pid);
        surgicalProductList
          ..removeAt(index)
          ..insert(index, model);
        break;

      case 'Veterinary':
        final index = veterinaryProductList
            .indexWhere((element) => element.pid == model.pid);
        veterinaryProductList
          ..removeAt(index)
          ..insert(index, model);
        break;

      case 'Ayurvedic':
        final index = ayurvedicProductList
            .indexWhere((element) => element.pid == model.pid);
        ayurvedicProductList
          ..removeAt(index)
          ..insert(index, model);
        break;

      case 'General':
        final index = generalProductList
            .indexWhere((element) => element.pid == model.pid);
        generalProductList
          ..removeAt(index)
          ..insert(index, model);
        break;

      default:
        final index =
            allProducts.indexWhere((element) => element.pid == model.pid);
        allProducts
          ..removeAt(index)
          ..insert(index, model);
        break;
    }

    // final _totalPrice = (int.parse(model.salePrice) * model.cartQuantity!) +
    //     cartModel.totalSalePrice;
    // cartModel = cartModel.copyWith(
    //     totalSalePrice:
    //         _totalPrice); // print(ethicalProductList[index].cartQuantity);
  }

  @action
  Future<void> plusMinusCartManual(
      {required ProductModel model, required String value}) async {
    final currModel = model.copyWith(cartQuantity: int.parse(value));
    final _index = cartModel.productList
        .indexWhere((element) => element.pid == currModel.pid);
    cartModel.productList
      ..removeAt(_index)
      ..insert(_index, currModel);
    plusMinusToCart(model: currModel);
    await _productsRepository.updateQuantity(model: currModel);
    await getCartItems();
  }

  @action
  Future<void> plusToCart({required ProductModel model}) async {
    int qty = model.cartQuantity! + 1;
    final currModel = model.copyWith(cartQuantity: qty);
    final _index = cartModel.productList
        .indexWhere((element) => element.pid == currModel.pid);
    cartModel.productList
      ..removeAt(_index)
      ..insert(_index, currModel);
    plusMinusToCart(model: currModel);
    await _productsRepository.updateQuantity(model: currModel);
    await getCartItems();
  }

  @action
  Future<void> minusToCart({required ProductModel model}) async {
    if (model.cartQuantity! > 1) {
      int qty = model.cartQuantity! - 1;
      final currModel = model.copyWith(cartQuantity: qty);
      final _index = cartModel.productList
          .indexWhere((element) => element.pid == currModel.pid);
      cartModel.productList
        ..removeAt(_index)
        ..insert(_index, currModel);
      plusMinusToCart(model: currModel);
      await _productsRepository.updateQuantity(model: currModel);
      await getCartItems();
    }
  }

  @action
  Future<void> addToCart({required ProductModel model}) async {
    // final index =
    //     cartItemsList.indexWhere((element) => element.pid == model.pid);
    // if (index == -1) {
    // print(model.cartQuantity);
    int _qty = model.cartQuantity! + 1;
    final _currModel = model.copyWith(cartQuantity: _qty);
    cartModel.productList.add(_currModel);
    plusMinusToCart(model: _currModel);
    _productsRepository.addToCart(model: model);
    await getCartItems();
    // final totalPrice =
    //     (int.parse(model.salePrice) * int.parse(model.cartQuantity)) +
    //         cartModel.totalSalePrice;
    // cartModel = cartModel.copyWith(totalSalePrice: totalPrice);
    // }
  }

  @action
  Future<void> removeFromCart({required ProductModel model}) async {
    final index =
        cartModel.productList.indexWhere((element) => element.pid == model.pid);
    // print(index);
    if (index != -1) {
      cartModel.productList.removeAt(index);
      // plusMinusToCart(model: _currModel);
      await _productsRepository.removeFromCart(model: model);
      await getCartItems();
      // final totalPrice =
      //     (int.parse(model.salePrice) * int.parse(model.cartQuantity)) +
      //         cartModel.totalSalePrice;
      // cartModel = cartModel.copyWith(totalSalePrice: totalPrice);
    }
  }
}
