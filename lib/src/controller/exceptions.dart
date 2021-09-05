part of 'controller.dart';

class RequestException implements Exception {
  final String message;
  RequestException(this.message);

  toString() {
    return 'Unifi Controller Request Exception: $message';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  toString() {
    return 'Unifi Controller API Exception: [$statusCode] $message';
  }
}

class InvalidCredentials implements Exception {
  final String message;
  InvalidCredentials(this.message);

  toString() {
    return message;
  }
}
