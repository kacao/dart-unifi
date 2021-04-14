import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

const endpointLogin = 'api/auth/login';
const endpointLogout = 'api/auth/logout';

class UnifiController {
  final String host, username, password, siteId;
  final String url, urlLogin, urlLogout;
  String _csrfToken;
  final int port;
  Cookie jar = Cookie("", "");

  UnifiController(this.host,
      {this.port: 8443, this.username: "", this.password: "", this.siteId}):
      url = 'https://${host}:${port}';
      urlLogin = '${url}/${endpointLogin}';
      urlLogout = '${url}/${endpointLogout}';

  Future<http.Response> fetch(
    String endpoint,
    String siteId, [
    Map<String, dynamic> payload,
    Map<String, dynamic> options,
  ]) async {
    if (payload == null) payload = {};
    if (options == null) options = {'retry': false};
  }

  void login() async {
    final res = await http.post()
  }

  void logout() async {}
}
