import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../http/dto.dart';
import '../Home/home_screen.dart';

class DetailScreen extends StatefulWidget {
  final String csv;

  const DetailScreen({Key? key, required this.csv}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(csv);
}

class _DetailScreenState extends State<DetailScreen> {
  final String csv;

  _DetailScreenState(this.csv);

  Map<String, dynamic> data = <String, dynamic>{};
  late DetailDataSource detailDataSource;

  bool _isEditing = false;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    data = getDetailData(csv);
    _totalAmount = _calculateTotalAmount();
    detailDataSource = DetailDataSource(data: data);
  }

  @override
  Widget build(BuildContext context) {
    TokenResponse tokenResponse = Provider.of<TokenResponse>(context);
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
        centerTitle: true, // 제목을 가운데 정렬
        title: const Text('상세 내역'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => HomeScreen(token: tokenResponse.accessToken,))
            ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _showConfirmationDialog();
              } else {
                setState(() {
                  _isEditing = !_isEditing;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfDataGrid(
                selectionMode: SelectionMode.singleDeselect,
                allowEditing: _isEditing,
                allowSwiping: true,
                editingGestureType: EditingGestureType.tap,
                allowPullToRefresh: true,
                source: detailDataSource,
                gridLinesVisibility: GridLinesVisibility.both,
                columnWidthMode: ColumnWidthMode.fill,
                columns: columns
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(16.0),
            child: Text('총액: ${_totalAmount.toInt()}원')
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount() {
    double total = 0.0;

    for (Map<String, String> row in data['rows']) {
      if (row.containsKey('금액')) {
        total += double.tryParse(row['금액']!) ?? 0.0;
      }
    }

    return total;
  }

  void _showConfirmationDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('수정 완료 확인'),
        content: const Text('수정을 완료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
                _totalAmount = _calculateTotalAmount();
              });
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> getDetailData(String csv) {
    final lines = csv.split('\n');
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
  // Add data as a class member so it can be accessed from other methods
  Map<String, dynamic> data;

  DetailDataSource({required this.data}) {
    final columns = data['columns'];
    final rows = data['rows'];
    var gridData = <DataGridRow>[];
    for (int i = 0; i < rows.length; i++) {
      var gridRow = <DataGridCell>[];

      for (int j = 0; j < columns.length; j++) {
        var value = rows[i][columns[j]];
        value ??= "---";
        gridRow.add(DataGridCell<String>(columnName: columns[j], value: value));
      }

      var dataRow = DataGridRow(cells: gridRow);
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
      }).toList(),
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow row, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Get the index of the row that contains the cell that was edited
    final rowIndex = rowColumnIndex.rowIndex;
    // Get the column name of the cell that was edited
    final columnName = column.columnName;
    // Find the corresponding value in the data source and update it with the new value
    for (int i = 0; i < data['rows'].length; i++) {
      if (i == rowIndex) {
        var newValue = row.getCells()[rowColumnIndex.columnIndex].value;
        data['rows'][i][columnName] = newValue;
        break;
      }
    }
    // Notify any listeners that the data source has been updated, which will cause the grid to refresh
    notifyListeners();
  }
}
