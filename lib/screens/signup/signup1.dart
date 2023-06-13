import 'package:flutter/material.dart';
import 'package:rip_front/screens/signup/signup2.dart';

import '../../../constants.dart';
import '../../../http/dto.dart';
import '../../../http/request.dart';
import '../../../providers/user_attribute_api.dart';
import '../../../providers/user_auth_info_api.dart';

class Signin1 extends StatelessWidget {
  Signin1({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();
  final validPW =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pwInputController = TextEditingController();
  TextEditingController pwreInputController = TextEditingController();
  String vali = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body:
      Form(
        key: formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("환영합니다!",
                        style: TextStyle(
                            fontSize: fontSizeHeader,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("함께 해 주시겠어요?",
                        style: TextStyle(
                            fontSize: fontSizeHeader,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,bottom: marginVerticalBetweenWidgets),
                            child: const Text("이메일",
                                style: TextStyle(
                                    fontSize: fontSizeTextForm,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.left),
                          ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: Container(
                            height: 100,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,right: marginHorizontalHeader),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '입력칸을 채워주세요.';
                                }
                                if (!validEmail.hasMatch(emailInputController.text)) {
                                  return '이메일 형식이 잘못되었습니다.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'email'),
                              style: const TextStyle(
                                  fontSize: fontSizeInputText, color: Colors.black),
                              controller: emailInputController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    fit: FlexFit.loose,
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,bottom: marginVerticalBetweenWidgets),
                            child: const Text("비밀번호",
                                style: TextStyle(
                                    fontSize: fontSizeTextForm,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.left),
                          ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: Container(
                            height: 100,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader, right: marginHorizontalHeader),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '입력칸을 채워주세요.';
                                }
                                if (!validPW.hasMatch(pwInputController.text)) {
                                  return '영문자, 숫자, 특수문자를 포함한 8자리 이상의 비밀번호를 입력해주세요.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'password'),
                              style: const TextStyle(
                                  fontSize: fontSizeInputText, color: Colors.black),
                              obscureText: true,
                              controller: pwInputController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    fit: FlexFit.loose,
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,bottom: marginVerticalBetweenWidgets),
                            child: const Text("비밀번호 재확인",
                                style: TextStyle(
                                    fontSize: fontSizeTextForm,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.left),
                          ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            height: 100,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader, right: marginHorizontalHeader),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                vali = value as String;
                                if (value.isEmpty) {
                                  return '입력칸을 채워주세요.';
                                }
                                if (pwInputController.text.compareTo(vali) != 0) {
                                  return '비밀번호가 일치하지 않습니다.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'password',
                              ),
                              style: const TextStyle(
                                  fontSize: fontSizeInputText, color: Colors.black),
                              obscureText: true,
                              controller: pwreInputController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: fontSizeButton),
                    backgroundColor: defaultColor,
                    minimumSize: const Size(widthButton, heightButton),
                  ),
                  onPressed: () async {
                    if (formGlobalKey.currentState!.validate()) {
                      String url = '${baseUrl}user/existsEmail';
                      EmailRequest emailRequest =
                      EmailRequest(email: emailInputController.text);
                      MessageResponse emailResponse = await existsEmail(url, emailRequest);
                      print(emailResponse.message);
                      // "사용가능한 이메일입니다" 메시지가 아니라면 에러 다이얼로그 표시
                      if (emailResponse.message != "사용가능한 이메일입니다") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error", style: TextStyle(color: defaultColor),),
                              content: const Text("사용중인 계정입니다"),
                              actions: [
                                TextButton(
                                  child: const Text("Close", style: TextStyle(color: defaultColor),),
                                  onPressed: () {
                                      Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // 이메일 비밀번호 User 정보 수정 후
                        UserAttributeApi.resetEmail(emailInputController.text);
                        UserAuthInfoApi.resetEmail(emailInputController.text);
                        UserAuthInfoApi.resetPW(pwInputController.text);

                        // 화면 전환
                        if (context!.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: ((context) => Signin2())));
                        }
                      }
                    }
                  },
                  child: const Text('계속하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
