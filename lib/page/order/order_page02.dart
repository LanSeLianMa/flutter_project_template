import 'package:flutter/material.dart';

class OrderPage02 extends StatefulWidget {
  static const String path = 'lib/page/order/order_page02';
  const OrderPage02({Key? key}) : super(key: key);

  @override
  _OrderPage02State createState() => _OrderPage02State();
}

class _OrderPage02State extends State<OrderPage02> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('OrderPage02页面'),
          ],
        ),
      ),
    );
  }
}
