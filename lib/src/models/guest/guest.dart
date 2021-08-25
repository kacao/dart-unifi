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

		Guest copyWith({
		String? id,
		String? siteId,
		String? mac,
		String? userId,
		dynamic hostname,
		String? apMac,
		int? start,
		int? end,
		String? authorizedBy,
		String? userAgent,
		bool? isReturning,
		String? voucherId,
		String? voucherCode,
		String? name,
		bool? expired,
		int? txBytes,
		int? rxBytes,
		int? bytes,
	}) {
		return Guest(
			id: id ?? this.id,
			siteId: siteId ?? this.siteId,
			mac: mac ?? this.mac,
			userId: userId ?? this.userId,
			hostname: hostname ?? this.hostname,
			apMac: apMac ?? this.apMac,
			start: start ?? this.start,
			end: end ?? this.end,
			authorizedBy: authorizedBy ?? this.authorizedBy,
			userAgent: userAgent ?? this.userAgent,
			isReturning: isReturning ?? this.isReturning,
			voucherId: voucherId ?? this.voucherId,
			voucherCode: voucherCode ?? this.voucherCode,
			name: name ?? this.name,
			expired: expired ?? this.expired,
			txBytes: txBytes ?? this.txBytes,
			rxBytes: rxBytes ?? this.rxBytes,
			bytes: bytes ?? this.bytes,
		);
	}

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
