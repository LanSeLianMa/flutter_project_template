import 'package:flutter_project_template/common/utils/function/my_function.dart'
    show dataHandler;

class MusicModelList {
  List<MusicModel>? musicModels;
  int? currentPage;

  MusicModelList({this.musicModels, this.currentPage});

  MusicModelList.fromJson(Map<String, dynamic> json) {
    musicModels = <MusicModel>[];
    currentPage = dataHandler(json, ['data', 'musics', 'current_page'], 0);
    var _list = dataHandler(json, ['data', 'musics', 'data'], 0);
    if (_list != null) {
      for (var element in _list) {
        musicModels!.add(MusicModel.fromJson(element));
      }
    }
  }

  @override
  String toString() {
    return 'MusicModelList{musicModels: $musicModels, currentPage: $currentPage}';
  }
}

class MusicModel {
  int? id;
  String? title;
  String? musician;
  String? url;
  String? cover;

  MusicModel({this.id, this.title, this.musician, this.url, this.cover});

  MusicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    musician = json['musician'];
    url = json['url'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['musician'] = musician;
    data['url'] = url;
    data['cover'] = cover;
    return data;
  }

  @override
  String toString() {
    return 'MusicModel{id: $id, title: $title, musician: $musician, url: $url, cover: $cover}';
  }
}
