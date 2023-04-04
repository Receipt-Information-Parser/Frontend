import 'package:flutter/material.dart';
import 'package:rip_front/screens/signin/signin2.dart';

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
  final apiUrl = '${baseUrl}user/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("SimpleTeamUp과",
                    style: TextStyle(
                        fontSize: 28.0,
                        color: defaultColor,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: Text("함께 해주시겠어요?",
                    style: TextStyle(
                        fontSize: 28.0,
                        color: defaultColor,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("이메일",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                child: TextFormField(
                  onEditingComplete: () async {
                    String url = '${apiUrl}exist';
                    EmailRequest emailRequest =
                        EmailRequest(email: emailInputController.text);
                    EmailResponse emailResponse =
                        await Email(url, emailRequest);
                  },
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
                      fontSize: 15.0, height: 0.5, color: Colors.black),
                  controller: emailInputController,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text("비밀번호",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '입력칸을 채워주세요.';
                    }
                    if (!validPW.hasMatch(pwInputController.text)) {
                      return '영문자, 숫자, 특수문자를 모두 포함한 최소 8자리 암호를 입력해주세요.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'password'),
                  style: const TextStyle(
                      fontSize: 15.0, height: 0.5, color: Colors.black),
                  obscureText: true,
                  controller: pwInputController,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text("비밀번호 재확인",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
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
                      fontSize: 15.0, height: 0.5, color: Colors.black),
                  obscureText: true,
                  controller: pwreInputController,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: defaultColor,
                    minimumSize: const Size(350, 50),
                  ),
                  onPressed: () {
                    if (formGlobalKey.currentState!.validate()) {
                      // 이메일 비밀번호 User 정보 수정 후
                      UserAttributeApi.resetEmail(emailInputController.text);
                      UserAuthInfoApi.resetEmail(emailInputController.text);
                      UserAuthInfoApi.resetPW(pwInputController.text);

                      // 화면 전환
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => Signin2())));
                    }
                  },
                  child: const Text('계속하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
