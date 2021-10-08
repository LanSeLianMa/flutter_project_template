import 'package:flutter/material.dart';

import 'h_stream.dart';

///
/// 自定义 StreamBuilder
///
class HStreamBuilder<T> extends StatelessWidget {
  final HStream<T>? hStream;
  final T? initialData; // 初始化值
  final Widget? loadWidget; //加载组件
  final AsyncWidgetBuilder<T> builder;

  const HStreamBuilder(
      {Key? key,
      required this.hStream,
      this.initialData,
      this.loadWidget,
      required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        initialData: initialData ?? hStream!.value,
        stream: hStream!.stream,
        builder: (context, snapshot) {
          /* stream属性里的值，发生变化时，就会builder
            * snapshot 接收 data 或 err，二者必然有一个不为空
            * snapshot.data
            * snapshot.error
            * ConnectionState.none     -->   stream:属性为null
            * ConnectionState.waiting  -->   等待
            * ConnectionState.active   -->   执行结束，获取snapshot
            * ConnectionState.done     -->   数据流关闭
            * */
          // switch (snapshot.connectionState) {
          //   case ConnectionState.waiting:
          //     return Center(child: loadWidget ?? CircularProgressIndicator());
          //   case ConnectionState.active:
          //     if (snapshot.hasError)
          //       return Center(child: Text('Error: ${snapshot.error}'));
          //     else if (!snapshot.hasData)
          //       return Center(child: loadWidget ?? CircularProgressIndicator());
          //     return builder.call(context, snapshot);
          //   default:
          //     return builder.call(context, snapshot);
          // }
          return builder.call(context, snapshot);
        });
  }
}
