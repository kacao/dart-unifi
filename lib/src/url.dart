import 'package:unifi/src/consts.dart';
import 'package:path/path.dart' as path;

class Url {
  final String host, siteId;
  final int port;
  final bool isUnifiOs;
  late Uri _baseUrl, // https://host:port
      _urlLogin,
      _urlLogout,
      _urlWebsocket;

  get login => _urlLogin;
  get logout => _urlLogout;
  get base => _baseUrl;

  get webSocket => _urlWebsocket;

  Url(
      {required this.host,
      required this.port,
      required this.siteId,
      required this.isUnifiOs})
      : _baseUrl = Uri.https('$host:$port', ""),
        _urlWebsocket = Uri.parse("wss://$host:$port")
            .resolve(isUnifiOs ? Endpoints.base : "")
            .resolve(Endpoints.websocket) {
    if (isUnifiOs) {
      _urlLogin = _baseUrl.resolve('api/auth/' + Endpoints.login);
      _urlLogout = _baseUrl.resolve('api/auth/' + Endpoints.logout);
    } else {
      _urlLogin = _baseUrl.resolve('api/' + Endpoints.login);
      _urlLogout = _baseUrl.resolve(Endpoints.logout);
    }
  }

  Uri resolve(endpoint,
      {String? withSiteId, Map<String, dynamic>? withParams}) {
    if (endpoint.contains("login")) return _urlLogin;
    if (endpoint.contains("logout")) return _urlLogout;

    endpoint = Endpoints.formatSiteId(endpoint, withSiteId ?? siteId);
    return _baseUrl
        .resolve(path.join(isUnifiOs ? Endpoints.base : "", endpoint));
  }
}
