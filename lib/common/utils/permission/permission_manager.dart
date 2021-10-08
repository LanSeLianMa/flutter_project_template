import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/widget/my_button.dart';
import 'package:flutter_project_template/config/main/env/env.dart';

import 'package:permission_handler/permission_handler.dart';

///获取全局context
BuildContext context = navigatorKey!.currentState!.overlay!.context;

/// 权限管理器
/// 注意：必须先在原生中添加权限
/// 权限目录：
///   1、相机     camera
///   2、相册     photoAlbum
///   3、麦克风   microphone
///   4、储存     storage
///   5、定位     location
class PermissionManager {
  /// 获取权限
  getPermissions({List<PermissionType>? types}) async {
    for (int i = 0; i < types!.length; i++) {
      await _requestPermission(types[i]);
    }
  }

  /// 请求权限
  _requestPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.camera:
        await _getCamera(_toMsg(type));
        break;
      case PermissionType.microphone:
        await _getMicrophone(_toMsg(type));
        break;
    }
  }

  /// 模版
  /// 获取相机权限
  _getCamera(String msg) async {
    // 获取状态
    PermissionStatus status = await Permission.camera.status;

    // 用户普通拒绝状态
    if (status == PermissionStatus.denied) {
      // 请求权限
      PermissionStatus currentStatus = await Permission.camera.request();
      if (Platform.isAndroid) {
        // 用户永久拒绝状态
        if (currentStatus == PermissionStatus.permanentlyDenied) {
          // 弹窗，引导进去app信息窗口，手动打开
          _toAppInfo(msg);
        }
      }

      if (Platform.isIOS) {
        // 用户授权有限访问
        // if (currentStatus == PermissionStatus.limited) {
        // 请求权限
        // await Permission.camera.request();
        // }

        // 操作系统拒绝访问请求的功能。用户无法更改
        if (currentStatus == PermissionStatus.restricted) {
          // 弹窗，引导进去app信息窗口，手动打开
          _toAppInfo(msg);
        }
      }
    }
  }

  /// 获取麦克风权限
  _getMicrophone(String msg) async {
    // 获取状态
    PermissionStatus status = await Permission.microphone.status;

    // 用户普通拒绝状态
    if (status == PermissionStatus.denied) {
      // 请求权限
      PermissionStatus currentStatus = await Permission.microphone.request();
      if (Platform.isAndroid) {
        // 用户永久拒绝状态
        if (currentStatus == PermissionStatus.permanentlyDenied) {
          // 弹窗，引导进去app信息窗口，手动打开
          _toAppInfo(msg);
        }
      }

      if (Platform.isIOS) {
        // 用户授权有限访问
        // if (currentStatus == PermissionStatus.limited) {
        // 请求权限
        // await Permission.camera.request();
        // }

        // 操作系统拒绝访问请求的功能。用户无法更改
        if (currentStatus == PermissionStatus.restricted) {
          // 弹窗，引导进去app信息窗口，手动打开
          _toAppInfo(msg);
        }
      }
    }
  }

  /// 引导文本
  _toMsg(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        if (Platform.isAndroid) {
          return '设置->搜索->权限->app名称->相机->允许';
        }
        if (Platform.isIOS) {
          return '设置->隐私->相机->开启app';
        }
        break;
      case PermissionType.microphone:
        if (Platform.isAndroid) {
          return '设置->搜索->权限->app名称->麦克风->允许';
        }
        if (Platform.isIOS) {
          return '设置->隐私->麦克风->开启app';
        }
    }
  }

  /// 引导窗口
  _toAppInfo(String msg) {
    return showDialog(
        // 点击外部遮罩区域是否可以关闭dialog
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            // 弹窗期间禁用返回键
            onWillPop: () async => false,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText1 ?? const TextStyle(),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 300,
                    constraints: const BoxConstraints(minHeight: 100),
                    color: Colors.amber,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(msg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyButton(
                              textContent: '取消',
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(width: 20),
                            MyButton(
                              textContent: '确定',
                              onTap: () async {
                                await openAppSettings();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
        });
  }
}

enum PermissionType {
  camera, //相机
  microphone, //麦克风
}
