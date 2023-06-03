import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AnalysisChart1.dart';
import '../DataAnalysis.dart';

import '../../../constants.dart';

List<Widget> consumeOfitem(String sectionTitle, List<String> sectionItems, BuildContext context) {
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
              //TODO: getByName API 호출 및 Navigater에 결과 pass
              // String? apiResponse = await getByName(item);
              //TODO: apiResponse 결과 pass
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: ((context) => AnalysisChart1Screen())
              ));
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