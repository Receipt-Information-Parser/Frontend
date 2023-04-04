import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../http/dto.dart';
import '../../../models/current_index.dart';
import '../../../models/user_id.dart';
import '../myinfo/my_info_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    final CurrentIndex currentIndex = Provider.of<CurrentIndex>(context);
    UserId userId = Provider.of<UserId>(context);

    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("홈",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6667AB),
      ),
      body: Column(
        children: [

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
