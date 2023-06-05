
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';

import '../../../http/dto.dart';
import '../../../models/current_index.dart';
import '../../../models/user_id.dart';
import '../../http/request.dart';
import '../Home/home_screen.dart';
import '../myinfo/my_info_screen.dart';
import 'Functions/ConsumeCostByPeriod.dart';
import 'Functions/ConsumeOfitem.dart';

class DataAnalysisScreen extends StatefulWidget {
  final String? token;

  const DataAnalysisScreen({Key? key, required this.token}) : super(key: key);

  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState(token!);
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
  // token을 받아 사용자별 품목리스트 API 호출
  final String token;
  final String getNamesUrl = '${baseUrl}analysis/names';
  _DataAnalysisScreenState(this.token);

  final scaffoldState = GlobalKey<ScaffoldState>();
  bool bottomSheetToggle = false;

  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController? controller;

    final CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);
    UserId userId = Provider.of<UserId>(context);

    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldState,
      appBar: AppBar(
        centerTitle: true, // 제목을 가운데 정렬
        title: const Text('기록 분석'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => const MyInfoScreen())));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: consumeCostByPeriod('기간별 소비 금액', context),
              ),
            ),
            FutureBuilder<List<String>>(
              future: getNames(getNamesUrl,tokenResponse.accessToken),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // while data is loading
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: consumeOfitem('품목별 소비 추이', snapshot.data!, context),
                    ); // data loaded
                  }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
          height: 70,
          width: 70, //Floating action button on Scaffold
          child: FittedBox(
              child: FloatingActionButton(
            onPressed: () {
              if (bottomSheetToggle == false) {
                bottomSheetToggle = true;
                controller = scaffoldState.currentState
                    ?.showBottomSheet((context) => BottomSheetWidget(
                          token: token,
                        ));
              } else {
                controller?.close();
                bottomSheetToggle = false;
              }
            },
            child: const Icon(Icons.add, size: 40), //icon inside button
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
                  return const MyInfoScreen();
                })));
                break;
            }
          });
        }),
      ),
    );
  }
}
