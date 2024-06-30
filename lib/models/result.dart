import 'package:webspark_test/models/point.dart';

class Result {
  final List<Point> steps;
  final String path;

  Result({required this.steps, required this.path});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      steps: (json['steps'] as List).map((i) => Point.fromJson(i)).toList(),
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((e) => e.toJson()).toList(),
      'path': path,
    };
  }
}