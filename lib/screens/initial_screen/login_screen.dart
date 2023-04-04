import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../http/dto.dart';
import '../../http/request.dart';
import '../../models/user_attribute.dart';
import '../Home/home_screen.dart';
import '../signin/signin1.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreen_ createState() => LoginScreen_();
}

class LoginScreen_ extends State<LoginScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  final validPW =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
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
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                  '돌아오신 것을 환영합니다 :)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: defaultColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(left: 20),
                          child: const Text('이메일',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '입력칸을 채워주세요.';
                              }
                              if (!validEmail
                                  .hasMatch(emailInputController.text)) {
                                return '이메일 양식이 잘못되었습니다.';
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 16),
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
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 20),
                          child: const Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '입력칸을 채워주세요.';
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 16),
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
                children: [
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: defaultColor,
                          minimumSize: const Size(350, 50),
                        ),
                        onPressed: () async {
                          if (validEmail.hasMatch(emailInputController.text)) {
                            if (validPW.hasMatch(PWInputController.text)) {
                              if (formGlobalKey.currentState!.validate()) {
                                LoginRequest loginRequest = LoginRequest(
                                    email: emailInputController.text,
                                    password: PWInputController.text);
                                String url = '${baseUrl}user/login';

                                await Login(url, loginRequest).then((value) {
                                  tokenResponse.accessToken =
                                      value.tokenResponse?.accessToken;
                                  tokenResponse.refreshToken =
                                      value.tokenResponse?.refreshToken;

                                  userAttribute?.email = value.email!;
                                  userAttribute?.name = value.name!;
                                  if (value.gender == 'MALE') {
                                    userAttribute?.gender = true;
                                  }
                                  if (value.gender == 'FEMALE') {
                                    userAttribute?.gender = false;
                                  }

                                  userAttribute?.birthDate =
                                      DateTime.parse(value.birthday!);
                                  userAttribute?.nickname = value.nickname!;

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              HomeScreen())));
                                }, onError: (err) {
                                  showLoginErrorDialog(context);
                                });
                              } else {
                                showLoginErrorDialog(context);
                              }
                            } else {
                              showLoginErrorDialog(context);
                            }
                          } else {
                            showLoginErrorDialog(context);
                          }
                        },
                        child: const Text('로그인'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => Signin1())));
                        },
                        child: const Text(
                          '가입하시겠습니까?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: defaultColor),
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
    ));
  }
}
