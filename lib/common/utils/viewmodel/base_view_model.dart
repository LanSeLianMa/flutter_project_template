import 'package:flutter/material.dart';

/// 所有viewModel的父类，提供一些公共功能
abstract class BaseViewModel {
  bool _isFirst = true;

  bool get isFirst => _isFirst;

  /// 那个init方法的作用是为了保证doInit只执行一次，
  /// 这样做省去了所有子类都判断一下是否已经执行过init，
  /// 子类只需要重写doInit就可以保证方法里的代码只执行一次
  Future init(BuildContext context, bool mounted) async {
    if (_isFirst) {
      _isFirst = false;
      doInit(context, mounted);
    }
  }

  Future refreshData(BuildContext context, bool mounted);

  Future doInit(BuildContext context, bool mounted);

  void dispose(BuildContext context, bool mounted);
}
