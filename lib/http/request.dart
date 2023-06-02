import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
// Future<UserResponse> modifyNickname(
//     String url, ModifyRequest modifyRequest, String? token) async {
//   final response = await http.post(
//     Uri.parse(url),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       HttpHeaders.authorizationHeader: "Bearer ${token!}"
//     },
//     body: modifyRequest.toJson(),
//   );
Future<List<PictureResponse>> getPictureList(String url, String? token) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer ${token!}"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => PictureResponse.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load pictures, Status Code: ${response.statusCode}');
  }
}

Future<File> getPictureObject(String url,String object) async {
  var request = await HttpClient().getUrl(Uri.parse('$url/$object'));
  print('[debug]url:$url/$object');
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String _dir = (await getApplicationDocumentsDirectory()).path;
  var dir = Directory('$_dir/profile');
  if (!await dir.exists()) {
    await dir.create(recursive: true); // recursively create all non-existent directories
  }
  File file = File('$dir/profile.jpg');
  await file.writeAsBytes(bytes);
  return file;
}

Future<PictureResponse> savePicture(String url,File file) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return PictureResponse.fromJson(json.decode(responseString));
  } else {
    throw Exception('Failed to save picture');
  }
}