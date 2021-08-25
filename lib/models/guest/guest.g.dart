// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
      id: json['_id'] as String?,
      siteId: json['site_id'] as String?,
      mac: json['mac'] as String?,
      userId: json['user_id'] as String?,
      hostname: json['hostname'],
      apMac: json['ap_mac'] as String?,
      start: json['start'] as int?,
      end: json['end'] as int?,
      authorizedBy: json['authorized_by'] as String?,
      userAgent: json['user_agent'] as String?,
      isReturning: json['is_returning'] as bool?,
      voucherId: json['voucher_id'] as String?,
      voucherCode: json['voucher_code'] as String?,
      name: json['name'] as String?,
      expired: json['expired'] as bool?,
      txBytes: json['tx_bytes'] as int?,
      rxBytes: json['rx_bytes'] as int?,
      bytes: json['bytes'] as int?,
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      '_id': instance.id,
      'site_id': instance.siteId,
      'mac': instance.mac,
      'user_id': instance.userId,
      'hostname': instance.hostname,
      'ap_mac': instance.apMac,
      'start': instance.start,
      'end': instance.end,
      'authorized_by': instance.authorizedBy,
      'user_agent': instance.userAgent,
      'is_returning': instance.isReturning,
      'voucher_id': instance.voucherId,
      'voucher_code': instance.voucherCode,
      'name': instance.name,
      'expired': instance.expired,
      'tx_bytes': instance.txBytes,
      'rx_bytes': instance.rxBytes,
      'bytes': instance.bytes,
    };
