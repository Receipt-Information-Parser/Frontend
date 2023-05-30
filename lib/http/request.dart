import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dto.dart';

// 지금까지 구현된 것
// 로그인, 회원가입, 공모전 생성, 사용자 설정

// 구현해야 할 것
// 공모전 목록 가져오기, 참가, 참가 승인

Future<UserResponse> SignUp(String url, SignUpRequest signUpRequest) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: signUpRequest.toJson(),
  );
  print('[debug] response status code : ${response.statusCode}');
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to create account.');
  }
}

Future<UserResponse> Login(String url, LoginRequest loginRequest) async {
  print("[debug]: Login Post Start, url:${url}");
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: loginRequest.toJson(),
  );
  print("[debug]: Login Post fin");
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to log in.');
  }
}
// for debug
// Future<UserResponse> Login(String url, LoginRequest loginRequest) async {
//   print("[debug]: Login Post Start, url:${url}");
//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: loginRequest.toJson(),
//     );
//     print("[debug]: Login Post fin");
//     if (response.statusCode == 200) {
//       return UserResponse.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to log in. Response status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('There was a problem with the login request: $e');
//     throw e;
//   }
// }

Future<MessageResponse> existsEmail(String url, EmailRequest emailRequest) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(emailRequest.toJson()),
  );
  if (response.statusCode == 200 || response.statusCode == 400) {
    // 한글 response시 decode 방식
    return MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to check email existence');
  }
}

Future<UserResponse> modifyNickname(
    String url, ModifyRequest modifyRequest, String? token) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer ${token!}"
    },
    body: modifyRequest.toJson(),
  );
  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    return Future.error(
        '${json.decode(utf8.decode(response.bodyBytes))['status']}: Failed to modify nickname');
  }
}

Future<MessageResponse> existsNickname(String url, NicknameRequest nicknameRequest) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(nicknameRequest.toJson()),
  );

  if (response.statusCode == 200 || response.statusCode == 400) {
    return MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to check nickname.');
  }
}

Future<MessageResponse> getEmail(String url, NicknameRequest nicknameRequest) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(nicknameRequest.toJson()),
  );

  if (response.statusCode == 200 || response.statusCode == 400) {
    return MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to get email by nickname.');
  }
}

Future<MessageResponse> resetPassword(String url, EmailRequest emailRequest) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(emailRequest.toJson()),
  );

  if (response.statusCode == 200 ||  response.statusCode == 400) {
    return MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to reset password.');
  }
}
