import 'dart:convert';

import 'package:flutter_unifi/unifi.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;

//Map<String, String> env = Platform.environment;

void main() {
  UnifiController controller;
  setUp(() async {
    print('setting up');
    load('.env.test.local.eastvale');
    print(Directory.current);
    final host = env['UNIFI_HOST'];
    final port = env['UNIFI_PORT'];
    final username = env['UNIFI_USERNAME'];
    final password = env['UNIFI_PASSWORD'];
    final siteId = env['UNIFI_SITE'];
    print('testing with $username:$password');
    controller = UnifiController(host,
        username: username,
        password: password,
        siteId: siteId,
        ignoreBadCert: true);
  });
  tearDown(() async {});
  test("auth", () async {
    print('authing');
    expect(await controller.login(), equals(true));
    expect(await controller.logout(), equals(true));
  });
  test('vouchers', () async {
    var res = await controller.vouchers.list();
  });
}
