import 'dart:convert';
import './lib/unifi.dart' as unifi;
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;
import './test/utils.dart';

class Core with Mixit {}

mixin Mixit {
  String _s = "mix";
  void mov() => print(_s);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

Future<void> listen(unifi.Controller c) async {
  await c.events.connect();
  await for (var event in c.events.stream) {
    print("type: ${event.type}");
  }
}

Future<void> close(unifi.Controller c) async {
  Future.delayed(Duration(seconds: 6), () async {
    c.events.dispose();
  });
}

void main() async {
  //HttpOverrides.global = new MyHttpOverrides();
  //Map<String, String> m = {"a": "c"};
  var c = Core();
  c.mov();
}
