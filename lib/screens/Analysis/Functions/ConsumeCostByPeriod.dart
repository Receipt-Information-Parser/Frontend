import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AnalysisChart2.dart';
import '../DataAnalysis.dart';

import '../../../constants.dart';

List<Widget> consumeCostByPeriod(String sectionTitle, List<String> sectionItems, BuildContext context) {
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
              String? apiResponse;
              if (item == '연도별') {
                // apiResponse = await getByYear();
                // TODO: Navigator 결과와 같이 넘기기(response 형태에 따라 다르게 구현)
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => AnalysisChart2Screen())
                ));
              }
              if (item == '월별') {
                // apiResponse = await getByMonth();
                // TODO: Navigator 결과와 같이 넘기기(response 형태에 따라 다르게 구현)
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => AnalysisChart2Screen())
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