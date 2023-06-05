class BooleanResponse {
  final bool boolean;
  final bool valid;

  const BooleanResponse({
    required this.boolean,
    required this.valid
  });


  factory BooleanResponse.fromJson(Map<String, dynamic> json) {
    return BooleanResponse(
      boolean: json['sign'],
      valid : true
    );
  }
}