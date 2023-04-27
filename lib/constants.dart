import 'package:flutter/material.dart';

const Color defaultColor = Color(0xff001454); // 앱 고유 색상

const double fontSizeSmallButton = 14;// 가입하시겠습니까? 등의 작은 버튼의 fontsize
const double fontSizeButton = 20;     // 로그인, 계속하기 등의 일반 버튼의 fontsize
const double fontSizeInputText = 16;  //textform에 입력되는 fontsize
const double fontSizeTextForm = 18;   //textform에 들어갈 단어명 ex) 닉네임, 이름 등
const double marginHorizontalHeader = 20; // 수평 최소 마진
const double fontSizeMiddle = 20;     // header2로 생각
const double fontSizeHeader = 30;     // header1로 생각


const String baseUrl = "http://.../api/"; // api 주소

enum DETAIL_TYPE { APPLY, APPROVE } // 왼쪽부터 각각 신청자 등록, 신청자 확인
