import '../observer.dart';
import '../subject.dart';

/// 具体被观察者
class HttpSubject implements Subject {
  /// 观察者数组
  List<Observer> observers = [];

  /// 被观察者传递的信息
  Map<String, dynamic>? msg;

  /// 添加一个观察者
  @override
  void addObserver(Observer? observer) {
    observers.add(observer!);
  }

  /// 删除一个观察者
  @override
  void deleteObserver(Observer? observer) {
    observers.remove(observer!);
  }

  /// 设置传递的信息
  @override
  void setSubjectMsg(Map<String, dynamic>? msg) {
    this.msg = msg;
  }

  /// 获取传递的信息
  @override
  Map<String, dynamic>? getSubjectMsg() {
    return msg;
  }

  /// 通知所有观察者
  @override
  void notifyObserver() {
    for (var element in observers) {
      element.update();
      print('===========================');
    }
  }
}
