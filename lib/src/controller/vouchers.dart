part of 'controller.dart';

const _epHotspot = 'api/s/%site%/cmd/hotspot';
const _epStaVoucher = 'api/s/%site%/stat/voucher';

const _cmdCreateVoucher = 'create-voucher';
const _cmdDeleteVoucher = 'delete-voucher';

class Vouchers {
  Controller _controller;

  Vouchers(this._controller);

  ///
  /// [minutes]: number of valid minutes after activation
  /// [count]: number of vouchers to create
  /// [quota]: number of claims available
  /// [note]: note
  /// [up]: upload speed in kbps
  /// [down]: download speed in kbps
  /// [megabytes]: data transfer limit in mb
  ///
  /// Returns [create_time]
  ///
  Future<int> create(int minutes,
      {int count = 1,
      int quota: 1,
      int? up,
      int? down,
      int? megabytes,
      String? note,
      String? siteId}) async {
    var payloads = {
      'expire': minutes,
      'cmd': _cmdCreateVoucher,
      'n': count,
      'quota': quota,
      'expire_number': 1,
      'expire_unit': 1440
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    final res = await _controller.post(_epHotspot, payloads, siteId: siteId);
    return res[0]['create_time'];
  }

  ///
  /// Returns a list of [Voucher] since [createTime]
  ///
  Future<List<Voucher>> list({int? createTime, String? siteId}) async {
    Map<String, dynamic> payloads = {};
    if (createTime != null) payloads['create_time'] = createTime;
    List<dynamic> res =
        await _controller.post(_epStaVoucher, payloads, siteId: siteId);
    return List<Voucher>.from(res.map((e) => Voucher.fromJson(e)));
  }

  ///
  /// Delete a voucher with [id]
  /// Throw [ApiException] if not successful
  ///
  Future<void> revoke(String id, {String? siteId}) async {
    var payloads = {'_id': id, 'cmd': _cmdDeleteVoucher};
    await _controller.post(_epHotspot, payloads, siteId: siteId);
  }
}
