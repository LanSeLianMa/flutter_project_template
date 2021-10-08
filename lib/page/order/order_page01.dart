import 'package:flutter/material.dart';

class OrderPage01 extends StatefulWidget {
  static const String path = 'lib/page/order/order_page01';
  final Map<String, dynamic>? parameter;
  const OrderPage01({Key? key, this.parameter}) : super(key: key);

  @override
  _OrderPage01State createState() => _OrderPage01State();
}

class _OrderPage01State extends State<OrderPage01> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('orderPage01页面'),
            Text('参数：${widget.parameter}')
          ],
        ),
      ),
    );
  }
}
