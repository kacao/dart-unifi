# unifi
Unifi Controller API for Dart
(Work in process)

### Installation

```pub add unifi```

### Usage
```
import 'package:unifi/unifi.dart' as unifi;
import 'package:unifi/extensions/vouchers.dart';
import 'package:unifi/extensions/guests.dart';

controller = unifi.Controller(host: host, port: port, username: username, password: password, siteId: siteId);

try {
    var since = await controller.vouchers.create(60);
    await controller.guests.authorize(mac, minutes: 60);
    var vouchers = await controller.vouchers.list(since);

    // events
    controller.stream.listen(
        (unifi.Event event) => print(event)
    )
    await controller.listen();
} 
```
