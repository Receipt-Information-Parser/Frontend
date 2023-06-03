import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:rip_front/constants.dart';
import 'package:rip_front/providers/user_attribute_api.dart';
import 'package:rip_front/providers/user_auth_info_api.dart';
import 'package:rip_front/screens/initial_screen/splash_screen.dart';

import 'http/dto.dart';
import 'models/current_index.dart';
import 'models/user_attribute.dart';
import 'models/user_auth_info.dart';
import 'models/user_id.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    // print("Download Status : $status");
    // print("Download Progress : $progress");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(ignoreSsl: true);
  KakaoSdk.init(nativeAppKey: YOUR_NATIVE_APP_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<UserId>.value(value: UserId(userId: -1)), // userId
        Provider<UserAttribute?>.value(
            value: UserAttributeApi.getUserAttribute()),
        Provider<UserAuthInfo?>.value(value: UserAuthInfoApi.getUserAuthInfo()),
        Provider<TokenResponse>.value(
            value: TokenResponse("", accessToken: "", refreshToken: "")),
        Provider<CurrentIndex>.value(
            value: CurrentIndex(index: 1)), // for BottomNavigationBar
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: createMaterialColor(defaultColor),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
