import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../http/dto.dart';
import '../../models/current_index.dart';
import '../../models/user_id.dart';
import '../Home/home_screen.dart';
import '../myinfo/my_info_screen.dart';
import 'DataAnalysis.dart';

class AnalysisChart1Screen extends StatefulWidget {

  const AnalysisChart1Screen({Key? key}) : super(key: key);

  @override
  _AnalysisChart1ScreenState createState() => _AnalysisChart1ScreenState();
}

class _AnalysisChart1ScreenState extends State<AnalysisChart1Screen> {

  _AnalysisChart1ScreenState();

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
      appBar: AppBar(
        centerTitle: true, // 제목을 가운데 정렬
        title: const Text('상세 내역'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => DataAnalysisScreen(token: tokenResponse.accessToken))
            ));
          },
        ),
      ),
      body: Container(color: Colors.red,),
      floatingActionButton: Container(
          height: 70,
          width: 70,//Floating action button on Scaffold
          child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  if (bottomSheetToggle == false) {
                    bottomSheetToggle = true;
                    _controller = scaffoldState.currentState?.showBottomSheet((context) => BottomSheetWidget(token: tokenResponse.accessToken,));
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