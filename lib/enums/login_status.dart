/// [LoginStatusType] for managing login status of users.
// ignore_for_file: constant_identifier_names

enum LoginStatusType {
  ///[LoginStatusType.LOGIN] for succesful login.
  LOGIN,

  ///[LoginStatusType.ERROR] for failure in login or logout.
  ERROR,

  ///[LoginStatusType.LOGOUT] for successful logout.
  LOGOUT,
}

extension LoginStatusTypeExtenstion on LoginStatusType {
  int inInt() {
    switch (this) {
      case LoginStatusType.LOGIN:
        return 1;
      case LoginStatusType.ERROR:
        return -1;
      case LoginStatusType.LOGOUT:
        return 0;
    }
  }
}

LoginStatusType fromValue(int status) {
  switch (status) {
    case 1:
      return LoginStatusType.LOGIN;
    case -1:
      return LoginStatusType.ERROR;
    case 0:
      return LoginStatusType.LOGOUT;
  }
  return LoginStatusType.ERROR;
}
