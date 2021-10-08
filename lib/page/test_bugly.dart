import 'package:flutter/material.dart';

/// 测试Bugly异常上报
class TestBugly extends StatefulWidget {
  const TestBugly({Key? key}) : super(key: key);

  @override
  _TestBuglyState createState() => _TestBuglyState();
}

class _TestBuglyState extends State<TestBugly> {
  @override
  Widget build(BuildContext context) {
    List<String> numList = ['1', '2'];
    print(numList[5]);
    return Container();
  }
}
