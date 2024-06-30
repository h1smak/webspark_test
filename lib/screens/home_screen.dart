// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webspark_test/models/path_data.dart';
import 'package:webspark_test/models/point.dart';
import 'package:webspark_test/models/request_body.dart';
import 'package:webspark_test/models/result.dart';
import 'package:webspark_test/screens/preview_screen.dart';
import 'package:webspark_test/screens/result_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _showError = false;
  double _progress = 0.0;
  List<RequestBody> postRequest = [];
  List<PathData> pathData = [];

  void _fetchData(String link) async {
    setState(() {
      _showError = false;
      _isLoading = true;
      _progress = 0.0;
    });

    var url = Uri.parse(link);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        pathData = (data['data'] as List<dynamic>)
            .map((item) => PathData.fromJson(item as Map<String, dynamic>))
            .toList();

        int totalOperations = pathData.length;
        int completedOperations = 0;

        for (var i = 0; i < pathData.length; i++) {
          List<Point> result = findShortestPath(
              pathData[i].field, pathData[i].start, pathData[i].end);
          if (result.isEmpty) {
            return;
          } else {
            postRequest.add(
              RequestBody(
                id: pathData[i].id,
                result: Result(
                    steps: result,
                    path: result
                        .map((point) => '(${point.x},${point.y})')
                        .join('->')),
              ),
            );
          }

          completedOperations++;

          await Future.delayed(const Duration(seconds: 1));

          setState(() {
            _progress = completedOperations / totalOperations;
          });

          await Future.delayed(const Duration(seconds: 1));
        }
      } else {
        print('Error:: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:: $e');
      setState(() {
        _showError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> sendPostRequest(List<RequestBody> requestBody) async {
    setState(() {
      _isLoading = true;
    });
    final body = [...requestBody];

    var url = Uri.https('flutter.webspark.dev', '/flutter/api');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body.map((e) => e.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return ResultListScreen(
                list: requestBody,
                pathData: pathData,
              );
            },
          ),
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _progress = 0.0;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: _progress == 1.0 ? null : _progress,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text('${(_progress * 100).toStringAsFixed(0)}% completed'),
          ],
        ),
      );
    }

    if (_progress == 1.0 && _isLoading == false) {
      return Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text('100% completed'),
              SizedBox(height: 20),
              Text(
                'All calculations has finished, you can send your results to server',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              sendPostRequest(postRequest);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 54),
              backgroundColor: Colors.blue.shade300,
            ),
            child: const Text(
              'Send results to server',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter URL to get data',
              ),
            ),
            _showError
                ? const Text('Set valid API base URL in order to continue')
                : const SizedBox.shrink(),
            ElevatedButton(
              onPressed: () {
                _fetchData(_controller.text);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 54),
                backgroundColor: Colors.blue.shade300,
              ),
              child: const Text(
                'Start counting process',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
