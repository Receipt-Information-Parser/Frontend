import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Future<void> exportChartToImage(GlobalKey<SfCartesianChartState> chartKey) async {
  try {
    final bytes = await _capturePng(chartKey);
    if (bytes == null) {
      print('capture failed');
      return;
    }

    if (await Permission.storage.request().isGranted) {
      // Permission granted, save the image
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final appDocumentsPath = appDocumentsDirectory.path;
      final filePath = '$appDocumentsPath/chart.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print('Image saved to $filePath');
    } else {
      // User did not grant storage permission, handle accordingly
      print('Permission not granted');
    }
  } catch (e) {
    print(e);
  }
}

Future<Uint8List?> _capturePng(GlobalKey<SfCartesianChartState> chartKey) async {
  try {
    RenderRepaintBoundary boundary = chartKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    print(e);
  }
  return null;
}
