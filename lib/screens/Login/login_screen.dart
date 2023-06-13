import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/screens/Login/find_id_password.dart';

import '../../constants.dart';
import '../../http/dto.dart';
import '../../http/request.dart';
import '../../models/user_attribute.dart';
import '../Home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreen_ createState() => LoginScreen_();
}

class LoginScreen_ extends State<LoginScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  final validPW = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
  // RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"); //for test
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController emailInputController = TextEditingController();
  TextEditingController PWInputController = TextEditingController();

  void showLoginErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("로그인"),
            content: const Text("이메일 또는 비밀번호가 올바르지 않습니다."),
            actions: [
              TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: const Text("확인"))
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    UserAttribute? userAttribute = Provider.of<UserAttribute?>(context);

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
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: marginHorizontalHeader),
                child: const Text(
                  '돌아오신 것을 환영합니다 :)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: fontSizeHeader,
                      color: defaultColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: const EdgeInsets.only(
                            left: marginHorizontalHeader,
                            bottom: marginVerticalBetweenWidgets),
                        child: const Text('이메일',
                            style: TextStyle(
                                fontSize: fontSizeTextForm,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.left),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            left: marginHorizontalHeader,
                            right: marginHorizontalHeader),
                        child: TextFormField(
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '입력칸을 채워주세요.';
                            }
                            if (!validEmail
                                .hasMatch(emailInputController.text)) {
                              return '잘못된 이메일 형식입니다.';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: fontSizeInputText),
                          decoration: const InputDecoration(
                            hintText: 'username@email.com',
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width: 1.4, color: Color(0xFF6667AB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width: 1.4, color: Color(0xFF6667AB)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width: 1.4, color: Color(0x0F6A6B92)),
                            ),
                          ),
                          controller: emailInputController,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              bottom: marginVerticalBetweenWidgets),
                          child: const Text('비밀번호',
                              style: TextStyle(
                                  fontSize: fontSizeTextForm,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: marginHorizontalHeader,
                              right: marginHorizontalHeader),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '입력칸을 채워주세요.';
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: fontSizeInputText),
                            decoration: const InputDecoration(
                              hintText: 'password',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                borderSide: BorderSide(
                                    width: 1.4, color: Color(0xFF6667AB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                borderSide: BorderSide(
                                    width: 1.4, color: Color(0xFF6667AB)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                borderSide: BorderSide(
                                    width: 1.4, color: Color(0x0F6A6B92)),
                              ),
                            ),
                            obscureText: true,
                            controller: PWInputController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: marginHorizontalHeader,
                        bottom: marginVerticalBetweenWidgets,
                        right: marginHorizontalHeader),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: fontSizeButton),
                        backgroundColor: defaultColor,
                        minimumSize: const Size(widthButton, heightButton),
                      ),
                      onPressed: () async {
                        if (!validEmail.hasMatch(emailInputController.text)) {
                          showLoginErrorDialog(context);
                          return;
                        }

                        if (!validPW.hasMatch(PWInputController.text)) {
                          showLoginErrorDialog(context);
                          return;
                        }

                        if (!formGlobalKey.currentState!.validate()) {
                          showLoginErrorDialog(context);
                          return;
                        }

                        print("[debug]: LoginRequest Start");
                        LoginRequest loginRequest = LoginRequest(
                            email: emailInputController.text,
                            password: PWInputController.text);
                        String url = '${baseUrl}user/login';
                        print("[debug]: LoginRequest fin");
                        print("[debug]: Login Start");
                        await Login(url, loginRequest).then((value) async {
                          tokenResponse.accessToken =
                              value.tokenResponse?.accessToken;
                          tokenResponse.refreshToken =
                              value.tokenResponse?.refreshToken;

                          userAttribute?.email = value.email!;
                          userAttribute?.name = value.name!;
                          userAttribute?.nickname = value.nickname!;
                          if (value.gender == 'MALE') {
                            userAttribute?.gender = true;
                          }
                          if (value.gender == 'FEMALE') {
                            userAttribute?.gender = false;
                          }

                          userAttribute?.birthDate =
                              DateTime.parse(value.birthday!);

                          userAttribute?.profileImage = value.profileImage!;
                          // getPictureList
                          url = '${baseUrl}picture/list';

                          try {
                            print('Success loading picture list: ${userAttribute?.profileImage}');
                            // If profileIMG is not an empty string
                            if (userAttribute?.profileImage != "") {
                              // Make the asynchronous call to getPictureObject
                              url = '${baseUrl}picture';
                              try {
                                await getPictureObject(url, userAttribute?.profileImage, tokenResponse.accessToken);
                                print('Success loading picture object.');
                              } catch (e) {
                                print('Failed to load picture object: $e');
                              }
                            }
                          } catch (e) {
                            print('Failed to load picture list: $e');
                          }
                          print('[debug]profileIMG:${userAttribute?.profileImage}');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: ((context) =>
                                    HomeScreen(token: tokenResponse.accessToken))),
                                (_) => false,
                          );

                        }, onError: (err) {
                          showLoginErrorDialog(context);
                        });
                      },
                      child: const Text('로그인'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: marginHorizontalHeader,
                        bottom: marginVerticalBetweenWidgets,
                        right: marginHorizontalHeader),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: fontSizeButton, color: Colors.black,fontWeight: FontWeight.bold),
                        backgroundColor: Colors.white,
                        minimumSize: const Size(widthButton, heightButton),
                        side: const BorderSide(color: defaultColor, width: 1.0),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => FindIDPW())));
                      },
                      child: const Text('이메일 찾기·비밀번호 재설정',
                          style: TextStyle(color: defaultColor)),
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
