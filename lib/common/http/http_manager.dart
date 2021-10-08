import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/hiv/hiv_manager.dart';
import 'package:flutter_project_template/common/hiv/hiv_name.dart';
import 'package:flutter_project_template/common/token/token_model.dart';
import 'package:flutter_project_template/common/widget/load_widget.dart';
import 'package:flutter_project_template/config/main/env/development.dart';
import 'package:flutter_project_template/config/main/env/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

///获取全局context
BuildContext context = navigatorKey!.currentState!.overlay!.context;

/// 接口域名
String logBaseUrl = '';

/// 接口
String logBaseApi = '';

/// 请求管理器
class HttpManager {
  /// 全局静态（单例模式）
  static HttpManager? _instance;

  /// 引入Dio，进行封装
  Dio? _dio;

  /// 连接请求最大时长，单位毫秒
  static const int? connectTimeout = 10000;

  /// 接收请求最大时长，单位毫秒
  static const int? receiveTimeout = 10000;

  /// 发送请求最大时长，单位毫秒
  static const int? sendTimeout = 10000;

  Dio? get http => _dio;

  /// 通过工厂构造函数，可以从缓存中获取一个实例并返回
  factory HttpManager() => _getInstance();

  /// 如果已经存在实例，从缓存中返回原有的实例，反之重新创建，并返回
  static _getInstance() => _instance ??= HttpManager.http();

  /// 初始化
  /// 通过Dio提供BaseOptions对象，创建Dio实例
  HttpManager.http() {
    // 当前使用的是单例模式，只会初始化一次
    // 所以，每次请求更新token，需要写在拦截器中
    var options = BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Accept-Language': 'zh-CN',
      },
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );

    // interceptors：拦截器
    // RequestLog：日志拦截器 默认LogInterceptor()
    // 注意：日志拦截器写在最后面，不然前面添加的拦截器内容，log无法捕捉到
    _dio = Dio(options)
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        TokenModel token =
            HivManager.getLocalData<TokenModel>(HivName.tokenModel) ??
                TokenModel();
        //在请求头中加入token，具体Key的name和后台协商
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        handler.next(options);
      }, onError: (e, handler) {
        closeLoadingWidget(true);
        getNetWork(e);
        handler.next(e);
      }))
      ..interceptors.add(RequestLog());
  }

  /// 请求
  Future<void> request({
    CancelToken? cancelToken, // 取消请求
    bool initData = false,
    String? updateBaseUrl, // 域名
    required String api, // 接口
    Map<String, dynamic>? parameter, // 参数
    RequestType type = RequestType.get, // 请求类型
    Function(Response result)? successCallback, // code码 200 回调
    Function(Response result)? failCallback, // code码 非200 回调
    Function(Object err)? errorCallback, // 异常回调
  }) async {
    Response response;
    logBaseApi = api;

    // 是否更改 接口域名
    if (updateBaseUrl != null) {
      logBaseUrl = updateBaseUrl;
      api = updateBaseUrl + api;
    } else {
      logBaseUrl = Development.apiBaseUrl!;
      api = Development.apiBaseUrl! + api;
    }

    // 加载loading组件
    if (initData) {
      // 绘制view第一帧之后回调
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        loadingWidget();
      });
    }

    //请求类型
    switch (type) {
      case RequestType.get:
        response = await HttpManager()
            .http!
            .get(
              api,
              queryParameters: parameter,
              cancelToken: cancelToken,
            )
            .catchError((err) {
          closeLoadingWidget(initData);
          errorCallback!.call(err);
        });
        break;
      case RequestType.post:
        response = await HttpManager()
            .http!
            .post(
              api,
              queryParameters: parameter,
              cancelToken: cancelToken,
            )
            .catchError((err) {
          closeLoadingWidget(initData);
          errorCallback!.call(err);
        });
        break;
      case RequestType.put:
        response = await HttpManager()
            .http!
            .put(
              api,
              queryParameters: parameter,
              cancelToken: cancelToken,
            )
            .catchError((err) {
          closeLoadingWidget(initData);
          errorCallback!.call(err);
        });
        break;
      case RequestType.delete:
        response = await HttpManager()
            .http!
            .delete(
              api,
              queryParameters: parameter,
              cancelToken: cancelToken,
            )
            .catchError((err) {
          closeLoadingWidget(initData);
          errorCallback!.call(err);
        });
        break;
    }

    if (response.statusCode == HttpStatus.ok) {
      closeLoadingWidget(initData);
      successCallback!.call(response);
    } else {
      closeLoadingWidget(initData);
      failCallback!.call(response);
    }
  }
}

