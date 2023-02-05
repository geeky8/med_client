import 'package:shared_preferences/shared_preferences.dart';

class DataBox {
  final String _sessId = 'sessid';
  final _pin = 'pin';
  final _adminStatus = 'adminStatus';
  final _completionStatus = 'completionStatus';
  final _phone = 'phone';
  final _payeLater = 'payLater';
  final _firmName = 'firmName';

  // Future<void> initDataBox() async {
  //   await GetStorage.init();
  // }

  Future<void> writeSessId({required String sessId}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setString(
      _sessId,
      sessId,
    );
    // print('success');
  }

  Future<String> readSessId() async {
    final dataBox = await SharedPreferences.getInstance();
    final sessId = (dataBox.get(_sessId) ?? '') as String;
    return sessId;
  }

  Future<void> writeAdminStatus({required bool status}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setBool(_adminStatus, status);
    // print('success');
  }

  Future<bool> readAdminStatus() async {
    final dataBox = await SharedPreferences.getInstance();
    final status = (dataBox.get(_adminStatus) ?? false) as bool;
    return status;
  }

  Future<void> writeCompletionStatus({required bool status}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setBool(_completionStatus, status);
    // print('success');
  }

  Future<bool> readCompletionStatus() async {
    final dataBox = await SharedPreferences.getInstance();
    final status = (dataBox.get(_completionStatus) ?? false) as bool;
    return status;
  }

  Future<void> writePin({required String pin}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setString(_pin, pin);
    // print('success');
  }

  Future<String> readPin() async {
    final dataBox = await SharedPreferences.getInstance();
    final pin = (dataBox.get(_pin) ?? '') as String;
    return pin;
  }

  Future<void> writePhoneNo({required String phone}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setString(_phone, phone);
    // print('success');
  }

  Future<String> readPhoneNo() async {
    final dataBox = await SharedPreferences.getInstance();
    final phone = (dataBox.get(_phone) ?? '') as String;
    return phone;
  }

  Future<void> writePayLater({required bool paylater}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setBool(_payeLater, paylater);
    // print('success');
  }

  Future<bool> readPayLate() async {
    final dataBox = await SharedPreferences.getInstance();
    final paylater = (dataBox.get(_payeLater) ?? false) as bool;
    return paylater;
  }

  Future<void> writeFirmName({required String name}) async {
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.setString(_firmName, name);
    // print('success');
  }

  Future<String> readFirmName() async {
    final dataBox = await SharedPreferences.getInstance();
    final name = (dataBox.get(_firmName) ?? '') as String;
    return name;
  }

  Future<void> removeDataBox() async {
    // final user = readDataBox();
    final dataBox = await SharedPreferences.getInstance();
    await dataBox.remove(_sessId);
    await dataBox.remove(_pin);
    await dataBox.remove(_adminStatus);
    await dataBox.remove(_completionStatus);
  }
}
