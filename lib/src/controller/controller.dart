import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' show IOClient;
import '../models.dart';
import '../utils.dart';

//import 'package:logging/logging.dart';

part 'http.dart';
part 'exceptions.dart';
part 'vouchers.dart';
part 'guests.dart';
part 'events.dart';

const siteDefault = 'default';

Map<String, String> defaultHeaders = {
  'Content-Type': 'application/json',
  'Connection': 'keep-alive',
  'Accept': 'application/json'
};

// endpoints
const _epBase = 'proxy/network/';
const _epLogin = 'api/auth/login';
const _epLogout = 'api/auth/logout';
const _epWebsocket = 'wss/s/%site%/events';

class Controller {
  final String host, username, password, siteId;
  final int port;
  late Uri _url, _urlLogin, _urlLogout, _urlWs;
  String _csrfToken = '';
  bool _authenticated = false;

  late Vouchers _vouchers;
  late Guests _guests;
  late Events _events;
  final Client _client = Client();
  Map<String, String> _headers = Map<String, String>.from(defaultHeaders);
  Cookie jar = Cookie("", "");

  get authenticated => _authenticated;
  get events => _events;
  get vouchers => _vouchers;
  get guests => _guests;

  Controller(
      {required this.host,
      this.port: 443,
      required this.username,
      required this.password,
      this.siteId: siteDefault}) {
    _url = Uri.https('$host:$port', "");
    _urlWs =
        Uri.parse("wss://$host:$port").resolve(_epBase).resolve(_epWebsocket);
    _urlLogin = _url.resolve(_epLogin);
    _urlLogout = _url.resolve(_epLogout);

    _vouchers = Vouchers(this);
    _guests = Guests(this);
    _events = Events(this);

    //log.level = Level.ALL;
    //log.onRecord.listen((record) {
    //  print('${record.level.name}: ${record.time}: ${record.message}');
    //});
  }

  factory Controller.fromMap(Map<String, dynamic> map) {
    return Controller(
        host: map['host'],
        port: map['port'],
        username: map['username'],
        password: map['password']);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> payloads,
      {String? siteId, bool authenticate: true}) async {
    return await fetch(endpoint,
        payloads: payloads,
        method: Method.post,
        siteId: siteId,
        authenticate: authenticate);
  }

  Future<dynamic> fetch(String endpoint,
      {Method method: Method.get,
      Map<String, dynamic>? payloads,
      String? siteId,
      bool authenticate: true}) async {
    if (!_authenticated) await login();
    var sid = this.siteId;
    Uri url;

    if (endpoint.contains("login") | (endpoint.contains("logout"))) {
      url = _url.resolve(endpoint);
    } else {
      sid = siteId ?? this.siteId;
      endpoint = endpoint.replaceAll('%site%', sid);
      url = _url.resolve(path.join(_epBase, endpoint));
    }
    final Map<String, String> headers = getHeaders();
    var res = await _client.fetch(url,
        method: method, headers: headers, payloads: payloads);

    if ((res.statusCode == HttpStatus.forbidden) && (authenticate)) {
      if (await login()) {
        return fetch(endpoint,
            method: method,
            payloads: payloads,
            siteId: siteId,
            authenticate: false);
      } else {
        throw RequestException("Unable to login");
      }
    }

    if (res.statusCode == HttpStatus.ok) {
      _collectHeaders(res.headers);
      return jsonDecode(res.body)['data'];
    }

    var msg = '';
    try {
      msg = jsonDecode(res.body).toString();
    } on Exception {
      msg = res.body;
    }
    throw ApiException(res.statusCode, msg);
  }

  Future<bool> login() async {
    var res = await _client.get(_url);
    this._csrfToken = res.headers['x-csrf-token'] ?? "";
    final Map<String, String> payloads = {
      'username': username,
      'password': password
    };
    final headers = getHeaders();
    res = await _client.post(_urlLogin, headers: headers, payloads: payloads);
    _collectHeaders(res.headers);
    if (res.statusCode == HttpStatus.ok) {
      _authenticated = true;
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    var headers = getHeaders();
    var res = await _client.post(_urlLogout, headers: headers);
    if (res.statusCode == HttpStatus.ok) {
      jar = Cookie("", "");
      _csrfToken = "";
      _authenticated = false;
      return true;
    }
    return false;
  }

  Map<String, String> getHeaders() {
    Map<String, String> addons = {
      'Cookie': jar.toString(),
      "x-csrf-token": _csrfToken
    };
    return mergeMaps(_headers, addons);
  }

  ///
  /// update csrf token and cookies based on latest http response
  ///
  void _collectHeaders(Map<String, String> headers) {
    if (headers.containsKey('x-csrf-token'))
      _csrfToken = headers['x-csrf-token'] ?? "";
    if (headers.containsKey('set-cookie'))
      jar = Cookie.fromSetCookieValue(headers['set-cookie']!);
  }

  Future<void> close() async {
    await _events._close();
    await logout();
  }
}
