import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'site_id')
  final String? siteId;
  final String? mac;
  @JsonKey(name: 'user_id')
  final String? userId;
  final dynamic hostname;
  @JsonKey(name: 'ap_mac')
  final String? apMac;
  final int? start;
  final int? end;
  @JsonKey(name: 'authorized_by')
  final String? authorizedBy;
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @JsonKey(name: 'is_returning')
  final bool? isReturning;
  @JsonKey(name: 'voucher_id')
  final String? voucherId;
  @JsonKey(name: 'voucher_code')
  final String? voucherCode;
  final String? name;
  final bool? expired;
  @JsonKey(name: 'tx_bytes')
  final int? txBytes;
  @JsonKey(name: 'rx_bytes')
  final int? rxBytes;
  final int? bytes;

  const Guest({
    this.id,
    this.siteId,
    this.mac,
    this.userId,
    this.hostname,
    this.apMac,
    this.start,
    this.end,
    this.authorizedBy,
    this.userAgent,
    this.isReturning,
    this.voucherId,
    this.voucherCode,
    this.name,
    this.expired,
    this.txBytes,
    this.rxBytes,
    this.bytes,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      siteId,
      mac,
      userId,
      hostname,
      apMac,
      start,
      end,
      authorizedBy,
      userAgent,
      isReturning,
      voucherId,
      voucherCode,
      name,
      expired,
      txBytes,
      rxBytes,
      bytes,
    ];
  }
}
