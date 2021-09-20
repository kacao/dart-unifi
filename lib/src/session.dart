import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:unifi/src/consts.dart';
import 'package:unifi/src/url.dart';
import 'package:unifi/src/cookie.dart';
import 'package:unifi/src/errors.dart';

enum Method { post, get }

const _defaultHeaders = <String, String>{
  'Content-Type': 'application/json',
  'Connection': 'keep-alive',
  'Accept': 'application/json'
};

class Session {
  var _cookies = Cookies();
  var _headers = {..._defaultHeaders};

  final Url _url;
  final String _username;
  final String _password;

  get headers => _headers;
  get url => _url;

  Session(
      {required String host,
      required int port,
      required String username,
      required String password,
      required String siteId,
      required bool isUnifiOs})
      : _url =
            Url(host: host, port: port, isUnifiOs: isUnifiOs, siteId: siteId),
        _username = username,
        _password = password;

  factory Session.fromMap(Map<String, dynamic> map, {bool isUnifiOs = true}) {
    return Session(
        host: map['host'],
        port: map['port'],
        username: map['username'],
        password: map['password'],
        siteId: map['siteId'],
        isUnifiOs: isUnifiOs);
  }

  Future<bool> login() async {
    var res = await get(url: _url.base);
    Map<String, String> payloads = {
      'username': _username,
      'password': _password
    };

    res = await post(
        endpoint: Endpoints.login, headers: _getHeaders(), payloads: payloads);
    _collectHeaders(res.headers);
    return (res.statusCode == HttpStatus.ok);
  }

  Future<bool> logout() async {
    var res = await post(endpoint: Endpoints.logout, headers: _getHeaders());
    _headers = {..._defaultHeaders};
    _cookies.clear();
    return (res.statusCode == HttpStatus.ok);
  }

  Future<http.Response> fetch(
      {String? endpoint,
      Method method: Method.get,
      Map<String, dynamic>? payloads,
      Uri? url,
      bool loginIfUnauthentiated = true,
      String? siteId}) async {
    String body = payloads != null ? jsonEncode(payloads) : '{}';

    if ((endpoint == null) & (url == null))
      throw Exception("Need either endpoint or url");

    var fullUrl = url ?? _url.resolve(endpoint, withSiteId: siteId);

    http.Response res;
    switch (method) {
      case Method.post:
        res = await http.post(fullUrl, headers: _getHeaders(), body: body);
        break;
      default:
        fullUrl = fullUrl.replace(queryParameters: payloads);
        res = await http.get(
          fullUrl,
          headers: _getHeaders(),
        );
        break;
    }
    if (res.statusCode == HttpStatus.ok)
      _collectHeaders(res.headers);
    else if ((res.statusCode == HttpStatus.unauthorized) &&
        (loginIfUnauthentiated)) {
      if (await login())
        return fetch(
            endpoint: endpoint,
            method: method,
            payloads: payloads,
            siteId: siteId,
            loginIfUnauthentiated: false);
      else
        throw InvalidCredentials("Invalid login");
    } else {
      // attempt to extract error messages then throw them at the dev
      var msg = '';
      try {
        msg = jsonDecode(res.body).toString();
      } catch (_) {
        msg = res.body;
      }
      throw ApiException(res.statusCode, msg);
    }
    return res;
  }

  Future<http.Response> get(
      {String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? payloads,
      Uri? url,
      String? siteId}) async {
    return await fetch(
        endpoint: endpoint,
        method: Method.get,
        payloads: payloads,
        url: url,
        siteId: siteId);
  }

  Future<http.Response> post(
      {String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? payloads,
      Uri? url,
      String? siteId}) async {
    return await fetch(
        endpoint: endpoint,
        method: Method.post,
        payloads: payloads,
        url: url,
        siteId: siteId);
  }

  Map<String, String> _getHeaders() => {
        ..._headers,
        if (_cookies.hasCookies) ...{'cookie': _cookies.cookieString}
      };

  void _collectHeaders(Map<String, String> headers) {
    if (headers.containsKey('x-csrf-token'))
      _headers["x-csrf-token"] = headers['x-csrf-token']!;
    _cookies.collect(headers);
  }
}
