import 'package:dio/dio.dart';

class HttpErrModel {
  bool? errFlag;
  DioErrorType? errorType;

  HttpErrModel({this.errFlag, this.errorType});

  @override
  String toString() {
    return 'HttpErrModel{errFlag: $errFlag, errorType: $errorType}';
  }
}