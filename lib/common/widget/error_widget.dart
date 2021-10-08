import 'package:flutter/material.dart';

/// 页面发生异常后替换的组件
class ErrWidget extends StatelessWidget {
  const ErrWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 20, height: 20, child: Icon(Icons.error)),
            Text("页面异常，请联系客服。"),
          ],
        ),
      ),
    );
  }
}
