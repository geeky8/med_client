import 'package:medrpha_customer/enums/button_state.dart';
import 'package:medrpha_customer/signup_login/models/otp_model.dart';
import 'package:medrpha_customer/signup_login/repository/login_repository.dart';
import 'package:medrpha_customer/utils/storage.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final _repository = LoginRepository();
  // final _storage = LocalStorage();

  final _dataBox = DataBox();

  /// Getting session ID of the current User.
  @observable
  OTPModel loginModel =
      OTPModel(sessId: '', adminStatus: false, completedStatus: false);

  /// [ButtonState] for change in state of the button on click
  @observable
  ButtonState buttonState = ButtonState.SUCCESS;

  @action
  Future<void> init() async {
    final _sessId = await DataBox().readSessId();
    final _adminStatus = await DataBox().readAdminStatus();
    final _completedStatus = await DataBox().readCompletionStatus();

    loginModel = OTPModel(
        sessId: _sessId,
        adminStatus: _adminStatus,
        completedStatus: _completedStatus);
  }

  Future<void> getUserStatus() async {
    // buttonState = ButtonState.LOADING;
    final model = await _repository.getUserStatus(model: loginModel);
    // print(model.completedStatus);
    // print(model.adminStatus);
    loginModel = model;
    await DataBox().writeSessId(sessId: loginModel.sessId);
    await DataBox().writeAdminStatus(status: loginModel.adminStatus);
    await DataBox().writeCompletionStatus(status: loginModel.completedStatus);
    // buttonState = ButtonState.SUCCESS;
  }

  ///
  Future<void> getOTP({
    required String mobile,
  }) async {
    buttonState = ButtonState.LOADING;
    final resp = await _repository.getOTP(
      mobile: mobile,
    );
    // print('parth');
    if (resp != 'error') {
      buttonState = ButtonState.SUCCESS;
    } else {
      buttonState = ButtonState.ERROR;
    }
  }

  Future<int> verifyOTP({required String mobile, required String otp}) async {
    buttonState = ButtonState.LOADING;
    final model = await _repository.checkOTP(phone: mobile, otp: otp);
    // print(model.sessId);
    if (model.sessId != '') {
      /// update the session Id
      await _dataBox.writeSessId(sessId: model.sessId);

      /// Update the admin status
      if (model.adminStatus) {
        await _dataBox.writeAdminStatus(status: true);
      } else {
        await _dataBox.writeAdminStatus(status: false);
      }

      /// Update the Completion Status
      if (model.completedStatus) {
        await _dataBox.writeCompletionStatus(status: true);
      } else {
        await _dataBox.writeCompletionStatus(status: false);
      }
      loginModel = loginModel.copyWith(sessId: model.sessId);
      buttonState = ButtonState.SUCCESS;
      return 1;
    } else {
      buttonState = ButtonState.ERROR;
      return 0;
    }
  }
}
