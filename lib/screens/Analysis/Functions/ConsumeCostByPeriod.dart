import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../http/dto.dart';
import '../../../http/request.dart';
import '../AnalysisChart2.dart';

import '../../../constants.dart';
import 'ExportChartToImage.dart';

List<Widget> consumeCostByPeriod(String sectionTitle, List<String> sectionItems, BuildContext context,{GlobalKey<SfCartesianChartState>? chartKey}) {
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

  for (String item in sectionItems) {
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(
            left: marginHorizontalHeader,
          ),
          child: Text(item,
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
              else { // 화면 넘김용일때
                List<ByPeriod>? ApiResponse;
                if (item == '연도별') {
                  String url = '${baseUrl}analysis/year';
                  print('[debug]연도별 clicked:$url');
                  ApiResponse = await getByYear(url,tokenResponse.accessToken);
                  /// for debug /////////////////////
                  // ApiResponse=[
                  //   ByPeriod(date: DateTime.parse('2020-01-01'), amount: 313800, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2021-01-01"), amount: 378960, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2022-01-01"), amount: 465880, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2023-01-01"), amount: 579320, analysisId: 2),
                  // ];
                  /// for debug fin /////////////////////
                }
                if (item == '월별') {
                  String url = '${baseUrl}analysis/month';
                  print('[debug]월별 clicked:$url');
                  ApiResponse = await getByMonth(url,tokenResponse.accessToken);
                  /// for debug /////////////////////
                  // ApiResponse =[
                  //   ByPeriod(date: DateTime.parse('2020-01-01'), amount: 113440, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2020-03-01"), amount: 200360, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2021-01-01"), amount: 265520, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2021-05-01"), amount: 113440, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2022-02-01"), amount: 200360, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2022-09-01"), amount: 265520, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2023-03-01"), amount: 113440, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2023-04-01"), amount: 200360, analysisId: 2),
                  //   ByPeriod(date: DateTime.parse("2023-05-01"), amount: 265520, analysisId: 2),
                  // ];
                  /// for debug fin /////////////////////
                }
                // Navigator 결과와 같이 넘기기(response 형태에 따라 다르게 구현)
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => AnalysisChart2Screen(apiResponse:ApiResponse,periodType:item))
                ));
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