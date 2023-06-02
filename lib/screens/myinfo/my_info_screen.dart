import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/request.dart';
import 'package:rip_front/models/current_index.dart';

import '../../../http/dto.dart';
import '../../../models/user_attribute.dart';
import '../../../providers/user_attribute_api.dart';
import '../Home/home_screen.dart';

class MyInfoScreen extends StatefulWidget {
  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  final validNickname = RegExp(r"^(?=.*[a-z0-9가-힣])[a-z0-9가-힣]{2,16}$");

  TextEditingController nicknameEditController = TextEditingController(
      text: UserAttributeApi.getUserAttribute()?.nickname ?? ""
  );

  bool nicknameEditisEnable = false;

  // 프로필 사진용
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
    UserAttribute? userAttribute = Provider.of<UserAttribute?>(context);
    CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);

    Future<ImageSource?> _showImageSourceDialog() async {
      return await showDialog<ImageSource>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Choose image source'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                  child: const Text('Camera'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                  child: const Text('Gallery'),
                ),
              ],
            );
          });
    }

    Future<ImageProvider<Object>> _currentImageProvider() async {
      final dir = await getExternalStorageDirectory();
      String filePath = '${dir!.path}/${userAttribute?.profileImage}';
      print('[debug]userAttribute.profileIMG:${userAttribute?.profileImage}');
      print('[debug]file path exists:${await File(filePath).exists()}');

      if (_imageFile != null) {
        // 사진 선택시 선택된 사진 savePicture로 서버에 저장
        String url = '${baseUrl}picture/save';
        print('[debug]accessToken:${tokenResponse.accessToken}');
        try {
          KeyResponse keyResponse = await savePicture(url, _imageFile!, tokenResponse.accessToken);
          print('[debug]Image saved successfully');
          // 선택한 사진으로 로컬 파일 저장 및 최신 경로 갱신
          final dir = await getExternalStorageDirectory();

          final String filePath = '${dir!.path}/${keyResponse.key}';
          userAttribute?.profileImage = keyResponse.key;
          // 복사하고자 하는 경로에 이미 파일이 존재하는 경우, 파일을 삭제한다.
          final File existingFile = File(filePath);
          if (await existingFile.exists()) {
            await existingFile.delete();
          }
          // 선택한 이미지 파일을 지정한 경로로 저장한다.
          await _imageFile?.copy(filePath);
        } catch (e, s) {
          print('[debug]Failed to save image: $e');
          print('Stack trace: $s');
        }
        // 선택된 이미지를 출력한다.
        return FileImage(_imageFile!);
      } else {
        if (userAttribute?.profileImage != "") {
          // 프로필 사진 존재 시, 기존 프로필 사진 출력
          return FileImage(File(filePath));
        } else {
          // 프로필 사진 없을 시, default image 출력
          return const AssetImage('lib/assets/profile/default_profile_icon.jpg');
        }
      }
    }

    Future<void> _chooseImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    }

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
              Spacer(),
              // Profile Picture UI
              InkWell(
                onTap: () async {
                  ImageSource? selectedSource = await _showImageSourceDialog();
                  if (selectedSource != null) {
                    _chooseImage(selectedSource);
                  }
                },
                child: FutureBuilder<ImageProvider>(
                  future: _currentImageProvider(),
                  builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: snapshot.data,
                      );
                    } else {
                      // While the image is loading, display a spinner
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),

              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 이름
                      Container(
                        child: Text((userAttribute?.name ?? ''), style: const TextStyle(
                            fontSize: fontSizeMiddle,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                      ),
                      // 생년월일
                      Container(
                        margin: EdgeInsets.only(left: marginHorizontalHeader),
                        child: Text(DateFormat('yyyy/MM/dd').format((userAttribute?.birthDate??DateTime.now())),
                            style: const TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  //이메일
                  Text((userAttribute?.email ?? ''), style: const TextStyle(
                      fontSize: fontSizeSmallfont, color: Colors.black)),
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
                      Container(
                        margin: EdgeInsets.only(left: marginHorizontalHeader),
                        child: Flexible(
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '입력칸을 채워주세요.';
                              }
                              if (!validNickname.hasMatch(
                                  nicknameEditController.text)) {
                                return '최소 2자리를 입력해주세요.';
                              }
                              // 중복확인
                              return null;
                            },
                            controller: nicknameEditController,
                            enabled: nicknameEditisEnable,
                          ),
                        ),
                        width: 100,
                      ),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            if (nicknameEditisEnable) {
                              // Check if the nickname already exists
                              String checkUrl = '${baseUrl}user/existsNickname';
                              NicknameRequest checkRequest = NicknameRequest(nickname: nicknameEditController.text);
                              MessageResponse checkResponse = await existsNickname(checkUrl, checkRequest);
                              if(checkResponse.message == '사용중인 닉네임입니다') {
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
                                print('[Error]: 닉네임이 이미 존재합니다.');
                                return; // If nickname exists, return from the function.
                              }

                              String url = '${baseUrl}user/modifyNickname';
                              ModifyRequest nicknameRequest = ModifyRequest(nickname: nicknameEditController.text);
                              UserResponse nicknameResponse = await modifyNickname(url, nicknameRequest, tokenResponse.accessToken);
                              if(nicknameResponse.nickname == nicknameEditController.text) {
                                // 수정된 닉네임으로 업데이트
                                UserAttributeApi.resetNickname((nicknameResponse.nickname ?? "Error"));
                              } else {
                                print('[Error]:닉네임이 제대로 변경되지 않았습니다.');
                              }
                              setState(() {
                                nicknameEditisEnable = false;
                              });
                            } else {
                              setState(() {
                                nicknameEditisEnable = true;
                              });
                            }
                          }
                      )
                    ],
                  ),
                ],
              ),
              const Spacer(),
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: ((context) =>
                          HomeScreen(token: tokenResponse.accessToken))),
                );
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: ((context) =>
                          HomeScreen(token: tokenResponse.accessToken))),
                );
              },
              child: const Text('분석 자료 사진으로 저장하기',
                  style: TextStyle(color: defaultColor)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "영수증 목록"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "영수증 추가"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
        ],
        currentIndex: currentIndex.index,
        selectedItemColor: defaultColor,
        onTap: ((value) {
          setState(() {
            currentIndex.setCurrentIndex(value);
            switch (currentIndex.index) {
              case 0:
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: ((context) =>
                          HomeScreen(token: tokenResponse.accessToken))),
                );
                break;

              case 1:
                break;

              case 2:
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: ((context) {
                  return MyInfoScreen();
                })));
                break;
            }
          });
        }),
      ),
    );
  }
}