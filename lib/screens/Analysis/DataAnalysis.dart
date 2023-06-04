import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/dto/ReceiptResponse.dart';
import 'package:rip_front/http/request/ReceiptProvider.dart';
import 'package:rip_front/screens/Detail/detail.dart';

import '../../../http/dto.dart';
import '../../../models/current_index.dart';
import '../../../models/user_id.dart';
import '../Home/home_screen.dart';
import '../myinfo/my_info_screen.dart';
import 'Functions/ConsumeCostByPeriod.dart';
import 'Functions/ConsumeOfitem.dart';

/// //////////////////////////////////////////////////////////////////////////
/// Dummy APIs ///////////////////////////////////////////////////////////////

class ByPeriod {

  final DateTime date;
  final int amount;
  final int analysisId;

  ByPeriod({
    required this.date,
    required this.amount,
    required this.analysisId,
  });

  factory ByPeriod.fromJson(Map<String, dynamic> json) {
    return ByPeriod(
      date: json['date'],
      amount: json['amount'],
      analysisId: json['analysisId'],
    );
  }
}

class ByProduct {
  final String name;
  final int amount;
  final int analysisId;
  final DateTime date;

  ByProduct({
    required this.name,
    required this.amount,
    required this.analysisId,
    required this.date,
  });

  factory ByProduct.fromJson(Map<String, dynamic> json) {
    return ByProduct(
      name: json['name'],
      amount: json['amount'],
      analysisId: json['analysisId'],
      date: json['date'],
    );
  }
}


Future<List<ByProduct>?> getByName(String name) async {
  // Call API and get data by name
  // return data as String or any other format you want
}

Future<List<ByPeriod>?> getByYear() async {
  // Call API and get data by year
  // return data as String or any other format you want
}

Future<List<ByPeriod>?> getByMonth() async {
  // Call API and get data by month
  // return data as String or any other format you want
}


/// Dummy APIs ///////////////////////////////////////////////////////////////
/// //////////////////////////////////////////////////////////////////////////

class DataAnalysisScreen extends StatefulWidget {
  final String? token;

  const DataAnalysisScreen({Key? key, required this.token}) : super(key: key);

  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState(token!);
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
  // token을 받아 사용자별 품목리스트 API 호출
  final String token;

  _DataAnalysisScreenState(this.token);

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
        title: const Text('기록 분석'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => MyInfoScreen())
            ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: consumeCostByPeriod('기간별 소비 금액', ['연도별', '월별'],context),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // 품목리스트은 실제 사용되는 품목리스트로 변경
                children: consumeOfitem('품목별 소비 추이', ['품목1', '품목2'],context),
              ),
            )
          ],
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
                    _controller = scaffoldState.currentState?.showBottomSheet((context) => BottomSheetWidget(token: token,));
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