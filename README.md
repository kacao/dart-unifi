# unifi
Unifi Controller API for Dart

### Installation

### Usage
```
import 'package:unifi/unifi.dart';

controller = UnifiController(host: host, port: port, username: username, password: password, siteId: siteId);

try {
    var since = await controller.vouchers.create(60);
    await controller.guests.authorize(mac, minutes: 60);
    var vouchers = await controller.vouchers.list(since);

    // events
    await controller.events.connect();
    await for (var event in controller.events.stream) {
        print("type: ${event.type}");
    }
    
} 
```
