import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './http.dart';
import './exceptions.dart';
import './events.dart';
import './vouchers.dart';
import './guests.dart';
import 'package:path/path.dart' as path;

// endpoints
const epBase = 'proxy/network/';
const epLogin = 'api/auth/login';
const epLogout = 'api/auth/logout';

class UnifiController {
  final String host, username, password, siteId;
  Uri _baseUrl, _url, _urlLogin, _urlLogout, _urlWebsocket;
  String _csrfToken;

  Events _events;
  Vouchers _vouchers;
  Guests _guests;

  final int port;
  bool _authenticated = false;
  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
    'Accept': 'application/json'
  };
  Cookie jar = Cookie("", "");
  Client _client;
  //final Logger log = Logger('unifi');

  get baseUrl => _baseUrl;

  get events => _events;
  get vouchers => _vouchers;
  get guests => _guests;

  UnifiController(this.host,
      {this.port: 443,
      this.username: "",
      this.password: "",
      this.siteId,
      bool ignoreBadCert: false}) {
    _url = Uri.https('$host:$port', "");
    _urlLogin = _url.resolve(epLogin);
    _urlLogout = _url.resolve(epLogout);

    _client = Client(ignoreBadCert: ignoreBadCert);

    _events = Events(this);
    _vouchers = Vouchers(this);
    _guests = Guests(this);

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
    /*print('---');
    print('fetching $url');
    print(payloads);
    print('---');*/
    final headers = getHeaders();
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
    print('error');
    print(payloads);
    print(headers);
    var msg = '';
    try {
      msg = jsonDecode(res.body).toString();
    } on Exception {
      msg = res.body;
    }
    throw ApiException(res.statusCode, msg);
  }

  Future<bool> login() async {
    // obtain csrf token
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
    //log.info("Log in successful.");
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
    //log.finest("Logged out...");
  }

  Map<String, String> getHeaders() {
    return _merge(
        _headers, {'Cookie': jar.toString(), "x-csrf-token": _csrfToken});
  }
}

Map<String, String> _merge(Map<String, String> a, b) {
  var c = Map<String, String>.from(a);
  c.addAll(b);
  return c;
}
