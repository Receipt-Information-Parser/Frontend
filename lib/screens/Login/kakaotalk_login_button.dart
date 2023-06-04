import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../constants.dart';

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double buttonHeight;

  const KakaoLoginButton({super.key,
    required this.onPressed,
    this.buttonHeight = heightButton,
  });

  Future<void> kakaoLogin() async {
    var REDIRECT_URI = 'url';// 서버에서 token값을 받을 kakao oauth API 주소
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        print('[debug]oauth:success');
        await AuthCodeClient.instance.authorizeWithTalk(
          redirectUri: '${REDIRECT_URI}',
        );
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        await AuthCodeClient.instance.authorize(
          redirectUri: '${REDIRECT_URI}',
        );
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: fontSizeButton, fontWeight: FontWeight.bold
        ),
        backgroundColor: Color(0xFFFEE500),
        minimumSize: const Size(widthButton, heightButton),
        side: const BorderSide(color: Color(0xFFFEE500), width: 1.5),
        elevation: 0,
      ),
      onPressed: () async {
        await kakaoLogin();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'lib/assets/kakaotalk_logo.png',
            height: 24.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              '카카오로 로그인하기',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}