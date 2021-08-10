import 'dart:convert';

import '../lib/unifi.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;

//Map<String, String> env = Platform.environment;

void main() {
  UnifiController controller;
  setUp(() async {
    load('.env.test.local.eastvale');
    final host = env['UNIFI_HOST'];
    final port = env['UNIFI_PORT'];
    final username = env['UNIFI_USERNAME'];
    final password = env['UNIFI_PASSWORD'];
    final siteId = env['UNIFI_SITE'];
    controller = UnifiController(host,
        username: username,
        password: password,
        siteId: siteId,
        ignoreBadCert: true);
  });
  tearDown(() async {});
  test("auth", () async {
    expect(await controller.login(), equals(true));
    expect(await controller.logout(), equals(true));
  });
  group('vouchers', () {
    test('list', () async {
      await controller.vouchers.list();
    });
  });
  group('guests', () {
    test('authorize', () async {
      const mac = '00:15:5d:07:cc:14';
      await controller.guests.authorize(mac, 286);
    });
    test('unauthorize', () async {
      const mac = '00:15:5d:07:cc:14';
      //await controller.guests.authorize(mac, 286);
      await controller.guests.unauthorize(mac);
    });
  });
  group('vouchers', () {
    test('listVouchers', () async {
      await controller.vouchers.list();
    });
  });
}
