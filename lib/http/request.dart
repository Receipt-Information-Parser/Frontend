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

  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create account.');
  }
}

// Future<UserResponse> Login(String url, LoginRequest loginRequest) async {
//   print("[debug]: Login Post Start, url:${url}");
//   final response = await http.post(
//     Uri.parse(url),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: loginRequest.toJson(),
//   );
//   print("[debug]: Login Post fin");
//   if (response.statusCode == 200) {
//     return UserResponse.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to log in.');
//   }
// }
Future<UserResponse> Login(String url, LoginRequest loginRequest) async {
  print("[debug]: Login Post Start, url:${url}");
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: loginRequest.toJson(),
    );
    print("[debug]: Login Post fin");
    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to log in. Response status code: ${response.statusCode}');
    }
  } catch (e) {
    print('There was a problem with the login request: $e');
    throw e;
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

Future<EmailResponse> existsNickname(NicknameRequest nicknameRequest) async {
  final response = await http.post(
    Uri.parse('http://localhost:19983/api/user/existsNickname'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(nicknameRequest.toJson()),
  );

  if (response.statusCode == 200) {
    return EmailResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to check nickname.');
  }
}

Future<EmailResponse> getNickname(NicknameRequest nicknameRequest) async {
  final response = await http.post(
    Uri.parse('http://localhost:19983/api/user/getNickname'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(nicknameRequest.toJson()),
  );

  if (response.statusCode == 200) {
    return EmailResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get email by nickname.');
  }
}

Future<EmailResponse> resetPassword(EmailRequest emailRequest) async {
  final response = await http.post(
    Uri.parse('http://localhost:19983/api/user/reset'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(emailRequest.toJson()),
  );

  if (response.statusCode == 200) {
    return EmailResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to reset password.');
  }
}
