import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 判断每一个字段是否为空，是空返回 null, 反之 返回当前字段值
T? dataHandler<T>(data, List<String> fields, int index, [T? defaultValue]) {
  if (data == null) {
    return defaultValue;
  }

  try {
    //如果最后一个字段存在，返回最后一个字段里的值
    if (index == (fields.length - 1)) {
      return data[fields[index]] ?? defaultValue;
    }
  } catch (e) {
    return defaultValue;
  }

  // 递归
  return dataHandler(data[fields[index]], fields, index + 1) ?? defaultValue;
}

/// 快速点击返回键两次，退出app
int _lastClickTime = 0;
Future<bool> doubleExit() {
  Fluttertoast.showToast(
    msg: "再按一次退出程序",

    //首次点击提示...信息
    gravity: ToastGravity.CENTER,

    //提示弹窗显示的位置
    timeInSecForIosWeb: 1,

    //弹窗显示时间
    backgroundColor: const Color.fromRGBO(75, 75, 75, 0.9),
    textColor: Colors.white,

    // fontSize: 20.0,
  );

  ///第一次点击的时间
  int nowTime = DateTime.now().microsecondsSinceEpoch;

  ///间隔少于2秒，执行退出
  if (_lastClickTime != 0 && nowTime - _lastClickTime > 2000) {
    return Future.value(true);
  } else {
    ///反之重置点击时间
    _lastClickTime = DateTime.now().microsecondsSinceEpoch;
    Future.delayed(const Duration(milliseconds: 2000), () {
      _lastClickTime = 0;
    });
    return Future.value(false);
  }
}

/// 截流
/// 在触发事件时，立即执行目标操作，同时给出一个延迟的时间，
/// 在该时间范围内如果再次触发了事件，该次事件会被忽略，
/// 直到超过该时间范围后触发事件才会被处理。
///
/// 当前第一次点击后，两秒内频内，不会触发相同点击事件
int _lastClicksTime = 0;
Future<bool> throttle(Function callback, {bool throttleFlag = true}) {
  if (throttleFlag) {
    int nowTime = DateTime.now().microsecondsSinceEpoch;

    if (_lastClicksTime != 0 && nowTime - _lastClicksTime > 2000) {
      // print('执行====两秒内频繁点击=====');

      return Future.value(false);
    } else {
      // print('执行====第一次点击=====');

      //第一次点击的时间
      callback.call();

      //重置点击时间
      _lastClicksTime = DateTime.now().microsecondsSinceEpoch;
      Future.delayed(const Duration(milliseconds: 2000), () {
        _lastClicksTime = 0;
      });
      return Future.value(true);
    }
  } else {
    callback.call();
    return Future.value(false);
  }
}
