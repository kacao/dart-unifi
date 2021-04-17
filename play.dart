import 'package:dart_unifi/unifi.dart';

const host = "10.0.245.39";
const username = 'wifi';
const password = "WifiWifi9";

Future<void> run() async {
  UnifiController controller = UnifiController(host,
      username: username, password: password, ignoreBadCert: true);
  await controller.login();
  controller.events.onData((dynamic message) {
    print(message);
  }).listen();
}

void main() {
  run().then((v) {});
}
