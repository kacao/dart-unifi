import 'package:unifi/src/controller.dart';
import 'package:unifi/src/consts.dart';
import 'package:unifi/src/utils.dart';

const _extensionKey = 'vouchers';

class Vouchers extends Ext {
  Vouchers(Controller controller) : super(controller);

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
      'cmd': Commands.createVoucher,
      'n': count,
      'quota': quota,
      'expire_number': 1,
      'expire_unit': 1440
    };
    if (up != null) payloads['up'] = up;
    if (down != null) payloads['down'] = down;
    if (megabytes != null) payloads['megabytes'] = megabytes;
    final res =
        await controller.post(Endpoints.hotspot, payloads, siteId: siteId);
    return res[0]['create_time'];
  }

  ///
  /// Returns a list of [Voucher] since [createTime]
  ///
  Future<List<Map<String, dynamic>>> list(
      {int? createTime, String? siteId}) async {
    Map<String, dynamic> payloads = {};
    if (createTime != null) payloads['create_time'] = createTime;
    var res =
        await controller.post(Endpoints.staVoucher, payloads, siteId: siteId);
    //return List<Voucher>.from(res.map((e) => Voucher.fromJson(e)));
    return toList(res);
  }

  ///
  /// Delete a voucher with [id]
  /// Throw [ApiException] if not successful
  ///
  Future<void> revoke(String id, {String? siteId}) async {
    var payloads = {'_id': id, 'cmd': Commands.deleteVoucher};
    await controller.post(Endpoints.hotspot, payloads, siteId: siteId);
  }

  void dispose() {}
}

extension VouchersExtension on Controller {
  Vouchers get vouchers =>
      this.use(_extensionKey, () => Vouchers(this)) as Vouchers;
}
