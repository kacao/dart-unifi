# unifi
Unifi Controller API for Dart

### Installation

### Usage
```
import 'package:unifi/unifi.dart';

controller = UnifiController(host, port: port, username: username, password: password, siteId: siteId);

try {
    var since = await controller.vouchers.create(60);
    await controller.guests.authorize(mac, minutes: 60);
    var vouchers = await controller.vouchers.list(since);
} 
```
