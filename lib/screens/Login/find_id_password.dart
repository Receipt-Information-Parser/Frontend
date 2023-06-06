import 'package:flutter/material.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/request.dart';

import '../../http/dto.dart';

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
                      margin:
                          const EdgeInsets.only(left: marginHorizontalHeader),
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
                        Expanded(
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                const TextStyle(fontSize: fontSizeButton),
                            backgroundColor: defaultColor,
                            minimumSize: const Size(widthButton, heightButton),
                          ),
                          onPressed: () async{
                            String url = '${baseUrl}user/getNickname';
                            NicknameRequest nickNameRequest = NicknameRequest(nickname: nicknameInputController.text);
                            MessageResponse getEmailResponse = await getEmail(url, nickNameRequest);
                            final BuildContext dialogContext = context;
                            // "존재하지 않는 계정입니다" 메시지라면 에러 다이얼로그 표시
                            if (getEmailResponse.message == "존재하지 않는 계정입니다") {
                              _showdialog_noid(getEmailResponse,dialogContext);
                            } else {
                              // 화면 전환 (이메일이 존재한다는 메세지 출력)
                              _showdialog_id(nicknameInputController.text,getEmailResponse,dialogContext);
                            }
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
                      margin:
                          const EdgeInsets.only(left: marginHorizontalHeader),
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
                        Expanded(
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                const TextStyle(fontSize: fontSizeButton),
                            backgroundColor: defaultColor,
                            minimumSize: const Size(widthButton, heightButton),
                          ),
                          onPressed: () async{
                            String url = '${baseUrl}user/reset';
                            EmailRequest emailRequest = EmailRequest(email: emailInputController.text);
                            MessageResponse resetPWresponse = await resetPassword(url, emailRequest);
                            final BuildContext dialogContext = context;
                            // "존재하지 않는 계정입니다" 메시지라면 에러 다이얼로그 표시
                            if (resetPWresponse.message == "존재하지 않는 계정입니다") {
                              _showdialog_noid(resetPWresponse,dialogContext);
                            } else {
                              // 화면 전환 (이메일 존재시 비밀번호 재설정 창 출력, 이메일 부재시 Error message 출력)
                              _showdialog_password(dialogContext);
                            }
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
Future<dynamic> _showdialog_id(String nickname,MessageResponse Message,BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('이메일 찾기', style: TextStyle(color: defaultColor),),
      content: Text('$nickname의 아이디는${Message.message ?? 'Server Error'}입니다.'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('확인')),
      ],
    ),
  );
}
Future<dynamic> _showdialog_noid(MessageResponse Message,BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('이메일 찾기', style: TextStyle(color: defaultColor),),
      content: Text(Message.message ?? '서버 응답에 에러가 있습니다.'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('확인')),
      ],
    ),
  );
}

Future<dynamic> _showdialog_password(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('비밀번호 재설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Spacer(),
              Icon(Icons.lock_reset, size: 60), // Update size here
              Spacer(),
            ],
          ),
          const Text('등록된 이메일로 임시 비밀번호가 발송됩니다.'),
        ],
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              elevation: 0, // Update this line to set text color
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ok')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              elevation: 0, // Update this line to set text color
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('cancel')),
      ],
    ),
  );
}
