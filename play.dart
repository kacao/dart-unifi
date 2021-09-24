//import 'dart:convert';
//import './lib/unifi.dart' as unifi;
//import 'package:test/test.dart';
//import 'dart:io';
//import 'package:dotenv/dotenv.dart' show load, env;
//import './test/utils.dart';
import 'package:unifi/unifi.dart' as unifi;
import 'test/helpers.dart';

void main() async {
  //HttpOverrides.global = new MyHttpOverrides();
  //Map<String, String> m = {"a": "c"};
  start();

  controller.login();
  controller.subscribe(onData: (event) => print(event.data));
  end();
}
