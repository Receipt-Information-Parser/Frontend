import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/http/dto.dart';
import 'package:rip_front/http/request/KakaoProvider.dart';
import 'package:rip_front/models/kakao_token.dart';
import 'package:rip_front/screens/Login/kakao_login_splash_screen.dart';
import '../../constants.dart';
import '../../http/dto/BooleanResponse.dart';
import '../../http/dto/KakaoRequest.dart';
import '../Home/home_screen.dart';
import '../signup/KakaoSignUp.dart';

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double buttonHeight;

  const KakaoLoginButton({super.key,
    required this.onPressed,
    this.buttonHeight = heightButton,
  });

  Future<KakaoToken> kakaoAuth(KakaoToken kakaoToken) async {
    var a = await KakaoSdk.origin;
    print(a);
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        kakaoToken.token = token.accessToken;
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        kakaoToken.token = token.accessToken;
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    KakaoProvider kakaoProvider = KakaoProvider();

    var me = await kakaoProvider.me(kakaoToken.token);

    String id = me['id'].toString();
    
    BooleanResponse isExistResponse = await kakaoProvider.existUser(id);

    if (isExistResponse.valid) {
      bool isExist = isExistResponse.boolean;
      kakaoToken.isExistUser = isExist;
      return kakaoToken;
    } else {
      return KakaoToken(token: "", isExistUser: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    KakaoToken kakaoToken = Provider.of<KakaoToken>(context);
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: fontSizeButton, fontWeight: FontWeight.bold
        ),
        backgroundColor: const Color(0xFFFEE500),
        minimumSize: const Size(widthButton, heightButton),
        side: const BorderSide(color: Color(0xFFFEE500), width: 1.5),
        elevation: 0,
      ),
      onPressed: () async {
        kakaoToken = await kakaoAuth(kakaoToken);
        if (kakaoToken.token != "") {
          KakaoProvider kakaoProvider = KakaoProvider();
          if (kakaoToken.isExistUser) {
            kakaoProvider.login(
                KakaoLoginRequest(kakaoToken: kakaoToken.token)).then((value) =>
            {
              Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => KakaoSplashScreen(token: value.tokenResponse!.accessToken))))
            });

          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: ((context) => KakaoSignUp()))
            );
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'lib/assets/kakaotalk_logo.png',
            height: 24.0,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
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