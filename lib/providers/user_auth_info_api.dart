import '../models/user_auth_info.dart';

class UserAuthInfoApi {
  static UserAuthInfo? userAuthInfo;

  static UserAuthInfo? getUserAuthInfo() {
    userAuthInfo ??= UserAuthInfo(email: "email", password: "password");

    // TODO: call API get method
    return userAuthInfo;
  }

  static void setUserAuthInfo(UserAuthInfo newUserAuthInfo) {
    // TODO: call API post method
    userAuthInfo = newUserAuthInfo;
  }

  static void resetEmail(String Email) {
    userAuthInfo?.email = Email;
  }

  static void resetPW(String PW) {
    userAuthInfo?.password = PW;
  }

  static void show() {
    print(
        "[Debug]\nemail: ${userAuthInfo?.email}\npassword: ${userAuthInfo?.password}");
  }
}
