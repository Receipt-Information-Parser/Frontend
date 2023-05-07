import 'package:flutter/material.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/screens/Home/home_screen.dart';
import 'package:rip_front/screens/Login/kakaotalk_login_button.dart';
import 'package:rip_front/screens/signin/signin2.dart';
import 'package:rip_front/screens/signin/signin3.dart';

import '../myinfo/my_info_screen.dart';
import '../signin/signin1.dart';
import '../Login/login_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: marginHorizontalHeader),
                  child: const Text(
                    '영수증을 한번에 정리하는',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: fontSizeMiddle,
                        color: defaultColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: marginHorizontalHeader),
                  child: const Text(
                    'RIP에 오신 것을 환영합니다!',
                    style: TextStyle(
                        fontSize: fontSizeHeader,
                        color: defaultColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: marginHorizontalHeader),
                child: Center(
                  child: Image.asset(
                    'lib/assets/splash_logo.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                )),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: WidthButton,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      left: marginHorizontalHeader,
                      bottom: marginVerticalBetweenWidgets),
                  child: KakaoLoginButton(
                    onPressed: () {
                      // TODO: 카카오 로그인 처리를 구현
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      left: marginHorizontalHeader,
                      bottom: marginVerticalBetweenWidgets),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: fontSizeButton),
                      backgroundColor: defaultColor,
                      minimumSize: const Size(WidthButton, HeightButton),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => LoginScreen())));
                    },
                    child: const Text('로그인'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: marginHorizontalHeader),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: fontSizeButton, color: defaultColor),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(WidthButton, HeightButton),
                      side: BorderSide(color: defaultColor, width: 1.5),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => Signin1())));
                    },
                    child: const Text('회원가입',
                        style: TextStyle(color: defaultColor)),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
