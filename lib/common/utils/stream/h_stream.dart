import 'package:rxdart/rxdart.dart';

///
/// 自定义 stream
/// 配合 HStreamBuilder 使用
///
class HStream<T> {
  /// Stream对象
  /// BehaviorSubject -> Subject -> ValueStream -> Stream
  BehaviorSubject<T>? _data;

  T get value => _data!.value;

  /// stream
  ValueStream<T> get stream => _data!.stream;

  /// 单例模式
  HStream({required T initialData}) {
    if (initialData == null) {
      _data = BehaviorSubject<T>();
    } else {
      _data = BehaviorSubject<T>.seeded(initialData);
    }
  }

  /// 更新操作
  update(T data) {
    _data!.add(data);
  }

  /// 销毁操作
  onDispose() {
    _data!.close();
  }
}
