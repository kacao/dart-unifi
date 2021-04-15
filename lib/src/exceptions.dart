class RequestException implements Exception {
  final String message;
  RequestException(this.message);

  toString() {
    return 'Unifi Controller Request Exception: $message';
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  toString() {
    return 'Unifi Controller API Exception: $message';
  }
}
