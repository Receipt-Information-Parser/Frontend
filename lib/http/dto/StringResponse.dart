class StringResponse {
  final String message;

  const StringResponse({
    required this.message,
  });


  factory StringResponse.fromJson(Map<String, dynamic> json) {
    return StringResponse(
      message: json['message'],
    );
  }
}