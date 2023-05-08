import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/models/current_index.dart';

import '../../../http/dto.dart';
import '../../../models/user_attribute.dart';
import '../../../providers/user_attribute_api.dart';
import '../Home/home_screen.dart';
import 'my_info_setting_screen.dart';

class MyInfoScreen extends StatefulWidget {
  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  // dummy data
  String dummyName = '정우섭';
  DateTime dummyBirth = DateTime.now();
  String dummyEmail = 'example@naver.com';
  String dummyNickname = '우끼끼맨';

  final validNickname = RegExp('[A-Za-z][A-Za-z0-9_]{3,29}');
  TextEditingController nicknameEditController = TextEditingController(
      text: UserAttributeApi.getUserAttribute()?.nickname ?? "");
  bool nicknameEditisEnable = false;

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    UserAttribute? userAttribute = Provider.of<UserAttribute?>(context);
    CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);

    String temp = userAttribute?.field as String;
    List<String> myLabelList = temp.split(' ');

    userAttribute = UserAttributeApi.getUserAttribute();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          child: AppBar(
            centerTitle: true,
            title: const Text(
              '환경설정',
              style: TextStyle(
                fontSize: fontSizeAppbarTitle,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 내 정보
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 1,
            indent: 1,
            endIndent: 1,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
              left: marginHorizontalHeader,
            ),
            child: const Text("내 정보",
                style: TextStyle(
                    fontSize: fontSizeMiddle,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.left),
          ),
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 1,
            indent: 1,
            endIndent: 1,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 프로필 이미지
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 이름
                      Text(dummyName, style: const TextStyle(fontSize: fontSizeMiddle,color: Colors.black, fontWeight: FontWeight.bold)),
                      // 생년월일
                      Text(DateFormat('yyyy/MM/dd').format(dummyBirth), style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  //이메일
                  Text(dummyEmail, style: const TextStyle(fontSize: fontSizeSmallfont,color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 닉네임 text
                      const Text('닉네임', style: TextStyle(fontSize: fontSizeInputText,color: Colors.black, fontWeight: FontWeight.bold)),
                      // 실제 닉네임
                      Text(dummyNickname, style: const TextStyle(fontSize: fontSizeSmallfont,color: Colors.black)),
                      Icon(Icons.edit)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '닉네임',
                        style: TextStyle(
                            fontSize: fontSizeMiddle,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '입력칸을 채워주세요.';
                          }
                          if (!validNickname.hasMatch(nicknameEditController.text)) {
                            return '잘못된 닉네임 형식입니다. 최소 4자리를 입력해주세요.';
                          }
                          return null;
                        },
                        controller: nicknameEditController,
                        enabled: nicknameEditisEnable,
                      ),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              if (nicknameEditisEnable) {
                                nicknameEditisEnable = false;
                              } else {
                                nicknameEditisEnable = true;
                              }
                            });
                          })
                    ],
                  ),
                ],
              )
            ],
          ),

          // 전체 기록 저장
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 1,
            indent: 1,
            endIndent: 1,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
              left: marginHorizontalHeader,
            ),
            child: const Text("전체 기록 저장",
                style: TextStyle(
                    fontSize: fontSizeMiddle,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.left),
          ),
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 1,
            indent: 1,
            endIndent: 1,
          ),
          // 엑셀로 저장하기
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: marginHorizontalHeader,
                bottom: marginVerticalBetweenWidgets),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: fontSizeButton,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                backgroundColor: Colors.white,
                minimumSize: const Size(widthDownloadButton, heightButton),
                side: const BorderSide(color: defaultColor, width: 1.0),
                elevation: 0,
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const HomeScreen())));
              },
              child:
                  const Text('엑셀로 저장하기', style: TextStyle(color: defaultColor)),
            ),
          ),
          // 분석 자료 사진으로 저장하기
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: marginHorizontalHeader,
                bottom: marginVerticalBetweenWidgets),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: fontSizeButton,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                backgroundColor: Colors.white,
                minimumSize: const Size(widthDownloadButton, heightButton),
                side: const BorderSide(color: defaultColor, width: 1.0),
                elevation: 0,
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const HomeScreen())));
              },
              child: const Text('분석 자료 사진으로 저장하기',
                  style: TextStyle(color: defaultColor)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "공모전"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "내정보"),
        ],
        currentIndex: currentIndex.index,
        selectedItemColor: const Color(0xFF6667AB),
        onTap: ((value) {
          setState(() {
            currentIndex.setCurrentIndex(value);
            switch (currentIndex.index) {
              case 0:
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: ((context) {
                  return HomeScreen();
                })));
                break;

              case 1:
                // Navigator.of(context)
                //     .pushReplacement(MaterialPageRoute(builder: ((context) {
                //       //영수증 추가화면 merge
                // })));
                break;

              case 2:
                break;
            }
          });
        }),
      ),
    );
  }
}
