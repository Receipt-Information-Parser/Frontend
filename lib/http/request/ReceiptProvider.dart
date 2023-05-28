import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rip_front/http/dto/ReceiptResponse.dart';

class ReceiptProvider {
  final String uri;

  ReceiptProvider(this.uri);

  Future<ListReceiptResponses> listReceipt(String token) async {
    final response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return ListReceiptResponses.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      if (body['message'] == "현재 유저가 영수증을 가지고 있지 않습니다.") {
        return ListReceiptResponses(receipts: <ReceiptResponse>[]);
      }
      else {
        return Future.error(
        '${body['status']}: ${body['message']}');
      }
    }
  }

  Future<ReceiptResponse> addReceipt(String token, String image) async {
    http.MultipartRequest multipartRequest = http.MultipartRequest('POST', Uri.parse(uri));
    multipartRequest.headers['authorization'] = "Bearer $token";

    multipartRequest.files.add(
        await http.MultipartFile.fromPath(
        'file', image)
    );

    var streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ReceiptResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return Future.error(
          '${body['status']}: ${body['message']}');
    }
  }
}
