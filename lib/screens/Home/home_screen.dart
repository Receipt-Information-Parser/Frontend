import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/http/dto/ReceiptResponse.dart';
import 'package:rip_front/http/request/ReceiptProvider.dart';

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
  bool isLoading = true;

  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1aWQiOjEsInN1YiI6InJlY2VpcHRtYXRlSnd0IiwiYXRoIjpudWxsLCJlbWwiOiJjaGFuaG8wMzA5QGdtYWlsLmNvbSIsImV4cCI6MTY4NTI2NTM1MywiaWF0IjoxNjg1MjYzNTUzfQ.u9LJZgRizeWRe0xsDbVMPzE3Cl4gmnjvL1p0_dCW77WU5M5fCOXV86Nb0NEbAo3f5O9EPwa8BzFeWNGzdNKl-Q";
  late ListReceiptResponses receipts;
  ReceiptProvider receiptProvider = ReceiptProvider('${baseUrl}receipt/list');

  final scaffoldState = GlobalKey<ScaffoldState>();
  bool bottomSheetToggle = false;

  Future initReceipts() async {
    receipts = await receiptProvider.listReceipt(token);
  }

  final ReceivePort _port = ReceivePort();

  Future downloadCSV(filename, token) async {
    final status = await Permission.storage.request();

    if(status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: '${baseUrl}receipt/$filename',
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
        headers: {'authorization': 'Bearer ${token}'},
      );
    } else {
      print('Permission Denied');
    }
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    initReceipts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

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
        child: SizedBox(
          height: 100,
          child: AppBar(
            title: const Text("영수증 목록",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            backgroundColor: defaultColor,
          ),
        ),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) :Column(
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
                                onPressed: () {
                                  // 상세 기록 연결
                                },
                                child: Text(
                                    DateFormat('yyyy년 MM월 dd일 kk:mm').format(receipts.receipts![index].createdDate),
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
                              downloadCSV(receipts.receipts![index].key, token);
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
                                receipts.receipts!.removeAt(index);
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
              itemCount: receipts.receipts!.length
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
