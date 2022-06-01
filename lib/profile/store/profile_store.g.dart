// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileStore on _ProfileStore, Store {
  late final _$pageAtom = Atom(name: '_ProfileStore.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$saveStateAtom =
      Atom(name: '_ProfileStore.saveState', context: context);

  @override
  ButtonState get saveState {
    _$saveStateAtom.reportRead();
    return super.saveState;
  }

  @override
  set saveState(ButtonState value) {
    _$saveStateAtom.reportWrite(value, super.saveState, () {
      super.saveState = value;
    });
  }

  late final _$profileModelAtom =
      Atom(name: '_ProfileStore.profileModel', context: context);

  @override
  ProfileModel get profileModel {
    _$profileModelAtom.reportRead();
    return super.profileModel;
  }

  @override
  set profileModel(ProfileModel value) {
    _$profileModelAtom.reportWrite(value, super.profileModel, () {
      super.profileModel = value;
    });
  }

  late final _$saveCertificateAsyncAction =
      AsyncAction('_ProfileStore.saveCertificate', context: context);

  @override
  Future<void> saveCertificate(
      {required String path, required List<int> bytes, required String url}) {
    return _$saveCertificateAsyncAction
        .run(() => super.saveCertificate(path: path, bytes: bytes, url: url));
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ProfileStore.updateProfile', context: context);

  @override
  Future<void> updateProfile({required BuildContext context}) {
    return _$updateProfileAsyncAction
        .run(() => super.updateProfile(context: context));
  }

  @override
  String toString() {
    return '''
page: ${page},
saveState: ${saveState},
profileModel: ${profileModel}
    ''';
  }
}
