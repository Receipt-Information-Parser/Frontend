
import 'package:flutter/material.dart';
import 'package:rip_front/constants.dart';

import '../signin/signin1.dart';
import 'login_screen.dart';



class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          const Padding(padding: EdgeInsets.fromLTRB(30, 16, 30, 16)),
          Column(
            children: [
              const Padding(padding: EdgeInsets.all(60)),
              Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "팀원을 찾는 가장 쉬운 방법",
                  style: TextStyle(
                      fontSize: 28.0,
                      color: defaultColorBlue,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Simple",
                  style: TextStyle(
                      fontSize: 55,
                      color: defaultColorBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "TeamUp",
                  style: TextStyle(
                      fontSize: 55,
                      color: defaultColorBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 200.0,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
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
                    padding: const EdgeInsets.all(16.0),
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
        ]));
  }
}