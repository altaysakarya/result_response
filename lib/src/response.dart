import 'package:result_response/src/enum.dart';

class ResultResponse<T> {
  final ResponseType type;
  final String? message;
  final T? data;

  ResultResponse._(this.type, {this.message, this.data});

  factory ResultResponse.success([String? msg]) =>
      ResultResponse._(ResponseType.success, message: msg);

  factory ResultResponse.error([String? msg]) =>
      ResultResponse._(ResponseType.error, message: msg);

  factory ResultResponse.timeOut([String? msg]) =>
      ResultResponse._(ResponseType.timeOut, message: msg);

  factory ResultResponse.successData([T? data]) =>
      ResultResponse._(ResponseType.success, data: data);

  factory ResultResponse.errorData([T? data]) =>
      ResultResponse._(ResponseType.error, data: data);

  factory ResultResponse.timeOutData([T? data]) =>
      ResultResponse._(ResponseType.timeOut, data: data);

  @override
  String toString() {
    return 'ResponseType: $type, Message: $message, Data: $data';
  }
}
