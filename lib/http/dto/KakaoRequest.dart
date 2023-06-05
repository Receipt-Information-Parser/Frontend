import 'dart:convert';

class KakaoSignUpRequest {
  final String kakaoToken;

  final String nickname;

  final String birthday;

  const KakaoSignUpRequest({
    required this.kakaoToken, required this.nickname, required this.birthday
  });

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kakaoToken'] = kakaoToken ?? "";
    data['nickname'] = nickname ?? "";
    data['birthday'] = birthday ?? "";

    return json.encode(data);
  }
}

class KakaoLoginRequest {
  final String kakaoToken;

  const KakaoLoginRequest({
    required this.kakaoToken
  });

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kakaoToken'] = kakaoToken ?? "";

    return json.encode(data);
  }
}