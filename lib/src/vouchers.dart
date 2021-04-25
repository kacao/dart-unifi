import './controller.dart';

const epHotspot = 'api/s/%site%/cmd/hotspot';
const epStaVoucher = 'api/s/%site%/stat/voucher';

const cmdCreateVoucher = 'create-voucher';
const cmdDeleteVoucher = 'delete-voucher';

class Vouchers {
  UnifiController _controller;

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
      {int count: 1,
      int quota: 1,
      int up,
      int down,
      int megabytes,
      String note}) async {
    var payloads = {
      'minutes': minutes,
      'cmd': cmdCreateVoucher,
      'count': count,
      'quota': quota,
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    final res = await _controller.post(epHotspot, payloads);
    return res[0]['create_time'];
  }

  ///
  /// Returns a list of vouchers since [createTime]
  ///
  Future<List<dynamic>> list({int createTime}) async {
    Map<String, dynamic> payloads = {};
    if (createTime != null) payloads['create_time'] = createTime;
    return await _controller.post(epStaVoucher, payloads);
  }

  ///
  /// Delete a voucher with [id] and return true
  ///
  Future<void> revoke(String id) async {
    var payloads = {'_id': id};
    await _controller.post(epHotspot, payloads);
    return true;
  }
}
