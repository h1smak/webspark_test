import 'package:webspark_test/models/point.dart';

class PathData {
  String id;
  List<List<String>> field;
  Point start;
  Point end;

  PathData({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory PathData.fromJson(Map<String, dynamic> json) {
    List<List<String>> parsedField = (json['field'] as List<dynamic>)
        .map((row) => (row as String).split(''))
        .toList();

    return PathData(
      id: json['id'],
      field: parsedField,
      start: Point.fromJson(json['start']),
      end: Point.fromJson(json['end']),
    );
  }
}