import 'dart:convert';
import './lib/unifi.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;
import './test/utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

Future<void> listen(UnifiController c) async {
  await c.events.connect();
  await for (var event in c.events.stream) {
    print("type: ${event.type}");
  }
}

Future<void> close(UnifiController c) async {
  Future.delayed(Duration(seconds: 6), () async {
    await c.events.close();
  });
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  Map<String, String> m = {"a": "c"};
  /*String envFile = ".env.test.local." + env["SITE"];
  UnifiController c = loadController(envFile);
  print(await Future.wait([listen(c), close(c)]));*/
}

/*

/ep[A-Z]

*/