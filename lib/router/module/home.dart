part of '../routers.dart';

void homeRoutes() {
  //测试页面01  有参数
  Application.router!.define(HomePage01.path,
      handler: Handler(handlerFunc: (context, params) {
    final args = context!.settings!.arguments as Map<String, dynamic>;
    return HomePage01(parameter: args);
  }));

  //测试页面02  无参数
  Application.router!.define(HomePage02.path,
      handler: Handler(handlerFunc: (_, __) {
    return const HomePage02();
  }));
}
