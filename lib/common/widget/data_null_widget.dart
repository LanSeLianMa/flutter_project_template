import 'package:flutter/material.dart';

import 'my_button.dart';

/// 数据为空时，渲染的组件
class DataNullWidget extends StatelessWidget {
  final String? msg;
  final Function callback;
  const DataNullWidget({Key? key, required this.callback, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${msg}'),
            MyButton(
      textContent: '点击刷新',
      onTap: () {
            callback.call();
      },
    ),
          ],
        ));
  }
}
