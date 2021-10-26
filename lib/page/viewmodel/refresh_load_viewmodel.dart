import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_template/common/event/event_bus.dart';
import 'package:flutter_project_template/common/http/http_err_model.dart';
import 'package:flutter_project_template/common/utils/list/refresh_load_base_view.dart';
import 'package:flutter_project_template/common/utils/stream/h_stream.dart';
import 'package:flutter_project_template/common/utils/viewmodel/base_view_model.dart';
import 'package:flutter_project_template/model/music_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 逻辑层获取数据
/// 当前属于MVVM中的 Model层
class RefreshLoadModel extends BaseViewModel with RefreshLoadBaseView {
  HStream<MusicModelList>? _musicModelList;
  HStream<int>? _currentPage;
  CancelToken? cancelToken;

  HStream<MusicModelList>? get musicModelList => _musicModelList;
  HStream<int>? get currentPage => _currentPage;
  HStream<HttpErrModel>? get errModel => _errModel;

  var actionEventBus;
  HStream<HttpErrModel> _errModel = HStream<HttpErrModel>(initialData: HttpErrModel());

  bool initFlag = true;

  @override
  Future doInit(BuildContext context, bool mounted) async {

    /// view第一帧之后回调，大概是延迟20毫秒左右
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // 注册监听器
      actionEventBus = eventBus.on<HttpErr>().listen((event) {
        if(event.errorType != null && initFlag){
          _errModel.update(HttpErrModel(errorType: event.errorType, errFlag: true));
        }else {
          _errModel.update(HttpErrModel(errFlag: false));
          initFlag = false;
        }
      });
    });
    refreshData(context, mounted);

  }

  @override
  void dispose(BuildContext context, bool mounted) {
    if (mounted) {
      onClose();
    }
  }

  @override
  void onClose() {
    print('==============');
    print('销毁了');
    print('==============');
    _errModel.onDispose();
    actionEventBus!.cancel();
    _musicModelList!.onDispose();
    _currentPage!.onDispose();
    if(!cancelToken!.isCancelled){
      cancelToken!.cancel();
    }
    super.onClose();
  }

  @override
  Future refreshData(BuildContext context, bool mounted) async {
    cancelToken = CancelToken();
    _currentPage = HStream<int>(initialData: 1);
    _musicModelList = HStream<MusicModelList>(initialData: MusicModelList());

    setRefreshController(
        controller: RefreshController(),
        para: ListParameter(
            updateBaseUrl: 'http://yduixing.cooo.wang/',
            page: 'page',
            api: 'api/v2/short_videos/musics',
            listField: 'data.musics.data',
            cancelToken: cancelToken,
            refreshCallback: (json) {
              if (mounted) {
                _musicModelList!.update(MusicModelList.fromJson(json));
                _currentPage!
                    .update(MusicModelList.fromJson(json).currentPage ?? 1);
                debugPrint("触发刷新/或初始化+++++++++");
              }
            },
            loadCallback: (json) {
              _musicModelList!.value.musicModels!
                  .addAll(MusicModelList.fromJson(json).musicModels!);

              if (mounted) {
                _currentPage!
                    .update(MusicModelList.fromJson(json).currentPage ?? 1);
                _musicModelList!.update(_musicModelList!.value);
              }
              debugPrint("触发加载更多+++++++");
            }));

    requestListApi(initData: true);
  }
}
