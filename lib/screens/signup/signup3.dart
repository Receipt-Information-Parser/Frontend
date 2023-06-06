import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../http/dto.dart';
import '../../../http/request.dart';
import '../../../models/user_attribute.dart';
import '../../../providers/user_attribute_api.dart';
import '../../../providers/user_auth_info_api.dart';
import '../Home/home_screen.dart';

const List<String> list = <String>['남자', '여자'];

class Signin3 extends StatefulWidget {
  const Signin3({super.key});

  @override
  Signin3_2 createState() => Signin3_2();
}

class Signin3_2 extends State<Signin3> {
  bool isSwitched = false;
  String gender_to_string(bool gender) {
    return gender ? "MALE" : "FEMALE";
  }

  DateTime date = DateTime.now();
  final formGlobalKey = GlobalKey<FormState>();
  final validBirth =
      RegExp('[0-9]{4}-(1[0-2]|0[1-9])-(3[01]|[12][0-9]|0[1-9])');
  TextEditingController birthInputController = TextEditingController();

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("이제 마지막 입니다.",
                        style: TextStyle(
                            fontSize: fontSizeHeader,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: const Text("수고하셨습니다!",
                        style: TextStyle(
                            fontSize: fontSizeHeader,
                            color: defaultColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader),
                            child: const Text('성별',
                                style: TextStyle(
                                    fontSize: fontSizeMiddle,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(left: marginHorizontalHeader),
                            child: const Text("생년월일",
                                style: TextStyle(
                                    fontSize: fontSizeMiddle,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ]
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: marginHorizontalHeader),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text("여성",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left),
                                    CupertinoSwitch(
                                        activeColor: Colors.blue,
                                        thumbColor: Colors.white,
                                        trackColor: Colors.red,
                                        value: isSwitched,
                                        onChanged: (value) => setState(() => isSwitched = value)),
                                    const Text("남성",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left),
                                  ],
                                ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
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
                                    firstDate: DateTime(1911),
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
                        ]
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
                    minimumSize: const Size(widthButton, heightButton),
                  ),
                  onPressed: () async {
                    // 성별, 생년월일 전달 후
                    UserAttributeApi.resetGender(isSwitched);
                    // debug
                    UserAttributeApi.show();

                    // 서버에 signin 요청 후
                    print('[debug]: Signin Request start');
                    SignUpRequest signupRequest = SignUpRequest(
                      birthday: DateFormat('yyyy-MM-dd')
                          .format(UserAttributeApi.userAttribute!.birthDate),
                      email: UserAuthInfoApi.userAuthInfo?.email,
                      gender: gender_to_string(
                          UserAttributeApi.userAttribute!.gender),
                      name: UserAttributeApi.userAttribute?.name,
                      nickname: UserAttributeApi.userAttribute?.nickname,
                      password: UserAuthInfoApi.userAuthInfo?.password,
                    );
                    print('[debug]: Signin Request end');
                    String url = '${baseUrl}user/signup';

                    // UserResponse로 password 변수 받을 수가 없음
                    await SignUp(url, signupRequest).then((value) {
                      print('[debug] future successful');

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

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: ((context) => HomeScreen(token: tokenResponse.accessToken))),
                            (_) => false,
                      );
                    }, onError: (err) {
                      print('[debug] future error: ${err.toString()}');

                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: const Text("회원가입"),
                              content: const Text(
                                  "중복되는 회원 정보가 이미 존재합니다.\n입력값을 확인 후 다시 시도해주세요."),
                              actions: [
                                TextButton(
                                    onPressed: (() {
                                      Navigator.pop(context);
                                    }),
                                    child: const Text("확인"))
                              ],
                            );
                          }));
                    });},
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

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.expand_more),
      elevation: 16,
      style: const TextStyle(color: Colors.black,
      fontSize: fontSizeTextForm),
      underline: Container(
        height: 2,
        color: defaultColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}