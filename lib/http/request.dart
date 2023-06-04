import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dto.dart';

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

Future getPictureObject(String url, String? object, String? token) async {
  var httpClient = HttpClient();
  var request = await httpClient.getUrl(Uri.parse('$url/$object'));

  // Bearer token
  request.headers.set('authorization', 'Bearer $token');

  print('[debug]url:$url/$object');
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  final dir = await getExternalStorageDirectory();
  File file = File('${dir!.path}/$object');
  await file.writeAsBytes(bytes);
  return file;
}


Future<KeyResponse> savePicture(String url, File file, String? token) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // Bearer token 추가
  request.headers.addAll({'Authorization': 'Bearer $token'});

  request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return KeyResponse.fromJson(json.decode(responseString));
  } else {
    throw Exception('Failed to save picture');
  }
}
