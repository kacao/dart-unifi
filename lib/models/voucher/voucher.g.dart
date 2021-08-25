// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: json['_id'] as String?,
      siteId: json['site_id'] as String?,
      createTime: json['create_time'] as int?,
      code: json['code'] as String?,
      forHotspot: json['for_hotspot'] as bool?,
      adminName: json['admin_name'] as String?,
      quota: json['quota'] as int?,
      duration: json['duration'] as int?,
      used: json['used'] as int?,
      qosOverwrite: json['qos_overwrite'] as bool?,
      note: json['note'],
      status: json['status'] as String?,
      statusExpires: json['status_expires'] as int?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      '_id': instance.id,
      'site_id': instance.siteId,
      'create_time': instance.createTime,
      'code': instance.code,
      'for_hotspot': instance.forHotspot,
      'admin_name': instance.adminName,
      'quota': instance.quota,
      'duration': instance.duration,
      'used': instance.used,
      'qos_overwrite': instance.qosOverwrite,
      'note': instance.note,
      'status': instance.status,
      'status_expires': instance.statusExpires,
    };
