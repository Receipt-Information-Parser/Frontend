import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rip_front/constants.dart';

import '../../../providers/user_attribute_api.dart';

class FindIDPW extends StatelessWidget {
  FindIDPW({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final validNickname = RegExp('[A-Za-z][A-Za-z0-9_]{3,29}');
  TextEditingController emailInputController = TextEditingController();
  TextEditingController nicknameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(left: marginHorizontalHeader),
                      child: const Text("이메일 찾기",
                          style: TextStyle(
                              fontSize: fontSizeHeader,
                              color: defaultColor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              bottom: marginVerticalBetweenWidgets),
                          child: const Text("닉네임",
                              style: TextStyle(
                                  fontSize: fontSizeTextForm,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              right: marginHorizontalHeader),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (!validNickname
                                  .hasMatch(nicknameInputController.text)) {
                                return '잘못된 닉네임 형식입니다.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Nickname',
                            ),
                            style: const TextStyle(
                                fontSize: fontSizeInputText,
                                color: Colors.black),
                            controller: nicknameInputController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSizeButton),
                            backgroundColor: defaultColor,
                            minimumSize: const Size(WidthButton, HeightButton),
                          ),
                          onPressed: () {
                            // 화면 전환 (닉네임 존재시 이메일 출력, 닉네임 부재시 Error message 출력)
                            _showdialog_id(context);
                          },
                          child: const Text('계속하기')),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(left: marginHorizontalHeader),
                      child: const Text("비밀번호 재설정",
                          style: TextStyle(
                              fontSize: fontSizeHeader,
                              color: defaultColor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              bottom: marginVerticalBetweenWidgets),
                          child: const Text("이메일",
                              style: TextStyle(
                                  fontSize: fontSizeTextForm,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              right: marginHorizontalHeader),
                          child: TextFormField(
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (!validEmail
                                  .hasMatch(emailInputController.text)) {
                                return '잘못된 이메일 형식입니다.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'email',
                            ),
                            style: const TextStyle(
                                fontSize: fontSizeInputText,
                                color: Colors.black),
                            controller: emailInputController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSizeButton),
                            backgroundColor: defaultColor,
                            minimumSize: const Size(WidthButton, HeightButton),
                          ),
                          onPressed: () {
                            // 화면 전환 (이메일 존재시 비밀번호 재설정 창 출력, 이메일 부재시 Error message 출력)
                            _showdialog_id(context);
                          },
                          child: const Text('비밀번호 재설정')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// 팝업창 class
Future<dynamic> _showdialog_id(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('이메일 찾기'),
      content: Text('해당 닉네임의 이메일은 example@naver.com 입니다.'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('확인')),
      ],
    ),
  );
}
