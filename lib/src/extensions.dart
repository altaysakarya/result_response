
import 'package:result_response/result_response.dart';

extension ResultResponseX on ResultResponse {
  bool get isSuccess => type == ResponseType.success;
  bool get isError => type == ResponseType.error;
  bool get isTimeOut => type == ResponseType.timeOut;
  bool get hasData => data != null;
  bool get isSuccessData => type == ResponseType.success && data != null;
  bool get isTimeOutData => type == ResponseType.timeOut && data != null;
  bool get isErrorData => type == ResponseType.error && data != null;
}

extension FutureResultResponseX<T> on Future<ResultResponse<T>> {
  Future<ResultResponse<T>> onSuccess(Function(ResultResponse<T>)? process) {
    return then((response) {
      if (response.isSuccess && process != null) {
        process(response);
      }
      return response;
    });
  }

  Future<ResultResponse<T>> onError(Function(ResultResponse<T>)? process) {
    return then((response) {
      if (response.isError && process != null) {
        process(response);
      }
      return response;
    });
  }

  Future<ResultResponse<T>> onTimeOut(Function(ResultResponse<T>)? process) {
    return then((response) {
      if (response.isTimeOut && process != null) {
        process(response);
      }
      return response;
    });
  }

  Future<ResultResponse<T>> handleError(Function(Object error)? handle) {
    return catchError((error) {
      if (handle != null) {
        handle(error);
      }
      return ResultResponse<T>.error("Error occurred");
    });
  }
}

extension HttpStatusCodeToResultResponse on int {
  ResultResponse toResultResponse() {
    if (this >= 200 && this < 300) {
      return ResultResponse.success();
    } else if (this == 408) {
      return ResultResponse.timeOut("Request timed out");
    } else {
      return ResultResponse.error("HTTP Error: $this");
    }
  }
}