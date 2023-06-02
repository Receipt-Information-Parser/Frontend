import 'dart:ffi';

class ReceiptResponse {
  final int id;
  final DateTime createdDate;
  final String key;
  final int ownerId;

  const ReceiptResponse({
    required this.id,
    required this.createdDate,
    required this.key,
    required this.ownerId,
  });


  factory ReceiptResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptResponse(
      id: json['id'],
      createdDate: DateTime.parse(json['createdDate']),
      key: json['detailKey'],
      ownerId: json['ownerId']
    );
  }
}

class ListReceiptResponses {
  List<ReceiptResponse>? receipts;

  ListReceiptResponses({this.receipts});

  ListReceiptResponses.fromJson(Map<String, dynamic> json) {
    if (json['receipts'] != null) {
      receipts = <ReceiptResponse>[];
      json['receipts'].forEach((v) {
        receipts!.add(new ReceiptResponse.fromJson(v));
      });
    }
  }
}