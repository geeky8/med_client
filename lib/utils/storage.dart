import 'package:shared_preferences/shared_preferences.dart';

class DataBox {
  final String _sessId = 'sessid';
  final _pin = 'pin';
  final _adminStatus = 'adminStatus';
  final _completionStatus = 'completionStatus';

  // Future<void> initDataBox() async {
  //   await GetStorage.init();
  // }

  Future<void> writeSessId({required String sessId}) async {
    final _dataBox = await SharedPreferences.getInstance();
    await _dataBox.setString(
      _sessId,
      sessId,
    );
    // print('success');
  }

  Future<String> readSessId() async {
    final _dataBox = await SharedPreferences.getInstance();
    final sessId = (_dataBox.get(_sessId) ?? '') as String;
    return sessId;
  }

  Future<void> writeAdminStatus({required bool status}) async {
    final _dataBox = await SharedPreferences.getInstance();
    await _dataBox.setBool(_adminStatus, status);
    // print('success');
  }

  Future<bool> readAdminStatus() async {
    final _dataBox = await SharedPreferences.getInstance();
    final status = (_dataBox.get(_adminStatus) ?? false) as bool;
    return status;
  }

  Future<void> writeCompletionStatus({required bool status}) async {
    final _dataBox = await SharedPreferences.getInstance();
    await _dataBox.setBool(_completionStatus, status);
    // print('success');
  }

  Future<bool> readCompletionStatus() async {
    final _dataBox = await SharedPreferences.getInstance();
    final status = (_dataBox.get(_completionStatus) ?? false) as bool;
    return status;
  }

  Future<void> writePin({required String pin}) async {
    final _dataBox = await SharedPreferences.getInstance();
    await _dataBox.setString(_pin, pin);
    // print('success');
  }

  Future<String> readPin() async {
    final _dataBox = await SharedPreferences.getInstance();
    final pin = (_dataBox.get(_pin) ?? '') as String;
    return pin;
  }

  Future<void> removeDataBox() async {
    // final user = readDataBox();
    final _dataBox = await SharedPreferences.getInstance();
    await _dataBox.remove(_sessId);
    await _dataBox.remove(_pin);
    await _dataBox.remove(_adminStatus);
    await _dataBox.remove(_completionStatus);
  }
}
