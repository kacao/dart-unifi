import 'package:dotenv/dotenv.dart' show load, env;
import '../lib/unifi.dart';

UnifiController loadController(String envFile) {
  load(envFile);
  final host = env['UNIFI_HOST'];
  final port = env['UNIFI_PORT'];
  final username = env['UNIFI_USERNAME'];
  final password = env['UNIFI_PASSWORD'];
  final siteId = env['UNIFI_SITE'];
  return UnifiController(host,
      username: username,
      password: password,
      siteId: siteId,
      ignoreBadCert: true);
}
