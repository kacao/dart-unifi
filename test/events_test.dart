import 'package:test/test.dart';
import './utils.dart';
import 'package:unifi/extensions/vouchers.dart';

Future<void> main() async {
  setUp(() async {
    start();
  });
  tearDown(() async {
    await end();
  });
  group('events', () {
    test('connect', () async {
      //await controller.websocketConnect();
      //await controller.vouchers.list();
    });
  });
}
