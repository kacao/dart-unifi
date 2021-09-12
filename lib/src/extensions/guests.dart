import 'package:unifi/src/controller.dart';
import 'package:unifi/src/consts.dart';
import 'package:unifi/src/utils.dart';

const _extensionKey = "guests";

class Guests extends Ext {
  Guests(BaseController controller) : super(controller);

  ///
  /// Authorize a [mac] for [minutes].
  /// [up]: upload speed in kbps
  /// [down]: download speed in kbps
  /// [megabytes]: data transfer limit in mb
  /// [ap_mac] optional AP's mac
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> authorize(String mac, int minutes,
      {int? up,
      int? down,
      int? megabytes,
      String? ap_mac,
      String? siteId}) async {
    var payloads = {
      'mac': mac,
      'minutes': minutes,
      'cmd': Commands.authorize,
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    await controller.post(Endpoints.staMgr, payloads, siteId: siteId);
  }

  ///
  /// Unauthorize a [mac].
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> unauthorize(String mac, {String? siteId}) async {
    await _postWithMac(Endpoints.staMgr, Commands.unauthorize, mac,
        siteId: siteId);
  }

  ///
  /// Kick (reconnect) a [mac].
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> kick(String mac, {String? siteId}) async {
    await _postWithMac(Endpoints.staMgr, Commands.kick, mac, siteId: siteId);
  }

  ///
  /// Block a [mac].
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> block(String mac, {String? siteId}) async {
    await _postWithMac(Endpoints.staMgr, Commands.block, mac, siteId: siteId);
  }

  ///
  /// Unblock a [mac].
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> unblock(String mac, {String? siteId}) async {
    await _postWithMac(Endpoints.staMgr, Commands.unblock, mac, siteId: siteId);
  }

  ///
  /// Forget a [mac].
  ///
  /// Throw [ApiException] if not successful
  ///
  Future<void> forget(String mac, {String? siteId}) async {
    await _postWithMac(Endpoints.staMgr, Commands.unblock, mac, siteId: siteId);
  }

  ///
  /// List guest devices [within] hours
  /// Throw [ApiException] if not successful
  ///
  Future<List<Map<String, dynamic>>> list({int? within, String? siteId}) async {
    var ep = within != null
        ? "${Endpoints.statGuest}?within=${within}"
        : Endpoints.statGuest;
    var res = toList(await controller.fetch(ep, siteId: siteId));
    //return List<Guest>.of(res.map((e) => Guest.fromJson(e)));
    return res;
  }

  ///
  /// Extends a guest's stay by [id]
  ///
  Future<bool> extend(String id) async {
    return await controller
        .post(Endpoints.hotspot, {'id': id, 'cmd': Commands.extend});
  }

  Future<void> _postWithMac(String ep, String cmd, String mac,
      {String? siteId}) async {
    var payloads = {
      'mac': mac,
      'cmd': cmd,
    };
    return await this.controller.post(ep, payloads);
  }

  void dispose() {}
}

extension GuestsExtension on Controller {
  Guests get guests => this.use(_extensionKey, () => Guests(this)) as Guests;
}

/*mixin GuestsMix on BaseController {
  late Guests _guests = Guests(this);
  Guests get guests => _guests;
}*/
