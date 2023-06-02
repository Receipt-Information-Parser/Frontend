import '../models/user_attribute.dart';

class UserAttributeApi {
  static UserAttribute? userAttribute;

  static UserAttribute? getUserAttribute() {
    userAttribute ??= UserAttribute(
        email: "email",
        nickname: "nickname",
        name: "name",
        gender: true,
        birthDate: DateTime.now(),
        profileImage: ""
    );
    //  GetUserInfo 실행
    return userAttribute;
  }

  static void setUserAttribute(UserAttribute newUserAttribute) {
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

  static void resetProfileImage(String profileImage) {
    userAttribute?.profileImage = profileImage;
  }

  static void show() {
    print(
        "[Debug UserAtt]\nemail: ${userAttribute?.email}\nnickname: ${userAttribute?.nickname}\nname: ${userAttribute?.name}\ngender: ${userAttribute?.gender}\nbirthday: ${userAttribute?.birthDate}\nprofileImage${userAttribute?.profileImage}");
  }
}
