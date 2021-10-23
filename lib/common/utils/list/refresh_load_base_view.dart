import 'package:dio/dio.dart';
import 'package:flutter_project_template/common/http/http_manager.dart';
import 'package:flutter_project_template/common/observer/observer.dart';
import 'package:flutter_project_template/common/observer/subject.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../function/my_function.dart' show dataHandler;

/// 刷新/加载更多 基础视图
class RefreshLoadBaseView implements OnClosed{

  /// 分页数
  int page = 1;

  /// 刷新或加载更多 控制器
  RefreshController? refreshController;

  /// 接口参数对象
  ListParameter? parameter;

  /// 单例模式
  setRefreshController(
      {required RefreshController controller, required ListParameter? para}) {
    parameter = para;
    if (refreshController != null) {
      refreshController = controller;
    } else {
      refreshController = RefreshController();
    }
  }

  /// 更新分页数
  updatePage() {
    if (refreshController!.isRefresh) {
      page = 1;
    }

    if (refreshController!.isLoading) {
      page++;
    }
  }

  /// 刷新或加载更多 成功
  /// @parameter
  /// json        数据源
  /// listField   集合字段
  /// callback    回调
  completed(
      {required Map<String, dynamic> json,
      required String listField, // 集合字段
      required Function(bool refresh, bool load) callback}) {
    List<String> _fields = listField.split('.');

    if (refreshController!.isRefresh) {
      refreshController!.refreshCompleted();
      // 重置loadNoData(); 状态
      refreshController!.loadComplete();
    }

    if (refreshController!.isLoading) {
      refreshController!.loadComplete();

      if (dataHandler(json, _fields, 0)?.isEmpty ?? false) {
        if (page > 1) {
          page--;
        }
        refreshController!.loadNoData();
        return;
      } else {
        callback.call(false, true);
        return;
      }
    }
    callback.call(true, false);
  }

  /// 刷新或加载更多 失败
  failed() {
    if (refreshController!.isRefresh) {
      refreshController!.refreshFailed();
    }

    if (refreshController!.isLoading) {
      refreshController!.loadFailed();
    }
  }

  /// 请求列表接口
  requestListApi({bool initData = false}) async {
    updatePage();

    await HttpManager().request(
        refreshController: refreshController,
        cancelToken: parameter!.cancelToken,
        initData: initData,
        updateBaseUrl: parameter!.updateBaseUrl,
        api: "${parameter!.api}?${parameter!.page}=$page",
        successCallback: (result) {
          completed(
              json: result.data,
              listField: "${parameter!.listField}",
              callback: (refresh, load) {
                // 初始化或刷新数据
                if (refresh) {
                  parameter!.refreshCallback!.call(result.data);
                }

                // 加载更多
                if (load) {
                  parameter!.loadCallback!.call(result.data);
                }
              });
        },
        failCallback: (result) {
          failed();
        },
        errorCallback: (err) {
          failed();
        });
  }

  /// 销毁Controller
  @override
  void onClose() {
    print('==============');
    print('销毁refreshController');
    print('==============');
    refreshController?.dispose();
  }

}

/// 销毁接口
abstract class OnClosed {
  void onClose();
}

/// 接口参数对象
/// @parameter
/// cancelToken       取消请求
/// updateBaseUrl     更改域名
/// api               接口
/// listField         集合字段
/// page              分页字段
/// refreshCallback   刷新回调
/// loadCallback      加载更多回调
class ListParameter {
  CancelToken? cancelToken;
  String? updateBaseUrl;
  String? api;
  String? listField;
  String? page;
  Function(Map<String, dynamic>)? refreshCallback;
  Function(Map<String, dynamic>)? loadCallback;

  ListParameter(
      {this.cancelToken,
      this.updateBaseUrl,
      this.api,
      this.listField,
      this.page,
      this.refreshCallback,
      this.loadCallback});
}
