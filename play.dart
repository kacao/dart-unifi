import 'dart:convert';
import './lib/unifi.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;
import './test/utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  String envFile = ".env.test.local." + env["SITE"];
  UnifiController c = loadController(envFile);
  await c.events.connect();
  print('delay');
  await Future.delayed(
      Duration(seconds: 6),
      () async => {
            await for (var event in c.events.stream) {print(event.type)}
            //await c.events.close();
          });
}
