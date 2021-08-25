part of controller;

const _epStaMgr = 'api/s/%site%/cmd/stamgr';
const _epStatGuest = 'api/s/%site%/stat/guest';

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
      {int? up,
      int? down,
      int? megabytes,
      String? ap_mac,
      String? siteId}) async {
    var payloads = {
      'mac': mac,
      'minutes': minutes,
      'cmd': cmdAuthorize,
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    await _controller.post(_epStaMgr, payloads, siteId: siteId);
    return true;
  }

  ///
  /// Unauthorize a [mac].
  ///
  /// Returns true
  ///
  Future<bool> unauthorize(String mac, {String? siteId}) async {
    return await _post(_epStaMgr, cmdUnauthorize, mac, siteId: siteId);
  }

  ///
  /// Kick (reconnect) a [mac].
  ///
  /// Returns true
  ///
  Future<bool> kick(String mac, {String? siteId}) async {
    return await _post(_epStaMgr, cmdKick, mac, siteId: siteId);
  }

  ///
  /// Block a [mac].
  ///
  /// Returns true
  ///
  Future<bool> block(String mac, {String? siteId}) async {
    return await _post(_epStaMgr, cmdBlock, mac, siteId: siteId);
  }

  ///
  /// Unblock a [mac].
  ///
  /// Returns true
  ///
  Future<bool> unblock(String mac, {String? siteId}) async {
    return await _post(_epStaMgr, cmdUnblock, mac, siteId: siteId);
  }

  ///
  /// Forget a [mac].
  ///
  /// Returns true
  ///
  Future<bool> forget(String mac, {String? siteId}) async {
    return await _post(_epStaMgr, cmdUnblock, mac, siteId: siteId);
  }

  ///
  /// List guest devices
  ///
  Future<List<Guest>> list({int? within, String? siteId}) async {
    var ep = within != null ? "${_epStatGuest}?within=${within}" : _epStatGuest;
    var res = toList(await _controller.fetch(ep, siteId: siteId));
    return List<Guest>.of(res.map((e) => Guest.fromJson(e)));
  }

  Future<bool> _post(String ep, String cmd, String mac,
      {String? siteId}) async {
    var payloads = {
      'mac': mac,
      'cmd': cmd,
    };
    await _controller.post(ep, payloads, siteId: siteId);
    return true;
  }
}
