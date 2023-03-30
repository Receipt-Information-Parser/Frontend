import '../models/user_attribute.dart';

class UserAttributeApi {
  static UserAttribute? userAttribute;

  static UserAttribute? getUserAttribute() {
    // TODO: api call get method
    userAttribute ??= UserAttribute(
        email: "email",
        nickname: "nickname",
        name: "name",
        gender: true,
        birthDate: DateTime.now(),
        field: "");
    //  GetUserInfo 실행
    return userAttribute;
  }

  static void setUserAttribute(UserAttribute newUserAttribute) {
    // TODO: api call post method
    userAttribute = newUserAttribute;
  }

  static void resetEmail(String email) {
    userAttribute?.email = email;
  }

  static void resetNickname(String nickname) {
    userAttribute?.nickname = nickname;
  }

  static void resetName(String name) {
    userAttribute?.name = name;
  }

  static void resetGender(bool gender) {
    userAttribute?.gender = gender;
  }

  static void resetBirthdate(DateTime birthdate) {
    userAttribute?.birthDate = birthdate;
  }

  static void resetField(String field) {
    userAttribute?.field = field;
  }

  static void show() {
    print(
        "[Debug]\nemail: ${userAttribute?.email}\nnickname: ${userAttribute?.nickname}\nname: ${userAttribute?.name}\ngender: ${userAttribute?.gender}\nbirthday: ${userAttribute?.birthDate}\nfield: ${userAttribute?.field}");
  }
}
