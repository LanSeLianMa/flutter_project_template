import 'package:flutter_project_template/common/token/token_model.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

import 'hiv_name.dart';

/// 本地储存
class HivManager {
  /// 初始化
  static Future<void> init() async {
    Hive.registerAdapter(TokenModelAdapter());

    // 这里我们使用 和sqflite数据库 同一个目录下
    // 注意：不是存储在sqflite数据库中，hiv自身有数据库，no-sql
    // 获取数据存储的path
    final path = await getDatabasesPath();
    Hive.init(path);

    await Hive.openBox<TokenModel>(HivName.tokenModel);
  }

  static Box<TokenModel> get tokenBox => Hive.box(HivName.tokenModel);

  /// hiv本地存储
  /// para  typeModel：实体类型
  ///       name：注册名称 Constants.xxx

  /// 存
  static void saveDataLocal<T>(T typeModel, String name) {
    if (typeModel == null) {
      return;
    }
    try {
      Hive.box<T>(name).put(0, typeModel);
    } catch (e) {
      print("${T.runtimeType} hiv save error: $e");
    }
  }

  /// 取
  static T? getLocalData<T>(String name) {
    return Hive.box<T>(name).get(0);
  }
}
