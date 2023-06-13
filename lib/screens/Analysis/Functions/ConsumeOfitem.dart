import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../http/dto.dart';
import '../../../http/request.dart';
import '../AnalysisChart1.dart';

import '../../../constants.dart';
import 'ExportChartToImage.dart';

List<Widget> consumeOfitem(String sectionTitle, List<String> sectionItems, BuildContext context,{GlobalKey<SfCartesianChartState>? chartKey}) {
  TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
  List<Widget> widgets = [];
  widgets.add(const Divider(
    color: Colors.grey,
    height: 30,
    thickness: 1,
    indent: 1,
    endIndent: 1,
  ));
  widgets.add(Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(
      left: marginHorizontalHeader,
    ),
    child: Text(sectionTitle,
        style: const TextStyle(
          color: defaultColor,
          fontSize: fontSizeMiddle,
          fontWeight: FontWeight.bold,
        )),
  ));
  widgets.add(const Divider(
    color: Colors.grey,
    height: 30,
    thickness: 1,
    indent: 1,
    endIndent: 1,
  ));

  for (String Item in sectionItems) {
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(
            left: marginHorizontalHeader,
          ),
          child: Text(Item,
              style: const TextStyle(
                color: defaultColor,
                fontSize: fontSizeMiddle,
                fontWeight: FontWeight.normal,
              )),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(
            right: marginHorizontalHeader,
          ),
          child: IconButton(
            icon: const Icon(Icons.download),
            iconSize: iconSizeSmall,
            onPressed: () async {
              if (chartKey != null) { // 다운로드 창일 때,
                // csv 다운로드 함수 호출
                await exportChartToImage(chartKey);
                // 다운로드 완료 Dialog 출력
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Download", style: TextStyle(color: defaultColor),),
                      content: const Text("다운로드가 완료되었습니다."),
                      actions: [
                        TextButton(
                          child: const Text("Close", style: TextStyle(color: defaultColor),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              else{ // 화면 넘김용일때
                //getByName API 호출 및 Navigater에 결과 pass
                String url = '${baseUrl}analysis/product';
                List<ByProduct>? ApiResponse = await getByName(url,Item,tokenResponse.accessToken);
                // apiResponse 결과 pass
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => AnalysisChart1Screen(apiResponse: ApiResponse,item: Item,))
                ));

                /// for debug /////////////////////
                // if(Item=='과자'){
                //   List<ByProduct>? ApiResponse =[
                //     ByProduct(name: '과자', amount: 3000, analysisId: 2, date: DateTime.parse('2011-01-01')),
                //     ByProduct(name: '과자', amount: 2000, analysisId: 2, date: DateTime.parse('2012-01-01')),
                //     ByProduct(name: '과자', amount: 2500, analysisId: 2, date: DateTime.parse('2013-01-01')),
                //     ByProduct(name: '과자', amount: 3500, analysisId: 2, date: DateTime.parse('2014-01-01')),
                //     ByProduct(name: '과자', amount: 4000, analysisId: 2, date: DateTime.parse('2015-01-01')),
                //     ByProduct(name: '과자', amount: 2000, analysisId: 2, date: DateTime.parse('2016-01-01')),
                //   ];
                //   //apiResponse 결과 pass
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: ((context) => AnalysisChart1Screen(apiResponse: ApiResponse,item: Item,))
                //   ));
                // }
                // if(Item=='아이스크림'){
                //   List<ByProduct>? ApiResponse =[
                //     ByProduct(name: '아이스크림', amount: 1400, analysisId: 2, date: DateTime.parse('2011-01-01')),
                //     ByProduct(name: '아이스크림', amount: 2800, analysisId: 2, date: DateTime.parse('2012-01-01')),
                //     ByProduct(name: '아이스크림', amount: 1500, analysisId: 2, date: DateTime.parse('2013-01-01')),
                //     ByProduct(name: '아이스크림', amount: 3500, analysisId: 2, date: DateTime.parse('2014-01-01')),
                //     ByProduct(name: '아이스크림', amount: 3500, analysisId: 2, date: DateTime.parse('2015-01-01')),
                //     ByProduct(name: '아이스크림', amount: 2000, analysisId: 2, date: DateTime.parse('2016-01-01')),
                //   ];
                //   //apiResponse 결과 pass
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: ((context) => AnalysisChart1Screen(apiResponse: ApiResponse,item: Item,))
                //   ));
                // }
                // if(Item=='음료'){
                //   List<ByProduct>? ApiResponse =[
                //     ByProduct(name: '음료', amount: 4000, analysisId: 2, date: DateTime.parse('2011-01-01')),
                //     ByProduct(name: '음료', amount: 2500, analysisId: 2, date: DateTime.parse('2012-01-01')),
                //     ByProduct(name: '음료', amount: 1500, analysisId: 2, date: DateTime.parse('2013-01-01')),
                //     ByProduct(name: '음료', amount: 4500, analysisId: 2, date: DateTime.parse('2014-01-01')),
                //     ByProduct(name: '음료', amount: 3000, analysisId: 2, date: DateTime.parse('2015-01-01')),
                //     ByProduct(name: '음료', amount: 2000, analysisId: 2, date: DateTime.parse('2016-01-01')),
                //   ];
                //   //apiResponse 결과 pass
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: ((context) => AnalysisChart1Screen(apiResponse: ApiResponse,item: Item,))
                //   ));
                // }
                /// for debug fin /////////////////
              }
            },
          ),
        ),
      ],
    ));
    widgets.add(const Divider(
      color: Colors.grey,
      height: 30,
      thickness: 1,
      indent: 1,
      endIndent: 1,
    ));
  }

  return widgets;
}