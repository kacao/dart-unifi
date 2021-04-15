import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './http.dart';
import './exceptions.dart';

// endpoints
const epBase = '/proxy/network';
const epLogin = 'api/auth/login';
const epLogout = 'api/auth/logout';

class UnifiController {
  final String host, username, password, siteId;
  Uri _baseUrl, _url, _urlLogin, _urlLogout;
  String _csrfToken;
  final int port;
  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
    'Accept': 'application/json'
  };
  Cookie jar = Cookie("", "");
  final _client = Client();
  //final Logger log = Logger('unifi');

  UnifiController(this.host,
      {this.port: 443, this.username: "", this.password: "", this.siteId}) {
    _baseUrl = Uri.https('${host}:${port}', "");
    _url = _baseUrl.resolve(epBase);
    _urlLogin = _baseUrl.resolve(epLogin);
    _urlLogout = _baseUrl.resolve(epLogout);
    //log.level = Level.ALL;
    //log.onRecord.listen((record) {
    //  print('${record.level.name}: ${record.time}: ${record.message}');
    //});
  }

  Future<http.Response> fetch(String endpoint,
      {Method method: Method.get,
      Map<String, dynamic> payloads,
      String siteId,
      bool authenticate: true}) async {
    var sid = this.siteId;
    Uri url;
    if (!endpoint.contains("login") & (!endpoint.contains("logout"))) {
      if (siteId != null) sid = siteId;
      if (sid != null) endpoint = endpoint.replaceFirst("%site%", sid);
      url = _url.resolve(endpoint);
    } else {
      url = _baseUrl.resolve(endpoint);
    }
    final headers = makeHeaders();
    var res = await _client.fetch(url,
        method: method, headers: headers, payloads: payloads);
    this._csrfToken = res.headers['x-csrf-token'];
    if (res.headers['Set-Cookie'] != null)
      jar = Cookie.fromSetCookieValue(res.headers['Set-Cookie']);
    if ((res.statusCode == HttpStatus.unauthorized) && (authenticate)) {
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
    return res;
  }

  Future<bool> login() async {
    // obtain csrf token
    var res = await _client.get(_baseUrl);
    this._csrfToken = res.headers['x-csrf-token'];

    final Map<String, String> payloads = {
      'username': username,
      'password': password
    };
    final headers = makeHeaders();
    res = await _client.post(_urlLogin, headers: headers, payloads: payloads);
    this._csrfToken = res.headers['x-csrf-token'];
    if (res.headers['set-cookie'] != null) {
      jar = Cookie.fromSetCookieValue(res.headers['set-cookie']);
    }
    return (res.statusCode == HttpStatus.ok);
    //log.info("Log in successful.");
  }

  Future<bool> logout() async {
    final headers = makeHeaders();
    var res = await _client.post(_urlLogout, headers: headers);
    jar = Cookie("", "");
    _csrfToken = "";
    return (res.statusCode == HttpStatus.ok);
    //log.finest("Logged out...");
  }

  Map<String, String> makeHeaders() {
    return _merge(
        _headers, {'Cookie': jar.toString(), "x-csrf-token": _csrfToken});
  }
}

Map<String, String> _merge(Map<String, String> a, b) {
  var c = Map<String, String>.from(a);
  c.addAll(b);
  return c;
}
