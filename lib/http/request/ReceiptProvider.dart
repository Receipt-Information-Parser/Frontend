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
      return Future.error(
          '${body['status']}: ${body['message']}');
    }
  }
}
