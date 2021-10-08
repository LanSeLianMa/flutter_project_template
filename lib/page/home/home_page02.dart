import 'package:flutter/material.dart';

class HomePage02 extends StatefulWidget {
  static const String path = 'lib/page/home/home_page02';
  const HomePage02({Key? key}) : super(key: key);

  @override
  _HomePage02State createState() => _HomePage02State();
}

class _HomePage02State extends State<HomePage02> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('HomePage02页面'),
          ],
        ),
      ),
    );
  }
}