/// 监听网络
getNetWork(DioError error) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(msg: '网络异常');
  } else {
    toastErrInfo(error);
  }
}

/// toast 请求异常信息
toastErrInfo(DioError error) {
  switch (error.type) {
    case DioErrorType.connectTimeout:
      Fluttertoast.showToast(msg: '连接请求超时');
      break;
    case DioErrorType.sendTimeout:
      Fluttertoast.showToast(msg: '发送请求超时');
      break;
    case DioErrorType.receiveTimeout:
      Fluttertoast.showToast(msg: '接收请求超时');
      break;
    case DioErrorType.response:
      Fluttertoast.showToast(msg: '请求未响应');
      break;
    case DioErrorType.cancel:
      Fluttertoast.showToast(msg: '请求被取消');
      break;
    case DioErrorType.other:
      Fluttertoast.showToast(msg: '请求服务器异常');
      break;
  }
}

/// 关闭加载loading组件
closeLoadingWidget(bool initData) {
  if (initData) {
    // 判断栈中是否还有路由
    if (NavigationHistoryObserver().history.isNotEmpty) {
      Navigator.of(context).pop();
    }
  }
}

/// 加载loadingWidget
loadingWidget() {
  showDialog(
      //点击外部遮罩区域是否可以关闭dialog
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          // 弹窗期间禁用返回键
          onWillPop: () async => false,
          child: const LoadWidget(),
        );
      });
}

/// 自定义日志拦截器
class RequestLog extends Interceptor {
  /// 开始请求时间 为了获取请求时长
  DateTime? startRequestTime;

  /// 请求日志
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    DateTime dateTime = DateTime.now();
    _logPrint(key: '$dateTime: Http:requestType', v: options.method);
    _logPrint(key: '$dateTime: Http:baseUrl', v: logBaseUrl);
    _logPrint(key: '$dateTime: Http:api', v: logBaseApi);

    // 完整拼接的url
    // _logPrint(
    //     key: '$dateTime: Http:url', v: '${options.method} ${options.uri}');

    _logPrint(
        key: '$dateTime: Http:parameters', v: '${options.queryParameters}');

    // 打印输出token
    // _logPrint(
    //     key: '$dateTime: Http:token', v: '${options.headers['Authorization']}');

    startRequestTime = dateTime;
    handler.next(options);
  }

  /// 响应日志
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    DateTime dateTime = DateTime.now();
    debugPrint(
        '$dateTime: Http:time -------------- 请求时长: ${(dateTime.second - startRequestTime!.second)}秒 --------------- ');
    _logPrint(key: '$dateTime: Http:status', v: {
      'statusCode': response.statusCode,
      'statusMessage': response.statusMessage
    });
    // 返回的数据
    // _logPrint(key: '$dateTime: Http:response', v: '${response.data}');
    handler.next(response);
  }

  /// 异常日志
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401未登录,跳转登录页面
    if (err.response!.statusCode == HttpStatus.unauthorized) {
      Fluttertoast.showToast(msg: '未经授权，请先登录');
    }
    switch (err.type) {
      case DioErrorType.connectTimeout:
        _logPrint(key: 'DioErrorType.connectTimeout', v: '连接请求超时');
        break;
      case DioErrorType.sendTimeout:
        _logPrint(key: 'DioErrorType.sendTimeout', v: '发送请求超时');
        break;
      case DioErrorType.receiveTimeout:
        _logPrint(key: 'DioErrorType.receiveTimeout', v: '接收请求超时');
        break;
      case DioErrorType.response:
        _logPrint(key: 'DioErrorType.response', v: '请求未响应');
        break;
      case DioErrorType.cancel:
        _logPrint(key: 'DioErrorType.cancel', v: '请求被取消');
        break;
      case DioErrorType.other:
        _logPrint(key: 'DioErrorType.other', v: '请求服务器异常');
        break;
    }
    handler.next(err);
  }

  /// 日志输出
  void _logPrint({required String key, required Object v}) {
    debugPrint('$key -- $v');
  }
}

/// 请求类型
enum RequestType { get, post, put, delete }
