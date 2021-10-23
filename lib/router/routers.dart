import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/utils/viewmodel/viewmodel_provider.dart';
import 'package:flutter_project_template/config/main/env/my_home_page.dart';
import 'package:flutter_project_template/page/home/home_page01.dart';
import 'package:flutter_project_template/page/home/home_page02.dart';
import 'package:flutter_project_template/page/order/order_page01.dart';
import 'package:flutter_project_template/page/order/order_page02.dart';
import 'package:flutter_project_template/page/root_view.dart';

import 'application.dart';

part 'module/home.dart';
part 'module/list.dart';
part 'module/order.dart';

/// 路由配置
class Routers {
  static initRoute() {
    final router = FluroRouter();
    Application.router = router;

    // 找不到view的默认视图
    router.notFoundHandler =
        Handler(handlerFunc: (_, __) => const DefaultNotFoundScreen());

    // 根路由
    router.define('/',
        handler: Handler(handlerFunc: (_, __) => const RootView()));

    // 初始化各个模块的路由
    homeRoutes();
    orderRoutes();
    listRoutes();
  }

  /// path：路径
  /// transition：路由动画
  /// parameter：参数
  static Future<dynamic> push(String path, BuildContext context,
      {TransitionType transition = TransitionType.cupertino,
      Map<String, dynamic>? parameter}) {
    return Application.router!.navigateTo(context, path,
        transition: transition,
        routeSettings: RouteSettings(arguments: parameter ?? {'key': null}));
  }
}

///
/// 默认路由未找到显示 view
///
class DefaultNotFoundScreen extends StatelessWidget {
  const DefaultNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("404 view, try restart"),
      ),
    );
  }
}
