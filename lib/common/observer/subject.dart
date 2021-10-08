import 'observer.dart';

/// 通知者（被观察者）
/// Subject类是被观察者，它把所有对观察者对象的引用文件存在了一个聚集里，
/// 每个被观察者都可以有任何数量的观察者。抽象主题提供了一个接口，
/// 可以增加和删除观察者对象；
abstract class Subject {
  /// 添加一个观察者
  void addObserver(Observer? observer);

  /// 删除一个观察者
  void deleteObserver(Observer? observer);

  /// 设置传递的信息
  void setSubjectMsg(Map<String, dynamic>? msg);

  /// 获取传递的信息
  Map<String, dynamic>? getSubjectMsg();

  /// 通知所有观察者
  void notifyObserver();
}
