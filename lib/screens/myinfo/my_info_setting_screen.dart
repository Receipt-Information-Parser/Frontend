import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../http/dto.dart';
import '../../../constants.dart';
import '../../../http/request.dart';
import '../../../models/current_index.dart';
import '../../../models/user_attribute.dart';
import '../../../providers/user_attribute_api.dart';
import '../Home/home_screen.dart';
import 'my_info_screen.dart';

class MyInfoSettingScreen extends StatefulWidget {
  @override
  _MyInfoSettingScreenState createState() => _MyInfoSettingScreenState();
}

class _MyInfoSettingScreenState extends State<MyInfoSettingScreen> {

  final validNickname = RegExp('[A-Za-z][A-Za-z0-9_]{3,29}');
  TextEditingController nicknameEditController = TextEditingController(
      text: UserAttributeApi.getUserAttribute()?.nickname ?? "");
  TextEditingController fieldEditController = TextEditingController(
      text: UserAttributeApi.getUserAttribute()?.field ?? "");

  bool nicknameEditisEnable = true;
  bool fieldEditisEnable = true;

  void showModifyErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("내 정보"),
            content: const Text("닉네임 또는 분야가 잘못 설정되었습니다."),
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
    final CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);
    UserAttribute? userAttribute = Provider.of<UserAttribute?>(context);

    String temp = userAttribute?.field as String;
    List<String> myLabelList = temp.split(' ');

    userAttribute ??= UserAttribute(
        email: "",
        nickname: "",
        name: "",
        field: "",
        gender: true,
        birthDate: DateTime(2022));

    print("[debug] accessToken: ${tokenResponse.accessToken}");
    print("[debug] refreshToken: ${tokenResponse.refreshToken}");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
          child: Text(
            '내 정보',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () async {
              // make new attr instance
              UserAttributeApi.resetNickname(nicknameEditController.text);

              // call api to apply updated attrs to userinfo
              ModifyRequest modifyRequest = ModifyRequest(
                nickname: UserAttributeApi.userAttribute?.nickname,
              );

              String url = '${baseUrl}user/modify';

              // go to myinfo
              await modifyNickname(url, modifyRequest, tokenResponse.accessToken).then(
                  (value) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => MyInfoScreen())));
              }, onError: (err) {
                showModifyErrorDialog(context);
              });
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, top: 8, right: 8, bottom: 8),
                child: Text(
                  userAttribute.name,
                  style: const TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ), //name
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, top: 8, right: 8, bottom: 8),
                child: Text(
                  DateFormat("yyyy.MM.dd").format(userAttribute.birthDate),
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ), //birth
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, top: 8, right: 8, bottom: 8),
                child: Text(
                  userAttribute.email,
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 8,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 50, top: 8, right: 8, bottom: 8),
                child: Text(
                  '닉네임',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.052)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
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
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(4)),
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
                //   // 영수증 추가화면 merge
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
