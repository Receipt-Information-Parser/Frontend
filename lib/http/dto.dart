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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
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

  UserResponses(
      {this.birthday,
        this.email,
        this.gender,
        this.name,
        this.nickname,
        this.tokenResponse});

  UserResponses.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    nickname = json['nickname'];
    tokenResponse = json['tokenResponse'] != null
        ? new TokenResponse.fromJson(json['tokenResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    if (this.tokenResponse != null) {
      data['tokenResponse'] = this.tokenResponse!.toJson();
    }
    return data;
  }
}

class PictureResponse {
  final String eTag;
  final String key;
  final String lastModified;
  final Owner owner;
  final int size;
  final String storageClass;

  PictureResponse(
      {required this.eTag,
        required this.key,
        required this.lastModified,
        required this.owner,
        required this.size,
        required this.storageClass});

  factory PictureResponse.fromJson(Map<String, dynamic> json) {
    return PictureResponse(
      eTag: json['ETag'] as String,
      key: json['Key'] as String,
      lastModified: json['LastModified'] as String,
      owner: Owner.fromJson(json['Owner'] as Map<String, dynamic>),
      size: json['Size'] as int,
      storageClass: json['StorageClass'] as String,
    );
  }
}

class Owner {
  final String displayName;
  final String id;

  Owner({required this.displayName, required this.id});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      displayName: json['DisplayName'] as String,
      id: json['ID'] as String,
    );
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