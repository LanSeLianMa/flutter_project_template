import 'package:flutter_project_template/common/utils/network/connectivity_status.dart';

///
/// App global model
/// APP 全局数据源
///
class AppStore implements Disposable {
  /// 网络状态
  final ConnectivityStatus connectivityStatus = ConnectivityStatus();

  @override
  void onDispose() {
    connectivityStatus.dispose();
  }
}


abstract class Disposable {
  void onDispose();
}