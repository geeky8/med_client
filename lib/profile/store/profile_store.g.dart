// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

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

  late final _$certi1Atom =
      Atom(name: '_ProfileStore.certi1', context: context);

  @override
  StoreState get certi1 {
    _$certi1Atom.reportRead();
    return super.certi1;
  }

  @override
  set certi1(StoreState value) {
    _$certi1Atom.reportWrite(value, super.certi1, () {
      super.certi1 = value;
    });
  }

  late final _$certi2Atom =
      Atom(name: '_ProfileStore.certi2', context: context);

  @override
  StoreState get certi2 {
    _$certi2Atom.reportRead();
    return super.certi2;
  }

  @override
  set certi2(StoreState value) {
    _$certi2Atom.reportWrite(value, super.certi2, () {
      super.certi2 = value;
    });
  }

  late final _$countryListAtom =
      Atom(name: '_ProfileStore.countryList', context: context);

  @override
  ObservableList<CountryModel> get countryList {
    _$countryListAtom.reportRead();
    return super.countryList;
  }

  @override
  set countryList(ObservableList<CountryModel> value) {
    _$countryListAtom.reportWrite(value, super.countryList, () {
      super.countryList = value;
    });
  }

  late final _$stateListAtom =
      Atom(name: '_ProfileStore.stateList', context: context);

  @override
  ObservableList<StateModel> get stateList {
    _$stateListAtom.reportRead();
    return super.stateList;
  }

  @override
  set stateList(ObservableList<StateModel> value) {
    _$stateListAtom.reportWrite(value, super.stateList, () {
      super.stateList = value;
    });
  }

  late final _$cityListAtom =
      Atom(name: '_ProfileStore.cityList', context: context);

  @override
  ObservableList<CityModel> get cityList {
    _$cityListAtom.reportRead();
    return super.cityList;
  }

  @override
  set cityList(ObservableList<CityModel> value) {
    _$cityListAtom.reportWrite(value, super.cityList, () {
      super.cityList = value;
    });
  }

  late final _$areaListAtom =
      Atom(name: '_ProfileStore.areaList', context: context);

  @override
  ObservableList<AreaModel> get areaList {
    _$areaListAtom.reportRead();
    return super.areaList;
  }

  @override
  set areaList(ObservableList<AreaModel> value) {
    _$areaListAtom.reportWrite(value, super.areaList, () {
      super.areaList = value;
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

  late final _$areaFetchingAtom =
      Atom(name: '_ProfileStore.areaFetching', context: context);

  @override
  StoreState get areaFetching {
    _$areaFetchingAtom.reportRead();
    return super.areaFetching;
  }

  @override
  set areaFetching(StoreState value) {
    _$areaFetchingAtom.reportWrite(value, super.areaFetching, () {
      super.areaFetching = value;
    });
  }

  late final _$cityFetchingAtom =
      Atom(name: '_ProfileStore.cityFetching', context: context);

  @override
  StoreState get cityFetching {
    _$cityFetchingAtom.reportRead();
    return super.cityFetching;
  }

  @override
  set cityFetching(StoreState value) {
    _$cityFetchingAtom.reportWrite(value, super.cityFetching, () {
      super.cityFetching = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_ProfileStore.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$getProfileAsyncAction =
      AsyncAction('_ProfileStore.getProfile', context: context);

  @override
  Future<void> getProfile() {
    return _$getProfileAsyncAction.run(() => super.getProfile());
  }

  late final _$getAreaCitySpecificAsyncAction =
      AsyncAction('_ProfileStore.getAreaCitySpecific', context: context);

  @override
  Future<void> getAreaCitySpecific({String? id}) {
    return _$getAreaCitySpecificAsyncAction
        .run(() => super.getAreaCitySpecific(id: id));
  }

  late final _$getStateCitySpecificAsyncAction =
      AsyncAction('_ProfileStore.getStateCitySpecific', context: context);

  @override
  Future<void> getStateCitySpecific({String? id}) {
    return _$getStateCitySpecificAsyncAction
        .run(() => super.getStateCitySpecific(id: id));
  }

  late final _$saveCertificateAsyncAction =
      AsyncAction('_ProfileStore.saveCertificate', context: context);

  @override
  Future<void> saveCertificate(
      {required String path,
      required List<int> bytes,
      required String url,
      required BuildContext context}) {
    return _$saveCertificateAsyncAction.run(() => super
        .saveCertificate(path: path, bytes: bytes, url: url, context: context));
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ProfileStore.updateProfile', context: context);

  @override
  Future<void> updateProfile(
      {required BuildContext context,
      bool? beginToFill,
      required LoginStore loginStore}) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(
        context: context, beginToFill: beginToFill, loginStore: loginStore));
  }

  late final _$_ProfileStoreActionController =
      ActionController(name: '_ProfileStore', context: context);

  @override
  void updateLists({required int code, required int nameCode}) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.updateLists');
    try {
      return super.updateLists(code: code, nameCode: nameCode);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
page: ${page},
saveState: ${saveState},
certi1: ${certi1},
certi2: ${certi2},
countryList: ${countryList},
stateList: ${stateList},
cityList: ${cityList},
areaList: ${areaList},
profileModel: ${profileModel},
areaFetching: ${areaFetching},
cityFetching: ${cityFetching}
    ''';
  }
}
