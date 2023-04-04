import 'package:flutter/material.dart';
import 'package:rip_front/constants.dart';

import '../signin/signin1.dart';
import 'login_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    '영수증을 한번에 정리하는',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: defaultColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'RIP에 오신 것을 환영합니다!',
                    style: TextStyle(
                        fontSize: 30,
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
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => LoginScreen())));
                    },
                    child: const Text('로그인'),
                  ),
                ),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: ((context) => Signin1())));
                    },
                    child: const Text(
                      '가입하시겠습니까?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
