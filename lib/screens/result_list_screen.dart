import 'package:flutter/material.dart';
import 'package:webspark_test/models/path_data.dart';
import 'package:webspark_test/models/request_body.dart';
import 'package:webspark_test/screens/preview_screen.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen(
      {super.key, required this.list, required this.pathData});

  final List<RequestBody> list;
  final List<PathData> pathData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return PreviewScreen(
                      pathData: pathData
                          .where((element) => element.id == list[index].id)
                          .first,
                      stringPath: list[index].result.path,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    list[index].result.path,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
