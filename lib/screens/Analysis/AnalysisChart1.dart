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
import 'Functions/ConsumeOfitem.dart';

class AnalysisChart1Screen extends StatefulWidget {
  final List<ByProduct>? apiResponse;
  final String? item;

  const AnalysisChart1Screen({Key? key, this.apiResponse, this.item}) : super(key: key);

  @override
  _AnalysisChart1ScreenState createState() => _AnalysisChart1ScreenState();
}

class _AnalysisChart1ScreenState extends State<AnalysisChart1Screen> {

  _AnalysisChart1ScreenState();

  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<SfCartesianChartState>? chartKey = GlobalKey();

  bool bottomSheetToggle = false;

  List<ByProduct>? data;
  String? item;

  @override
  void initState() {
    super.initState();
    data = widget.apiResponse;
    item = widget.item;
  }

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
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => DataAnalysisScreen(token: tokenResponse.accessToken))
            ));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: consumeOfitem('품목별 소비 추이', ['$item'],context,chartKey:chartKey),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                width: (data?.length)! * 60.0,  // or another size
                child: SfCartesianChart(
                  key: chartKey,
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                  ),
                  series: <ChartSeries>[
                    LineSeries<ByProduct, String>(
                      dataSource: data!,
                      xValueMapper: (ByProduct byProduct, _) => DateFormat('yyyy-MM-DD').format(byProduct.date),
                      yValueMapper: (ByProduct byProduct, _) => byProduct.amount,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
          height: 70,
          width: 70,//Floating action button on Scaffold
          child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  if (bottomSheetToggle == false) {
                    bottomSheetToggle = true;
                    controller = scaffoldState.currentState?.showBottomSheet((context) => BottomSheetWidget(token: tokenResponse.accessToken,));
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