part of '../routers.dart';

void listRoutes() {
  //测试页面01  有参数
  Application.router!.define(ViewModelProvider.path,
      handler: Handler(handlerFunc: (context, params) {
    final args = context!.settings!.arguments as Map<String, dynamic>;
    return ViewModelProvider(parameter: args);
  }));
}
