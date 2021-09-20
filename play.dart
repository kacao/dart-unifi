//import 'dart:convert';
//import './lib/unifi.dart' as unifi;
//import 'package:test/test.dart';
//import 'dart:io';
//import 'package:dotenv/dotenv.dart' show load, env;
//import './test/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  //HttpOverrides.global = new MyHttpOverrides();
  //Map<String, String> m = {"a": "c"};
  IOWebSocketChannel.connect();
}
