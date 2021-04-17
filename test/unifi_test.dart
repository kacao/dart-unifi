import 'package:dart_unifi/unifi.dart';
import 'package:test/test.dart';

const host = "10.0.245.39";
const username = 'wifi';
const password = "WifiWifi9";
void main() {
  UnifiController controller;
  setUp(() async {
    controller = UnifiController(host,
        username: username, password: password, ignoreBadCert: true);
  });
  tearDown(() async {});
  test("auth", () async {
    expect(await controller.login(), equals(true));
    expect(await controller.logout(), equals(true));
  });
}
