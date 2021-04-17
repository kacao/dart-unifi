import 'dart:html';

import 'package:dart_unifi/src/http.dart';

import './controller.dart';
import 'package:http/http.dart' as http;

const epHotspot = 'cmd/hotspot';
const epStaVoucher = 'stat/voucher';

const cmdCreateVoucher = 'create-voucher';
const cmdDeleteVoucher = 'delete-voucher';

class Vouchers {
  UnifiController _controller;
  Uri _urlHotspot;

  Vouchers(this._controller) {
    _urlHotspot = _controller.baseUrl.resolve(epHotspot);
  }

  ///
  /// [minutes]: number of valid minutes after activation
  /// [count]: number of vouchers to create
  /// [quota]: number of claims available
  /// [note]: note
  /// [up]: upload speed in kbps
  /// [down]: download speed in kbps
  /// [megabytes]: data transfer limit in mb
  ///
  /// Returns
  ///
  Future<http.Response> create(int minutes,
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
    return await _controller.post(epHotspot, payloads);
  }

  ///
  /// Returns a list of vouchers since [createTime]
  ///
  Future<http.Response> list({int createTime}) async {
    const payloads = {};
    if (createTime != null) payloads['create_time'] = createTime;
    return await _controller.post(epStaVoucher, payloads);
  }

  ///
  /// Returns true when successfully delete a voucher
  ///
  Future<http.Response> revoke(String id) async {
    var payloads = {'_id': id};
    return await _controller.post(epHotspot, payloads);
  }
}
