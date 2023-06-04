import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants.dart';
import '../../http/dto.dart';
import '../../models/current_index.dart';
import '../../models/user_id.dart';
import '../Home/home_screen.dart';
import '../myinfo/my_info_screen.dart';
import 'DataAnalysis.dart';

class AnalysisChart2Screen extends StatefulWidget {

  const AnalysisChart2Screen({Key? key}) : super(key: key);

  @override
  _AnalysisChart2ScreenState createState() => _AnalysisChart2ScreenState();
}

class _AnalysisChart2ScreenState extends State<AnalysisChart2Screen> {

  _AnalysisChart2ScreenState();

  final scaffoldState = GlobalKey<ScaffoldState>();
  bool bottomSheetToggle = false;

  List<ByPeriod> data = [
    ByPeriod(date: DateTime.parse('2011-01-01'), amount: 113440, analysisId: 2),
    ByPeriod(date: DateTime.parse("2012-01-01"), amount: 200360, analysisId: 2),
    ByPeriod(date: DateTime.parse("2013-01-01"), amount: 265520, analysisId: 2),
    ByPeriod(date: DateTime.parse("2014-01-01"), amount: 113440, analysisId: 2),
    ByPeriod(date: DateTime.parse("2015-01-01"), amount: 200360, analysisId: 2),
    ByPeriod(date: DateTime.parse("2016-01-01"), amount: 265520, analysisId: 2),
    ByPeriod(date: DateTime.parse("2017-01-01"), amount: 113440, analysisId: 2),
    ByPeriod(date: DateTime.parse("2018-01-01"), amount: 200360, analysisId: 2),
    ByPeriod(date: DateTime.parse("2019-01-01"), amount: 265520, analysisId: 2),
  ];
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          width: data.length * 60.0,  // or another size
          child: SfCartesianChart(
            // Initialize category axis
            primaryXAxis: CategoryAxis(
              interval: 1,
            ),
            series: <ChartSeries>[
              ColumnSeries<ByPeriod, String>(
                dataSource: data,
                xValueMapper: (ByPeriod byPeriod, _) =>
                    DateFormat('yyyy').format(byPeriod.date),
                yValueMapper: (ByPeriod byPeriod, _) => byPeriod.amount,
                spacing: 0.5, // bar 간격설정
              )
            ],
          ),
        ),
      ),
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