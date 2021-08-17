library unifi;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import './controller.dart';
import 'package:logging/logging.dart';
import './exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

enum Method { post, get }

class Client {
  http.Client _client;
  HttpClient _wsClient;

  Client({bool ignoreBadCert = false}) {
    var ioClient = new HttpClient();
    _wsClient = new HttpClient();
    if (ignoreBadCert) ioClient.badCertificateCallback = (_, __, ___) => true;
    if (ignoreBadCert) _wsClient.badCertificateCallback = (_, __, ___) => true;
    _client = IOClient(ioClient);
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

  Future<WebSocket> webSocket(String url, Map<String, String> headers) async {
    return await WebSocket.connect(url, headers: headers);
  }

  ///
  /// Detach a socket for upgrading to websocket
  ///
  Future<WebSocket> createWebSocket(Uri url,
      {Map<String, String> headers}) async {
    Random r = new Random();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
    HttpClientRequest request = await _wsClient.getUrl(url);
    request.headers.add('Connection', 'upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers.add('sec-websocket-version', '13');
    request.headers.add('sec-websocket-key', key);
    if (headers != null) {
      for (MapEntry<String, String> entry in headers.entries) {
        request.headers.add(entry.key, entry.value);
      }
    }
    print('before close');
    print(request.headers);
    HttpClientResponse response = await request.close();
    print("HERE: ${response.statusCode}");
    print(response.reasonPhrase);
    SecureSocket socket = await response.detachSocket();
    return WebSocket.fromUpgradedSocket(socket, serverSide: false);
  }
}
