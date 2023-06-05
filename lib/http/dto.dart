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

  EmailRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}

class MessageResponse {
  String? message;

  MessageResponse({this.message});

  MessageResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
  }
}

class NicknameRequest {
  String? nickname;

  NicknameRequest({this.nickname});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname ?? "";
    return data;
  }
}

class UserResponse {
  String? birthday;
  String? email;
  String? gender;
  String? name;
  String? nickname;
  TokenResponse? tokenResponse;
  String? profileImage;

  UserResponse(
      {this.birthday,
      this.email,
      this.gender,
      this.name,
      this.nickname,
      this.tokenResponse,
      this.profileImage});

  UserResponse.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'] ?? "";
    email = json['email'] ?? "";
    gender = json['gender'] ?? "";
    name = json['name'] ?? "";
    nickname = json['nickname'] ?? "";
    tokenResponse = json['tokenResponse'] != null
        ? TokenResponse.fromJson(json['tokenResponse'])
        : null;
    profileImage = json['profileImage'] ?? "";
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
    return jsonEncode(data);
  }
}

class UserResponses {
  String? birthday;
  String? email;
  String? gender;
  String? name;
  String? nickname;
  TokenResponse? tokenResponse;
  String? profileImage;

  UserResponses(
      {this.birthday,
        this.email,
        this.gender,
        this.name,
        this.nickname,
        this.tokenResponse,
        this.profileImage});

  UserResponses.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    nickname = json['nickname'];
    tokenResponse = json['tokenResponse'] != null
        ? TokenResponse.fromJson(json['tokenResponse'])
        : null;
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birthday'] = birthday;
    data['email'] = email;
    data['gender'] = gender;
    data['name'] = name;
    data['nickname'] = nickname;
    if (tokenResponse != null) {
      data['tokenResponse'] = tokenResponse!.toJson();
    }
    data['profileImage'] = profileImage;
    return data;
  }
}

class KeyResponse {
  final String key;

  KeyResponse({required this.key});

  factory KeyResponse.fromJson(Map<String, dynamic> json) {
    return KeyResponse(
      key: json['key'] as String? ?? '',
    );
  }
}

class ByPeriod {

  final DateTime date;
  final int amount;
  final int analysisId;

  ByPeriod({
    required this.date,
    required this.amount,
    required this.analysisId,
  });

  factory ByPeriod.fromJson(Map<String, dynamic> json) {
    return ByPeriod(
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      analysisId: json['analysisId'],
    );
  }
}

class ByProduct {
  final String name;
  final int amount;
  final int analysisId;
  final DateTime date;

  ByProduct({
    required this.name,
    required this.amount,
    required this.analysisId,
    required this.date,
  });

  factory ByProduct.fromJson(Map<String, dynamic> json) {
    return ByProduct(
      name: json['name'],
      amount: json['amount'],
      analysisId: json['analysisId'],
      date: DateTime.parse(json['date']),
    );
  }
}