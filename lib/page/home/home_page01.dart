import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/utils/stream/h_stream.dart';
import 'package:flutter_project_template/common/utils/stream/h_stream_builder.dart';

class HomePage01 extends StatefulWidget {
  static const String path = 'lib/page/home/home_page01';
  final Map<String, dynamic>? parameter;
  const HomePage01({Key? key, this.parameter}) : super(key: key);

  @override
  _HomePage01State createState() => _HomePage01State();
}

class _HomePage01State extends State<HomePage01> {
  String _text = '修改文本';

  HStream<String>? _stream;

  @override
  void initState() {
    _stream = HStream<String>(initialData: '修改文本');
    super.initState();
  }

  @override
  void dispose() {
    _stream!.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomePage01页面'),
            Text('参数：${widget.parameter}'),
            RaisedButton(
                child: TextWidget(text: _text),
                onPressed: () {
                  setState(() {
                    _text = '修改成功';
                  });
                }),
            RaisedButton(
                child: HStreamBuilder<String>(
                    hStream: _stream,
                    builder: (context, snapshot) {
                      return TextWidget(text: snapshot.data ?? '');
                    }),
                onPressed: () {
                  _stream!.update('修改成功');
                })
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key? key,
    required String text,
  })  : _text = text,
        super(key: key);

  final String _text;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  void didUpdateWidget(covariant TextWidget oldWidget) {
    print('执行子组件的didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget._text);
  }
}
