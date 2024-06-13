import 'package:flutter_test/flutter_test.dart';
import 'package:result_response/result_response.dart';

void main() {
  group('ResultResponse', () {
    test('success factory creates a success response', () {
      final response = ResultResponse<String>.success("Operation successful");
      expect(response.type, ResponseType.success);
      expect(response.message, "Operation successful");
      expect(response.data, isNull);
    });

    test('error factory creates an error response', () {
      final response = ResultResponse<String>.error("An error occurred");
      expect(response.type, ResponseType.error);
      expect(response.message, "An error occurred");
      expect(response.data, isNull);
    });

    test('timeOut factory creates a timeout response', () {
      final response = ResultResponse<String>.timeOut("Request timed out");
      expect(response.type, ResponseType.timeOut);
      expect(response.message, "Request timed out");
      expect(response.data, isNull);
    });

    test('successData factory creates a success response with data', () {
      final data = {"key": "value"};
      final response = ResultResponse<Map<String, String>>.successData(data);
      expect(response.type, ResponseType.success);
      expect(response.data, data);
    });

    test('errorData factory creates an error response with data', () {
      final data = {"error": "details"};
      final response = ResultResponse<Map<String, String>>.errorData(data);
      expect(response.type, ResponseType.error);
      expect(response.data, data);
    });

    test('toString provides a correct string representation', () {
      final response = ResultResponse<String>.success("Operation successful");
      expect(response.toString(),
          'ResponseType: ResponseType.success, Message: Operation successful, Data: null');
    });
  });

  group('ResultResponse Extensions', () {
    test('isSuccess returns true for success response', () {
      final response = ResultResponse<String>.success("Operation successful");
      expect(response.isSuccess, isTrue);
    });

    test('isError returns true for error response', () {
      final response = ResultResponse<String>.error("An error occurred");
      expect(response.isError, isTrue);
    });

    test('isTimeOut returns true for timeout response', () {
      final response = ResultResponse<String>.timeOut("Request timed out");
      expect(response.isTimeOut, isTrue);
    });

    test('hasData returns true when data is present', () {
      final response =
          ResultResponse<Map<String, String>>.successData({"key": "value"});
      expect(response.hasData, isTrue);
    });

    test('isSuccessData returns true for success response with data', () {
      final response =
          ResultResponse<Map<String, String>>.successData({"key": "value"});
      expect(response.isSuccessData, isTrue);
    });

    test('isErrorData returns true for error response with data', () {
      final response =
          ResultResponse<Map<String, String>>.errorData({"error": "details"});
      expect(response.isErrorData, isTrue);
    });
  });

  group('Future<ResultResponse> Extensions', () {
    test('onSuccess calls the process function for success response', () async {
      final response =
          Future.value(ResultResponse<String>.success("Operation successful"));
      await response.onSuccess((res) {
        expect(res.isSuccess, isTrue);

        expect(res.message, "Operation successful");
      });
    });

    test('onError calls the process function for error response', () async {
      final response =
          Future.value(ResultResponse<String>.error("An error occurred"));
      await response.onError((res) {
        expect(res.isError, isTrue);
        expect(res.message, "An error occurred");
      });
    });

    test('onTimeOut calls the process function for timeout response', () async {
      final response =
          Future.value(ResultResponse<String>.timeOut("Request timed out"));
      await response.onTimeOut((res) {
        expect(res.isTimeOut, isTrue);
        expect(res.message, "Request timed out");
      });
    });

    test('handleError catches an error and calls the handle function',
        () async {
      final future =
          Future<ResultResponse<String>>.error(Exception("Test exception"));
      await future.handleError((error) {
        expect(error, isException);
        expect(error.toString(), contains("Test exception"));
      });
    });
  });

  group('HttpStatusCodeToResultResponse', () {
    test('should return success for status codes in the range 200-299', () {
      for (int code = 200; code < 300; code++) {
        final response = code.toResultResponse();
        expect(response.type, ResponseType.success);
        expect(response.message, isNull);
        expect(response.data, isNull);
      }
    });

    test('should return timeOut for status code 408', () {
      final response = 408.toResultResponse();
      expect(response.type, ResponseType.timeOut);
      expect(response.message, "Request timed out");
      expect(response.data, isNull);
    });

    test('should return error for status codes outside 200-299 and not 408', () {
      final errorCodes = [100, 300, 400, 500];
      for (int code in errorCodes) {
        final response = code.toResultResponse();
        expect(response.type, ResponseType.error);
        expect(response.message, "HTTP Error: $code");
        expect(response.data, isNull);
      }
    });
  });
}
