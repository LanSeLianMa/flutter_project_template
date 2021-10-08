part of '../routers.dart';

void orderRoutes() {
  //测试页面01  有参数
  Application.router!.define(OrderPage01.path,
      handler: Handler(handlerFunc: (context, params) {
    final args = context!.settings!.arguments as Map<String, dynamic>;
    return OrderPage01(parameter: args);
  }));

  //测试页面02  无参数
  Application.router!.define(OrderPage02.path,
      handler: Handler(handlerFunc: (_, __) {
    return const OrderPage02();
  }));
}
