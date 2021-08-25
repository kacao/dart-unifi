import '../lib/unifi.dart';
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
      int since = await controller.vouchers.create(24);
      expect(since, greaterThan(0));
      List<Voucher> vouchers = await controller.vouchers.list();
      expect(vouchers.length, greaterThan(0));
      vouchers.forEach((element) async {
        await controller.vouchers.revoke(element.id);
      });
    });
  });
  group('guests', () {
    test('list', () async {
      List<Guest> res = await controller.guests.list();
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
