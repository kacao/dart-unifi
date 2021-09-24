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

var isUnifiOs = unifi.Controller.isUnifiOs(host: host, port: port);
controller = unifi.Controller(host: host, port: port, username: username, password: password, siteId: siteId, isUnifiOs: isUnifiOs);

try {
    var since = await controller.vouchers.create(60);
    await controller.guests.authorize(mac, minutes: 60);
    var vouchers = await controller.vouchers.list(since);

    // events
    controller.subscribe(
        (unifi.Event event) => print(event)
    )
} 
```
