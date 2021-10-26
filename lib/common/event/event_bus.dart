import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class HttpErr {
  DioErrorType? errorType;

  HttpErr({this.errorType});

  @override
  String toString() {
    return 'HttpErr{errorType: $errorType}';
  }
}