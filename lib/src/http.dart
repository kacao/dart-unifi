library unifi;

import 'dart:async';
import 'dart:io';
import 'dart:convert' show jsonEncode;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' show IOClient;

enum Method { post, get }

class Client {
  http.Client _client;
  HttpClient _wsClient;

  Client() {
    var ioClient = new HttpClient();
    _client = IOClient(ioClient);
    _wsClient = new HttpClient();
  }

  Future<http.Response> fetch(Uri url,
      {Method method: Method.get,
      Map<String, String> headers,
      Map<String, dynamic> payloads}) async {
    String body;
    if (payloads != null) {
      body = jsonEncode(payloads);
    }

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
      {Map<String, String> headers, Map<String, dynamic> payloads}) async {
    return await fetch(url,
        method: Method.get, headers: headers, payloads: payloads);
  }

  Future<http.Response> post(Uri url,
      {Map<String, String> headers, Map<String, dynamic> payloads}) async {
    return await fetch(url,
        method: Method.post, headers: headers, payloads: payloads);
  }

  Future<WebSocket> createWebSocket(
      String url, Map<String, String> headers) async {
    print(headers);
    return await WebSocket.connect(url, headers: headers);
  }
}
