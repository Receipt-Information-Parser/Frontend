class UserAttribute {
  // UserAuthInfo의 email 필드와 동일한 값
  String email;
  String name;
  bool gender;
  DateTime birthDate;
  String nickname;
  String profileImage;

  UserAttribute(
      {required this.email,
      required this.nickname,
      required this.name,
      required this.gender,
      required this.birthDate,
      required this.profileImage,
      });
}
