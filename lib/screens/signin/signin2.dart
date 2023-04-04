import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rip_front/constants.dart';

import '../../../providers/user_attribute_api.dart';
import 'signin3.dart';

class Signin2 extends StatelessWidget {
  Signin2({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();
  final validName = RegExp(r"^[가-힣]{2,4}$");
  final validNickname = RegExp('[A-Za-z][A-Za-z0-9_]{3,29}');
  TextEditingController nameInputController = TextEditingController();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("거의 다 왔습니다.",
                  style: TextStyle(
                      fontSize: 28.0,
                      color: defaultColor,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Text("조금만 힘내세요!",
                  style: TextStyle(
                      fontSize: 28.0,
                      color: defaultColor,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 50),
              child: Text("닉네임",
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
                  if (!validNickname.hasMatch(nicknameInputController.text)) {
                    return '잘못된 닉네임 형식입니다. 최소 4자리를 입력해주세요.';
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
                    fontSize: 15.0, height: 0.5, color: Colors.black),
                controller: nicknameInputController,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text("이름",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|·|：]'),
                      allow: true)
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '입력칸을 채워주세요.';
                  }
                  if (!validName.hasMatch(nameInputController.text)) {
                    return '잘못된 이름 형식입니다.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Name',
                ),
                style: const TextStyle(
                    fontSize: 15.0, height: 0.5, color: Colors.black),
                controller: nameInputController,
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
                      // 닉네임 이름 수정 후
                      UserAttributeApi.resetNickname(
                          nicknameInputController.text);
                      UserAttributeApi.resetName(nameInputController.text);
                      // 화면 전환
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => Signin3())));
                    }
                  },
                  child: const Text('계속하기')),
            )
          ],
        ),
      ),
    ));
  }
}
