// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStore, Store {
  late final _$loginModelAtom =
      Atom(name: '_LoginStore.loginModel', context: context);

  @override
  OTPModel get loginModel {
    _$loginModelAtom.reportRead();
    return super.loginModel;
  }

  @override
  set loginModel(OTPModel value) {
    _$loginModelAtom.reportWrite(value, super.loginModel, () {
      super.loginModel = value;
    });
  }

  late final _$buttonStateAtom =
      Atom(name: '_LoginStore.buttonState', context: context);

  @override
  ButtonState get buttonState {
    _$buttonStateAtom.reportRead();
    return super.buttonState;
  }

  @override
  set buttonState(ButtonState value) {
    _$buttonStateAtom.reportWrite(value, super.buttonState, () {
      super.buttonState = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_LoginStore.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$loginAsyncAction =
      AsyncAction('_LoginStore.login', context: context);

  @override
  Future<void> login(
      {required String value,
      required BuildContext context,
      required ProductsStore productsStore,
      required LoginStore loginStore,
      required ProfileStore profileStore,
      required BottomNavigationStore bottomNavigationStore,
      required OrderHistoryStore orderHistoryStore}) {
    return _$loginAsyncAction.run(() => super.login(
        value: value,
        context: context,
        productsStore: productsStore,
        loginStore: loginStore,
        profileStore: profileStore,
        bottomNavigationStore: bottomNavigationStore,
        orderHistoryStore: orderHistoryStore));
  }

  @override
  String toString() {
    return '''
loginModel: ${loginModel},
buttonState: ${buttonState}
    ''';
  }
}
