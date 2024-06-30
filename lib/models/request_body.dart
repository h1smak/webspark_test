import 'package:webspark_test/models/result.dart';

class RequestBody {
  final String id;
  final Result result;

  RequestBody({required this.id, required this.result});

  factory RequestBody.fromJson(Map<String, dynamic> json) {
    return RequestBody(
      id: json['id'],
      result: Result.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result.toJson(),
    };
  }
}
