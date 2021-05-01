import 'controller.dart';

const epStaMgr = 'api/s/%site%/cmd/stamgr';

const cmdAuthorize = 'authorize-guest';
const cmdUnauthorize = 'unauthorize-guest';
const cmdKick = 'kick-sta';
const cmdBlock = 'block-sta';
const cmdUnblock = 'unblock-sta';
const cmdForget = 'forget-sta';

class Guests {
  UnifiController _controller;

  Guests(this._controller);

  ///
  /// Authorize a [mac] for [minutes].
  /// [up]: upload speed in kbps
  /// [down]: download speed in kbps
  /// [megabytes]: data transfer limit in mb
  /// [ap_mac] optional AP's mac
  ///
  /// Returns true
  ///
  Future<bool> authorize(String mac, int minutes,
      {int up, int down, int megabytes, String ap_mac}) async {
    var payloads = {
      'mac': mac,
      'minutes': minutes,
      'cmd': cmdAuthorize,
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    await _controller.post(epStaMgr, payloads);
    return true;
  }

  Future<bool> _post(String ep, String cmd, String mac) async {
    var payloads = {
      'mac': mac,
      'cmd': cmd,
    };
    await _controller.post(ep, payloads);
    return true;
  }

  ///
  /// Unauthorize a [mac].
  ///
  /// Returns true
  ///
  Future<bool> unauthorize(String mac) async {
    return await _post(epStaMgr, cmdUnauthorize, mac);
  }

  ///
  /// Kick (reconnect) a [mac].
  ///
  /// Returns true
  ///
  Future<bool> kick(String mac) async {
    return await _post(epStaMgr, cmdKick, mac);
  }

  ///
  /// Block a [mac].
  ///
  /// Returns true
  ///
  Future<bool> block(String mac) async {
    return await _post(epStaMgr, cmdBlock, mac);
  }

  ///
  /// Unblock a [mac].
  ///
  /// Returns true
  ///
  Future<bool> unblock(String mac) async {
    return await _post(epStaMgr, cmdUnblock, mac);
  }

  ///
  /// Forget a [mac].
  ///
  /// Returns true
  ///
  Future<bool> forget(String mac) async {
    return await _post(epStaMgr, cmdUnblock, mac);
  }
}
