import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dto.dart';

// 지금까지 구현된 것
// 로그인, 회원가입, 공모전 생성, 사용자 설정

// 구현해야 할 것
// 공모전 목록 가져오기, 참가, 참가 승인

Future<UserResponse> SignUp(String uri, SignUpRequest signUpRequest) async {
  print('[debug] ${signUpRequest.toJson()}');

  final response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: signUpRequest.toJson(),
  );
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // Future 객체의 실행구문에서 error 발생시켜, 호출한 구문의 then() 내부의 onError 콜백 함수가 실행되도록 한다.
    return Future.error(
        '${json.decode(utf8.decode(response.bodyBytes))['status']}: Failed to post signup');
  }
}

Future<EmailResponse> Email(String uri, EmailRequest emailRequest) async {
  final response = await http.post(
    Uri(path: uri),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: emailRequest.toJson(),
  );
  if (response.statusCode == 200) {
    return EmailResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to post login');
  }
}

Future<UserResponse> Login(String uri, LoginRequest loginRequest) async {
  final response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: loginRequest.toJson(),
  );
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // Future 객체의 실행구문에서 error 발생시켜, 호출한 구문의 then() 내부의 onError 콜백 함수가 실행되도록 한다.
    return Future.error(
        '${json.decode(utf8.decode(response.bodyBytes))['status']}: Failed to post login');
  }
}

Future<UserResponse> Modify(
    String uri, ModifyRequest modifyRequest, String? token) async {
  final response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer ${token!}"
    },
    body: modifyRequest.toJson(),
  );
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // Future 객체의 실행구문에서 error 발생시켜, 호출한 구문의 then() 내부의 onError 콜백 함수가 실행되도록 한다.
    return Future.error(
        '${json.decode(utf8.decode(response.bodyBytes))['status']}: Failed to post login');
  }
}