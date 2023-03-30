import 'dart:convert';

class SignUpRequest {
  String? birthday;
  String? email;
  String? gender;
  String? name;
  String? nickname;
  String? password;

  SignUpRequest(
      {this.birthday,
      this.email,
      this.gender,
      this.name,
      this.nickname,
      this.password});

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birthday'] = birthday ?? "";
    data['email'] = email ?? "";
    data['gender'] = gender ?? "";
    data['name'] = name ?? "";
    data['nickname'] = nickname ?? "";
    data['password'] = password ?? "";

    return json.encode(data); // json.encode 적용하여 최종적으로 String 형태로 반환
  }
}

class EmailRequest {
  String? email;

  EmailRequest({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email ?? "";
    return data;
  }
}

class EmailResponse {
  String? message;

  EmailResponse({this.message});

  EmailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
  }
}

class UserResponse {
  String? birthday;
  String? email;
  String? gender;
  String? name;
  String? nickname;
  TokenResponse? tokenResponse;

  UserResponse(
      {this.birthday,
      this.email,
      this.gender,
      this.name,
      this.nickname,
      this.tokenResponse});

  UserResponse.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'] ?? "";
    email = json['email'] ?? "";
    gender = json['gender'] ?? "";
    name = json['name'] ?? "";
    nickname = json['nickname'] ?? "";
    tokenResponse = json['tokenResponse'] != null
        ? TokenResponse.fromJson(json['tokenResponse'])
        : null;
  }
}

class TokenResponse {
  String? accessToken;
  String? refreshToken;

  TokenResponse(String s, {this.accessToken, this.refreshToken});

  TokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken ?? "";
    data['refreshToken'] = refreshToken ?? "";
    return data;
  }
}

class LoginRequest {
  String? email;
  String? password;

  LoginRequest({this.email, this.password});

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email ?? "";
    data['password'] = password ?? "";
    return jsonEncode(data);
  }
}

class ModifyRequest {
  String? nickname;

  ModifyRequest({this.nickname});

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname;
    data['showParticipationCount'] = true;
    data['showParticipationList'] = true;
    return jsonEncode(data);
  }
}

class UserResponses {
  String? birthday;
  List<String>? categories;
  String? email;
  String? gender;
  String? name;
  String? nickname;
  bool? showParticipationCount;
  bool? showParticipationList;
  TokenResponse? tokenResponse;

  UserResponses(
      {this.birthday,
        this.categories,
        this.email,
        this.gender,
        this.name,
        this.nickname,
        this.showParticipationCount,
        this.showParticipationList,
        this.tokenResponse});

  UserResponses.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    categories = json['categories'].cast<String>();
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    nickname = json['nickname'];
    showParticipationCount = json['showParticipationCount'];
    showParticipationList = json['showParticipationList'];
    tokenResponse = json['tokenResponse'] != null
        ? new TokenResponse.fromJson(json['tokenResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['categories'] = this.categories;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['showParticipationCount'] = this.showParticipationCount;
    data['showParticipationList'] = this.showParticipationList;
    if (this.tokenResponse != null) {
      data['tokenResponse'] = this.tokenResponse!.toJson();
    }
    return data;
  }
}