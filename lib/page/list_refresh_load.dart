import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/http/http_err_model.dart';
import 'package:flutter_project_template/common/utils/stream/h_stream_builder.dart';
import 'package:flutter_project_template/common/utils/viewmodel/base_view.dart';
import 'package:flutter_project_template/common/utils/viewmodel/viewmodel_provider.dart';
import 'package:flutter_project_template/common/widget/data_null_widget.dart';
import 'package:flutter_project_template/model/music_model.dart';
import 'package:flutter_project_template/page/viewmodel/refresh_load_viewmodel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 下拉刷新，上拉加载更多
/// 当前属于MVVM中的 View层
class ListRefreshLoad extends BaseView {
  ListRefreshLoad({Key? key}) : super(key: key);

  /// 是否自动创建 AppBar
  bool get automaticallyImplyAppBar => false;

  @override
  State<StatefulWidget> createState() => ListRefreshLoadState();

}

/// MVVM设计模式
class ListRefreshLoadState extends BaseViewState<ListRefreshLoad> {
  RefreshLoadModel? _refreshLoadModel;

  @override
  void initState() {
    super.initState();
    _refreshLoadModel = ViewModelProvider.of(context, RefreshLoadModel());
    _refreshLoadModel!.init(context, mounted);
  }

  @override
  void dispose() {
    _refreshLoadModel!.dispose(context, mounted);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return HStreamBuilder<HttpErrModel>(
        hStream: _refreshLoadModel!.errModel,
        builder: (context, errModel) {
          if (errModel.data!.errFlag == true) {
            return DataNullWidget(
              msg: errModel.data!.errorType.toString(),
                callback: () {
              _refreshLoadModel!.requestListApi(initData: true);
            });
          }
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: HStreamBuilder<int>(
                  hStream: _refreshLoadModel!.currentPage,
                  builder: (context, snapshot) {
                    return Text('currentPage：${snapshot.data}');
                  }),
            ),
            body: HStreamBuilder<MusicModelList>(
                hStream: _refreshLoadModel!.musicModelList,
                builder: (context, snapshot) {
//              if (snapshot.connectionState == ConnectionState.active) {
//                if (snapshot.data?.musicModels?.isEmpty ?? false) {
//                  return DataNullWidget(callback: () {
//                    _refreshLoadModel!.requestListApi(initData: true);
//                  });
//                }
//              }
                  return SmartRefresher(
                    // 下拉刷新
                    enablePullDown: true,
                    // 上拉加载更多
                    enablePullUp: true,
                    controller: _refreshLoadModel!.refreshController!,
                    onRefresh: _refreshLoadModel!.requestListApi,
                    onLoading: _refreshLoadModel!.requestListApi,
                    child: ListView.builder(
                        itemCount: snapshot.data?.musicModels?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                              key: Key(
                                  "${snapshot.data?.musicModels![index]?.id}"),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(50),
                              child: Text(
                                  '${snapshot.data?.musicModels![index]?.title}'));
                        }),
                  );
                }));
      }
    );
  }
}

/// 非MVVM模式
// class _ListRefreshLoadState extends State<ListRefreshLoad>
//     with RefreshLoadBaseView {
//   HStream<MusicModelList>? _musicModelList;
//   HStream<int>? _currentPage;
//   CancelToken? cancelToken;
//
//   @override
//   void initState() {
//     super.initState();
//     cancelToken = CancelToken();
//     _currentPage = HStream<int>(initialData: 1);
//     _musicModelList = HStream<MusicModelList>(initialData: MusicModelList());
//
//     setRefreshController(
//         controller: RefreshController(),
//         para: ListParameter(
//             updateBaseUrl: 'http://yduixing.cooo.wang/',
//             page: 'page',
//             api: 'api/v2/short_videos/musics',
//             listField: 'data.musics.data',
//             refreshCallback: (json) {
//               if (mounted) {
//                 _musicModelList!.update(MusicModelList.fromJson(json));
//                 _currentPage!
//                     .update(MusicModelList.fromJson(json).currentPage ?? 1);
//                 debugPrint("触发刷新/或初始化+++++++++");
//               }
//             },
//             loadCallback: (json) {
//               _musicModelList!.value.musicModels!
//                   .addAll(MusicModelList.fromJson(json).musicModels!);
//
//               if (mounted) {
//                 _currentPage!
//                     .update(MusicModelList.fromJson(json).currentPage ?? 1);
//                 _musicModelList!.update(_musicModelList!.value);
//               }
//               debugPrint("触发加载更多+++++++");
//             }));
//
//     requestListApi(initData: true);
//   }
//
//   @override
//   void onClose() {
//     if (mounted) {
//       debugPrint('销毁01');
//       cancelToken!.cancel();
//       _musicModelList!.onDispose();
//       _currentPage!.onDispose();
//     }
//     super.onClose();
//   }
//
//   @override
//   void dispose() {
//     onClose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//         color: Colors.white,
//         child: Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: HStreamBuilder<int>(
//                   hStream: _currentPage,
//                   builder: (context, snapshot) {
//                     return Text('currentPage：${snapshot.data}');
//                   }),
//             ),
//             body: HStreamBuilder<MusicModelList>(
//                 hStream: _musicModelList,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     if (snapshot.data?.musicModels?.isEmpty ?? false) {
//                       return DataNullWidget(callback: () {
//                         requestListApi(initData: true);
//                       });
//                     }
//                   }
//                   return SmartRefresher(
//                     // 下拉刷新
//                     enablePullDown: true,
//                     // 上拉加载更多
//                     enablePullUp: true,
//                     controller: refreshController!,
//                     onRefresh: requestListApi,
//                     onLoading: requestListApi,
//                     child: ListView.builder(
//                         itemCount: snapshot.data?.musicModels?.length ?? 0,
//                         itemBuilder: (context, index) {
//                           return Container(
//                               key: Key(
//                                   "${snapshot.data?.musicModels![index]?.id}"),
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.all(50),
//                               child: Text(
//                                   '${snapshot.data?.musicModels![index]?.title}'));
//                         }),
//                   );
//                 })));
//   }
// }
