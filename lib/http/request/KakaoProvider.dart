import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rip_front/http/dto.dart';
import 'package:rip_front/http/dto/BooleanResponse.dart';
import 'package:rip_front/http/dto/KakaoRequest.dart';

import '../../constants.dart';

class KakaoProvider {

  Future<BooleanResponse> existUser(String id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}user/kakao/exist/$id'),
    );

    if (response.statusCode == 200) {
      return BooleanResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return Future.error(
      '${body['status']}: ${body['message']}');
    }
  }

  Future<UserResponse> signUp(KakaoSignUpRequest kakaoSignUpRequest) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/kakao/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: kakaoSignUpRequest.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return Future.error(
          '${body['status']}: ${body['message']}');
    }
  }

  Future<UserResponse> login(KakaoLoginRequest kakaoLoginRequest) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/kakao/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: kakaoLoginRequest.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return UserResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return Future.error(
          '${body['status']}: ${body['message']}');
    }
  }

  Future<dynamic> me(String token) async {
    final response = await http.get(
      Uri.parse('https://kapi.kakao.com/v2/user/me'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token"
      }
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return Future.error(
          '${body['status']}: ${body['message']}');
    }
  }
}
