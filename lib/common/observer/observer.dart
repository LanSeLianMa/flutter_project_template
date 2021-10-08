import 'package:flutter_project_template/common/observer/subject.dart';

/// 观察者
/// Observer类是抽象观察者，为所有的具体观察者定义一个接口，
/// 在得到被观察者通知时更新自己；
abstract class Observer {
  /// 当前观察者名称
  String? name;

  /// 通知者（被观察者）
  Subject? subject;

  Observer({this.name, this.subject});

  /// 更新
  void update();
}
