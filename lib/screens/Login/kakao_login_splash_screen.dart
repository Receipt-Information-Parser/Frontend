import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/dto.dart';

import '../Home/home_screen.dart';

class KakaoSplashScreen extends StatelessWidget {
  final String? token;

  KakaoSplashScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    tokenResponse.accessToken = token;

    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => HomeScreen(token: tokenResponse.accessToken))));
    });

    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFEE500), Color(0xFFFEE9C4), Color(0xFFFFFDE7), Color(0xFFFFFEEE), Colors.white, Colors.white, Colors.white
                    ]
                )),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'lib/assets/kakaotalk_logo.png',
                    height: 32.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
                    child: Text(
                      '카카오로 로그인합니다',
                      style: TextStyle(
                          fontSize: fontSizeHeader - 10,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          )

    );
  }
}
