import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class TokenModel {
  @HiveField(0)
  String? accessToken; // 访问token

  @HiveField(1)
  String? refreshToken; // 刷新token

  TokenModel({this.accessToken, this.refreshToken});

  toJson(data) {
    return TokenModel(
      accessToken: data['data']['tokens']['access_token'],
      refreshToken: data['data']['tokens']['refresh_token'],
    );
  }

  @override
  String toString() {
    return 'TokenModel{accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}

class TokenModelAdapter extends TypeAdapter<TokenModel> {
  @override
  TokenModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenModel(
      accessToken: fields[0] as String,
      refreshToken: fields[1] as String,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, TokenModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken);
  }
}
