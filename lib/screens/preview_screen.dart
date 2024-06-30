// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:webspark_test/models/path_data.dart';
import 'package:webspark_test/models/point.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    super.key,
    required this.pathData,
    required this.stringPath,
  });

  final PathData pathData;
  final String stringPath;

  @override
  Widget build(BuildContext context) {
    List<Point> path =
        findShortestPath(pathData.field, pathData.start, pathData.end);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Screen'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pathData.field.length,
                (y) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pathData.field[y].length,
                      (x) {
                        bool isPath = path.contains(Point(x, y));
                        bool isStart = pathData.start == Point(x, y);
                        bool isEnd = pathData.end == Point(x, y);
                        Color cellColor;

                        if (isStart) {
                          cellColor = const Color(0xFF64FFDA);
                        } else if (isEnd) {
                          cellColor = const Color(0xFF009688);
                        } else if (isPath) {
                          cellColor = const Color(0xFF4CAF50);
                        } else if (pathData.field[y][x] == 'X') {
                          cellColor = Colors.black;
                        } else {
                          cellColor = Colors.white;
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          height: MediaQuery.of(context).size.width / 4.5,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: cellColor,                            
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text('$x,$y'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Text(stringPath)
          ],
        ),
      ),
    );
  }
}

List<Point> findShortestPath(List<List<String>> field, Point start, Point end) {
  int rows = field.length;
  int cols = field[0].length;
  List<List<bool>> visited =
      List.generate(rows, (_) => List.generate(cols, (_) => false));
  List<List<Point?>> parent =
      List.generate(rows, (_) => List.generate(cols, (_) => null));

  List<Point> directions = [
    Point(0, 1),
    Point(1, 0),
    Point(0, -1),
    Point(-1, 0),
    Point(1, 1),
    Point(1, -1),
    Point(-1, 1),
    Point(-1, -1)
  ];

  Queue<Point> queue = Queue<Point>();
  queue.add(start);
  visited[start.y][start.x] = true;

  while (queue.isNotEmpty) {
    Point current = queue.removeFirst();

    if (current.x == end.x && current.y == end.y) {
      List<Point> path = [];
      Point? step = current;

      while (step != null) {
        path.add(step);
        step = parent[step.y][step.x];
      }

      return path.reversed.toList();
    }

    for (Point direction in directions) {
      int newX = current.x + direction.x;
      int newY = current.y + direction.y;

      if (newX >= 0 &&
          newY >= 0 &&
          newX < cols &&
          newY < rows &&
          !visited[newY][newX] &&
          field[newY][newX] == '.') {
        queue.add(Point(newX, newY));
        visited[newY][newX] = true;
        parent[newY][newX] = current;
      }
    }
  }

  return [];
}
