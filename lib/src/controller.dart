library unifi;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
//import 'package:logging/logging.dart';
import './utils.dart';
import './http.dart';
import './exceptions.dart';
import './vouchers.dart';
import './guests.dart';
import './events.dart';
import 'package:path/path.dart' as path;

const siteDefault = 'default';

Map<String, String> defaultHeaders = {
  'Content-Type': 'application/json',
  'Connection': 'keep-alive',
  'Accept': 'application/json'
};

// endpoints
const epBase = 'proxy/network/';
const epLogin = 'api/auth/login';
const epLogout = 'api/auth/logout';
const epWebsocket = 'wss/s/%site%/events';

class UnifiController {
  final String host, username, password, siteId;
  Uri _baseUrl, _url, _urlLogin, _urlLogout, _urlWs;
  String _csrfToken;

  Vouchers _vouchers;
  Guests _guests;
  Events _events;

  final int port;
  bool _authenticated = false;
  Map<String, String> _headers = defaultHeaders;
  Cookie jar = Cookie("", "");
  Client _client;
  get authenticated => _authenticated;

  get baseUrl => _baseUrl;

  get events => _events;
  get vouchers => _vouchers;
  get guests => _guests;

  get websocketUrl => _urlWs;

  UnifiController(this.host,
      {this.port: 443,
      this.username: "",
      this.password: "",
      this.siteId: siteDefault}) {
    _url = Uri.https('$host:$port', "");
    _urlWs = Uri.parse("wss://$host:$port")
        .resolve(epBase)
        .resolve(addSiteId(epWebsocket, siteId));
    _urlLogin = _url.resolve(epLogin);
    _urlLogout = _url.resolve(epLogout);

    _client = Client();

    _vouchers = Vouchers(this);
    _guests = Guests(this);
    _events = Events(this, _client);

    //log.level = Level.ALL;
    //log.onRecord.listen((record) {
    //  print('${record.level.name}: ${record.time}: ${record.message}');
    //});
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> payloads,
      {String siteId, bool authenticate: true}) async {
    return await fetch(endpoint,
        payloads: payloads,
        method: Method.post,
        siteId: siteId,
        authenticate: authenticate);
  }

  Future<dynamic> fetch(String endpoint,
      {Method method: Method.get,
      Map<String, dynamic> payloads,
      String siteId,
      bool authenticate: true}) async {
    if (!_authenticated) await login();
    var sid = this.siteId;
    Uri url;

    if (endpoint.contains("login") | (endpoint.contains("logout"))) {
      url = _url.resolve(endpoint);
    } else {
      if (siteId != null) sid = siteId;
      if (sid != null) endpoint = endpoint.replaceAll('%site%', sid);
      url = _url.resolve(path.join(epBase, endpoint));
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
      this._csrfToken = res.headers['x-csrf-token'];

      if (res.headers['Set-Cookie'] != null)
        jar = Cookie.fromSetCookieValue(res.headers['Set-Cookie']);
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
    this._csrfToken = res.headers['x-csrf-token'];
    final Map<String, String> payloads = {
      'username': username,
      'password': password
    };
    final headers = getHeaders();
    res = await _client.post(_urlLogin, headers: headers, payloads: payloads);
    this._csrfToken = res.headers['x-csrf-token'];
    if (res.headers['set-cookie'] != null) {
      jar = Cookie.fromSetCookieValue(res.headers['set-cookie']);
    }
    if (res.statusCode == HttpStatus.ok) {
      _authenticated = true;
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    final headers = getHeaders();
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
    return mergeMaps(
        _headers, {'Cookie': jar.toString(), "x-csrf-token": _csrfToken});
  }

  Future<void> close() async => _events.close();
}
