import '../lib/unifi.dart';
import 'package:test/test.dart';
import './utils.dart';

void main() {
  setUp(() async {
    start();
  });
  tearDown(() async {
    await end();
  });
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
      await controller.guests.unauthorize(mac);
    });
  });
  group('vouchers', () {
    test('listVouchers', () async {
      await controller.vouchers.list();
    });
  });
}
