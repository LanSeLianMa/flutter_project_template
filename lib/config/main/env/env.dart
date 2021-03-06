import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project_template/common/hiv/hiv_manager.dart';
import 'package:flutter_project_template/common/provider/index_provider.dart';
import 'package:flutter_project_template/common/utils/network/connectivity_status.dart';
import 'package:flutter_project_template/common/widget/error_widget.dart';
import 'package:flutter_project_template/config/main/env/development.dart';
import 'package:flutter_project_template/generated/l10n.dart';
import 'package:flutter_project_template/page/root_view.dart';
import 'package:flutter_project_template/router/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'app_store.dart';
import 'my_home_page.dart';

/// 测试环境
class Env {
  Env() {
    /// 确保初始化方法
    /// 绑定widget 框架和Flutter 引擎的桥梁，建立通信；
    /// 一些组件或插件，需要建立通信后，才能使用，例如：sqflite
    WidgetsFlutterBinding.ensureInitialized();

    /// view发生异常，替换的组件
    ErrorWidget.builder =
        (FlutterErrorDetails flutterErrorDetails) => const ErrWidget();

    /// hiv初始化
    hivInit();

    /// 初始化路由
    Routers.initRoute();

    /// FlutterBugly 异常上报
    FlutterBugly.postCatchedException(
          () => runApp(const MyApp()),
    );

    FlutterBugly.init(androidAppId: '9fc97cfef9', iOSAppId: '47388b8383');
  }
  hivInit() async => await HivManager.init();
}

/// 全局Context
final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

/// App初始化配置
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AppStore _appStore = AppStore();

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    initConnectivityListener();

  }

  void initConnectivityListener() async {
    var connectivity = Connectivity();
    _subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _appStore.connectivityStatus.onConnectivityChanged(result);
        });
    var result = await connectivity.checkConnectivity();
    _appStore.connectivityStatus.onConnectivityChanged(result);
  }

  @override
  void dispose() {
    _appStore.onDispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ConnectivityStatus>.value(value: _appStore.connectivityStatus),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
      ],
      child: ScreenUtilInit(
          /// 初始化屏幕尺寸
          designSize: const Size(320, 480),
          builder: () {
            return MaterialApp(
              /** ===============国际化start================ */
              locale: S.delegate.supportedLocales.last, // 选择当前的国际化语言
              localizationsDelegates: const [
                S.delegate,
                RefreshLocalizations.delegate, // pull_to_refresh 国际化
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              /** ===============国际化end================ */
              debugShowCheckedModeBanner: false,
              title: Development.appName ?? "Flutter App",

              /** 字体 全局使用 */
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'AndadaPro',
              ),
              navigatorKey: navigatorKey,
              navigatorObservers: [NavigationHistoryObserver()], // 记录栈中的路由
              home: const MyHomePage(),
            );
          }),
    );
  }
}
