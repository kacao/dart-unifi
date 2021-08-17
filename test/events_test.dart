import 'package:test/test.dart';
import './utils.dart';

Future<void> main() async {
  setUp(() async {
    start();
  });
  tearDown(() async {
    await end();
  });
  group('events', () {
    test('connect', () async {});
  });
}
