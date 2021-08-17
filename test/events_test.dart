import 'dart:convert';
import '../lib/unifi.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;
import './utils.dart';

void main() {
  UnifiController controller;
  setUp(() async {
    String envFile = ".env.test.local." + env["SITE"];
    controller = loadController(envFile);
  });
  tearDown(() async {});
  group('vouchers', () {
    test('connect', () async {
      await controller.events.
    });
  });
}
