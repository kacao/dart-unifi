// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
      id: json['_id'] as String,
      authorizedBy: json['authorized_by'] as String,
      unauthorizedBy: json['unauthorized_by'] as String,
      mac: json['mac'] as String,
      siteId: json['site_id'] as String,
      start: json['start'] as int,
      end: json['end'] as int,
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      '_id': instance.id,
      'authorized_by': instance.authorizedBy,
      'unauthorized_by': instance.unauthorizedBy,
      'mac': instance.mac,
      'site_id': instance.siteId,
      'start': instance.start,
      'end': instance.end,
    };
