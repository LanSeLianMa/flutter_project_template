import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    _musicModelList!.onDispose();
    _currentPage!.onDispose();
    cancelToken!.cancel();
    super.onClose();
  }

  @override
  Future doInit(BuildContext context, bool mounted) async {
    refreshData(context, mounted);
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
