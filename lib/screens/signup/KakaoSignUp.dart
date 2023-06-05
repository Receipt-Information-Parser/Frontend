import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/dto.dart';
import 'package:rip_front/http/dto/KakaoRequest.dart';
import 'package:rip_front/http/request.dart';
import 'package:rip_front/http/request/KakaoProvider.dart';
import 'package:rip_front/models/kakao_token.dart';

import '../../../providers/user_attribute_api.dart';
import '../Home/home_screen.dart';
import 'signup3.dart';

class KakaoSignUp extends StatefulWidget {

  const KakaoSignUp({super.key});

  @override
  KakaoSignUpState createState() => KakaoSignUpState();
}

class KakaoSignUpState extends State<KakaoSignUp> {

  final formGlobalKey = GlobalKey<FormState>();
  final validNickname = RegExp(r"^(?=.*[a-z0-9가-힣])[a-z0-9가-힣]{2,16}$");
  TextEditingController nicknameInputController = TextEditingController();

  DateTime date = DateTime.now();
  final validBirth =
  RegExp('[0-9]{4}-(1[0-2]|0[1-9])-(3[01]|[12][0-9]|0[1-9])');
  TextEditingController birthInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    KakaoToken kakaoToken = Provider.of<KakaoToken>(context);
    String token = kakaoToken.token;
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
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("가입을 위해\n간단한 추가정보가 필요합니다",
                        style: TextStyle(
                            fontSize:28,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("\n닉네임과 생일을 입력해주세요.",
                        style: TextStyle(
                            fontSize: 25,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [ Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,bottom: marginVerticalBetweenWidgets),
                            child: const Text("닉네임",
                                style: TextStyle(
                                    fontSize: fontSizeTextForm,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.left),
                          ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,right: marginHorizontalHeader),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '입력칸을 채워주세요.';
                                }
                                if (!validNickname.hasMatch(nicknameInputController.text)) {
                                  return '잘못된 닉네임 형식입니다. 최소 2자리를 입력해주세요.';
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
                                  fontSize: fontSizeInputText, color: Colors.black),
                              controller: nicknameInputController,
                            ),
                          ),
                        ),
                         Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,bottom: marginVerticalBetweenWidgets),
                            child: const Text("생일",
                                style: TextStyle(
                                    fontSize: fontSizeTextForm,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.left),
                          ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader,right: marginHorizontalHeader),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: fontSizeButton),
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: defaultColor,
                                  width: 2,
                                ),
                              ),
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    date = selectedDate;
                                    UserAttributeApi.resetBirthdate(date);  // 선택된 날짜를 UserAttributeApi에 전달
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('yy-MM-dd').format(date),
                                style: const TextStyle(
                                  fontSize: fontSizeTextForm,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
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
                      if (formGlobalKey.currentState!.validate()) {
                        String url = '${baseUrl}user/existsNickname';
                        String nickname = nicknameInputController.text;
                        NicknameRequest nickNameRequest = NicknameRequest(nickname: nickname);
                        MessageResponse nickNameResponse = await existsNickname(url, nickNameRequest);
                        print(nickNameResponse.message);
                        if (nickNameResponse.message != "사용가능한 닉네임입니다") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error", style: TextStyle(color: defaultColor),),
                                content: const Text("사용중인 닉네임입니다"),
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
                              KakaoSignUpRequest kakaoSignUpRequest = KakaoSignUpRequest(kakaoToken: token, nickname: nickname, birthday: DateFormat('yyyy-MM-dd')
                                  .format(date),);
                              UserResponse userResponse = await KakaoProvider().signUp(kakaoSignUpRequest);
                              tokenResponse = userResponse.tokenResponse!;
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: ((context) => HomeScreen(token: tokenResponse.accessToken))));
                        }
                      }
                    },
                    child: const Text('카카오로 가입하기', style: TextStyle(color: Colors.black),),),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
