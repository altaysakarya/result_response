# Result Response

`result_response` is a Dart library for handling API responses with various response types. It provides a structured way to manage responses and includes useful extensions for handling asynchronous operations.

## Features

- Define different response types: `success`, `error`, `timeOut`
- Factory constructors for creating different types of responses
- Extensions for `ResultResponse` to easily check response types and data
- Extensions for `Future<ResultResponse>` to handle asynchronous operations

## Usage

```dart
import 'package:result_response/result_response.dart';
```

```dart
final successResponse = ResultResponse<String>.success("Operation successful");
final errorResponse = ResultResponse<String>.error("An error occurred");
final timeOutResponse = ResultResponse<String>.timeOut("Request timed out");
final successDataResponse = ResultResponse<Map<String, dynamic>>.successData({"key": "value"});
final errorDataResponse = ResultResponse<Map<String, dynamic>>.errorData({"error": "details"});
```

### Using Extensions

```dart
void main() {
  print(successResponse.isSuccess); // true
  print(errorResponse.isError); // true
  print(timeOutResponse.isTimeOut); // true
  print(successDataResponse.hasData); // true
  print(successDataResponse.isSuccessData); // true
  print(errorDataResponse.isErrorData); // true
}
```

### Handling Asynchronous Responses

```dart
Future<ResultResponse<String>> fetchResponse() async {
  await Future.delayed(Duration(seconds: 2));
  return ResultResponse.success("Fetched successfully");
}

void main() async {
  fetchResponse()
    .onSuccess((response) {
      print("Success: ${response.message}");
    })
    .onError((response) {
      print("Error: ${response.message}");
    })
    .onTimeOut((response) {
      print("Timeout: ${response.message}");
    })
    .handleError((error) {
      print("Error caught: $error");
    });
}
```

## Handling HTTP Status Codes

The `result_response` library also provides an extension to convert HTTP status codes to `ResultResponse` objects. This can be useful for handling HTTP responses in a more structured way.

### Example

```dart
import 'package:result_response/result_response.dart';

void main() {
  final int statusCode = 200;
  final response = statusCode.toResultResponse();
  
  print(response); // Output: ResponseType: ResponseType.success, Message: null, Data: null
  
  final int errorCode = 500;
  final errorResponse = errorCode.toResultResponse();
  
  print(errorResponse); // Output: ResponseType: ResponseType.error, Message: HTTP Error: 500, Data: null
}

## Running Package Tests

```bash
dart test
```