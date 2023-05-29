import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic> data = <String, dynamic>{};
  late DetailDataSource detailDataSource;

  @override
  void initState() {
    super.initState();
    data = getDetailData();
    detailDataSource = DetailDataSource(data: data);
  }

  @override
  Widget build(BuildContext context) {
    var columns = <GridColumn>[];

    for (int i = 0; i < data['columns'].length; i++) {
      columns.add(
        GridColumn(
            columnName: data['columns'][i],
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text(
                  data['columns'][i],
                )))
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 내역'),
      ),
      body: SfDataGrid(
        selectionMode: SelectionMode.singleDeselect,
        allowEditing: true,
        allowSwiping: true,
        editingGestureType: EditingGestureType.doubleTap,
        allowPullToRefresh: true,
        source: detailDataSource,
        gridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.fill,
        columns: columns
      ),
    );
  }

  Map<String, dynamic> getDetailData() {
    String dummyCSV = ',품 명 ,수 량 ,금 액\n0,Ice)카페라떼,1.0,1700\n1,(Size)M,,0\n2,,,1700원';
    final lines = dummyCSV.split('\n');
    final columns = lines[0].split(',');

    var data = <String, dynamic>{};
    data['columns'] = columns;

    List<Map<String, String>> rows = <Map<String, String>>[];

    for (int i = 1; i < lines.length; i++) {
      var split = lines[i].split(',');
      var map = <String, String>{};
      for (int j = 0; j < split.length; j++) {
        String columnName = columns[j].toString();

        if (columnName == "") {
          columnName = "---";
        }

        String value = split[j].toString();

        if (value == "") {
          value = "---";
        }

        map[columnName] = value;
      }
      rows.add(map);
    }

    data['rows'] = rows;

    return data;
  }
}


class DetailDataSource extends DataGridSource {
  DetailDataSource({required Map<String, dynamic> data}) {
    final columns = data['columns'];
    final rows = data['rows'];
    var gridData = <DataGridRow>[];
    for (int i = 0; i < rows.length; i++) {
      var gridRow = <DataGridCell>[];

      for (int j = 0; j < columns.length; j++) {

        var value = rows[i][columns[j]];

        value ??= "---";

        gridRow.add(
          DataGridCell<String>(columnName: columns[j], value: value)
        );
      }
      var dataRow = DataGridRow(
          cells : gridRow
      );
      gridData.add(dataRow);
    }

    detailData = gridData;
  }

  List<DataGridRow> detailData = [];

  @override
  List<DataGridRow> get rows => detailData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}