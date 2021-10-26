import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityStatus {
  /// 网络状态
  final BehaviorSubject<ConnectivityResult> _connectivity = BehaviorSubject<ConnectivityResult>();
  Stream<ConnectivityResult> get connectivity => _connectivity.stream.distinct();

  ///
  /// 是否已连网
  ///
  bool get isConnected => _connectivity.value != ConnectivityResult.none;

  ///
  /// 网络状态发生变化
  ///
  void onConnectivityChanged(ConnectivityResult result) {
    _connectivity.add(result);
  }

  void dispose() {
    _connectivity.close();
  }
}