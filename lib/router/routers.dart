import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project_template/common/utils/viewmodel/viewmodel_provider.dart';
import 'package:flutter_project_template/page/home/home_page01.dart';
import 'package:flutter_project_template/page/home/home_page02.dart';
import 'package:flutter_project_template/page/order/order_page01.dart';
import 'package:flutter_project_template/page/order/order_page02.dart';

import 'application.dart';

part 'module/home.dart';
part 'module/list.dart';
part 'module/order.dart';

/// 路由配置
class Routers {
  static initRoute() {
    final router = FluroRouter();
    Application.router = router;

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
