import 'package:flutter/material.dart';

import 'my_button.dart';

/// 数据为空时，渲染的组件
class DataNullWidget extends StatelessWidget {
  final Function callback;
  const DataNullWidget({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: MyButton(
      textContent: '点击刷新',
      onTap: () {
        callback.call();
      },
    ));
  }
}
