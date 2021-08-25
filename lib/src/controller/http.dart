part of controller;

enum Method { post, get }

class Client {
  late http.Client _client;

  Client() {
    var ioClient = new HttpClient();
    _client = IOClient(ioClient);
  }

  Future<http.Response> fetch(Uri url,
      {Method method: Method.get,
      Map<String, String>? headers,
      Map<String, dynamic>? payloads}) async {
    String body = payloads != null ? jsonEncode(payloads) : '{}';

    http.Response res;
    switch (method) {
      case Method.post:
        {
          res = await _client.post(url, headers: headers, body: body);
        }
        break;
      default:
        {
          res = await _client.post(url, headers: headers);
        }
        break;
    }
    return res;
  }

  Future<http.Response> get(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? payloads}) async {
    return await fetch(url,
        method: Method.get, headers: headers, payloads: payloads);
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? payloads}) async {
    return await fetch(url,
        method: Method.post, headers: headers, payloads: payloads);
  }

  Future<WebSocket> createWebSocket(
      String url, Map<String, String> headers) async {
    return await WebSocket.connect(url, headers: headers);
  }
}
