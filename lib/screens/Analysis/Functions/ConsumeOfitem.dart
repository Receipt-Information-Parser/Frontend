import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../http/dto.dart';
import '../../../http/request.dart';
import '../AnalysisChart1.dart';
import '../DataAnalysis.dart';

import '../../../constants.dart';
import 'ExportChartToImage.dart';

List<Widget> consumeOfitem(String sectionTitle, List<String> sectionItems, BuildContext context,{GlobalKey<SfCartesianChartState>? chartKey}) {
  TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
  List<Widget> widgets = [];
  widgets.add(Divider(
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
        style: TextStyle(
          color: defaultColor,
          fontSize: fontSizeMiddle,
          fontWeight: FontWeight.bold,
        )),
  ));
  widgets.add(Divider(
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
              style: TextStyle(
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
            icon: Icon(Icons.download),
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
                //TODO: getByName API 호출 및 Navigater에 결과 pass
                String url = '${baseUrl}analysis/product';
                List<ByProduct>? ApiResponse = await getByName(url,Item,tokenResponse.accessToken);
                //TODO: apiResponse 결과 pass
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => AnalysisChart1Screen(apiResponse: ApiResponse,item: Item,))
                ));
              }
            },
          ),
        ),
      ],
    ));
    widgets.add(Divider(
      color: Colors.grey,
      height: 30,
      thickness: 1,
      indent: 1,
      endIndent: 1,
    ));
  }

  return widgets;
}