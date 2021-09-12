import 'package:unifi/unifi.dart' as unifi;
import 'package:unifi/extensions/vouchers.dart';
import 'package:unifi/extensions/guests.dart';
import 'package:test/test.dart';
import 'utils.dart';

void main() {
  setUp(() async {
    start();
  });
  tearDown(() async {
    await end();
  });
  test("auth", () async {
    expect(await controller.login(), equals(true));
    //expect(await controller.logout(), equals(true));
  });
  group('vouchers', () {
    test('create/list/revoke', () async {
      int since = await controller.vouchers.create(1440);
      expect(since, greaterThan(0));
      List<Map<String, dynamic>> vouchers = await controller.vouchers.list();
      expect(vouchers.length, greaterThan(0));
      vouchers.forEach((element) async {
        await controller.vouchers.revoke(element["_id"]);
      });
    });
  });
  group('guests', () {
    test('list', () async {
      List<Map<String, dynamic>> res = await controller.guests.list();
    });
    test('authorize', () async {
      const mac = '00:15:5d:07:cc:14';
      await controller.guests.authorize(mac, 286);
    });
    test('unauthorize', () async {
      const mac = '00:15:5d:07:cc:14';
      await controller.guests.unauthorize(mac);
    });
  });
}
