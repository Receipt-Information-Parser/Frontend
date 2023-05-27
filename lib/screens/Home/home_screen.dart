import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/screens/Login/login_screen.dart';

import '../../../http/dto.dart';
import '../../../models/current_index.dart';
import '../../../models/user_id.dart';
import '../myinfo/my_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}


class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 175,
        color: Color.fromRGBO(239, 243, 255, 100),
        //specify height, so that it does not fill the entire screen
        child: Column(
            children: [
              Expanded(child: Row()),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40),
                minVerticalPadding: 20,
                horizontalTitleGap: 20,
                title: const Text(
                    "영수증 촬영하기",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.black)
                ),
                leading: const Icon(Icons.camera_alt, size: 40,),
                onTap: () {
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40),
                minVerticalPadding: 20,
                horizontalTitleGap: 20,
                title: const Text(
                    "갤러리에서 영수증 찾기",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.black)
                ),
                leading: const Icon(Icons.photo, size: 40),
                onTap: () {
                },
              ),
            ]
        ) //what you want to have inside, I suggest using a column
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isChecked = false;

  final List<String> datas = [
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
    DateFormat('yyyy년 MM월 dd일 kk:mm').format(DateTime.now()),
  ];

  final scaffoldState = GlobalKey<ScaffoldState>();
  bool bottomSheetToggle = false;

  @override
  Widget build(BuildContext context) {

    PersistentBottomSheetController? _controller;

    final CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);
    UserId userId = Provider.of<UserId>(context);

    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldState,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          child: AppBar(
            title: const Text("영수증 목록",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            backgroundColor: defaultColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              height: 50,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                    datas[index],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                    )),
                              )
                          ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: IconButton(
                            onPressed: () {
                              // DOWNLOAD
                            },
                            icon: const Icon(Icons.download)
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                datas.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete)
                        )
                      )
                    ]
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(
                thickness: 2,
              ),
              itemCount: datas.length
          ))
        ],
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,//Floating action button on Scaffold
        child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                if (bottomSheetToggle == false) {
                  _controller = scaffoldState.currentState?.showBottomSheet((context) => const BottomSheetWidget());
                  bottomSheetToggle = true;
                } else {
                  _controller?.close();
                  bottomSheetToggle = false;
                }
              },
              child: Icon(Icons.add, size: 40), //icon inside button
      ))),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
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
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: ((context) {
                  return const HomeScreen();
                })));
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
