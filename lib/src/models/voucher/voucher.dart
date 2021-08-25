import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher extends Equatable {
	@JsonKey(name: '_id') 
	final String? id;
	@JsonKey(name: 'site_id') 
	final String? siteId;
	@JsonKey(name: 'create_time') 
	final int? createTime;
	final String? code;
	@JsonKey(name: 'for_hotspot') 
	final bool? forHotspot;
	@JsonKey(name: 'admin_name') 
	final String? adminName;
	final int? quota;
	final int? duration;
	final int? used;
	@JsonKey(name: 'qos_overwrite') 
	final bool? qosOverwrite;
	final dynamic note;
	final String? status;
	@JsonKey(name: 'status_expires') 
	final int? statusExpires;

	const Voucher({
		this.id, 
		this.siteId, 
		this.createTime, 
		this.code, 
		this.forHotspot, 
		this.adminName, 
		this.quota, 
		this.duration, 
		this.used, 
		this.qosOverwrite, 
		this.note, 
		this.status, 
		this.statusExpires, 
	});

	factory Voucher.fromJson(Map<String, dynamic> json) {
		return _$VoucherFromJson(json);
	}

	Map<String, dynamic> toJson() => _$VoucherToJson(this);

		Voucher copyWith({
		String? id,
		String? siteId,
		int? createTime,
		String? code,
		bool? forHotspot,
		String? adminName,
		int? quota,
		int? duration,
		int? used,
		bool? qosOverwrite,
		dynamic note,
		String? status,
		int? statusExpires,
	}) {
		return Voucher(
			id: id ?? this.id,
			siteId: siteId ?? this.siteId,
			createTime: createTime ?? this.createTime,
			code: code ?? this.code,
			forHotspot: forHotspot ?? this.forHotspot,
			adminName: adminName ?? this.adminName,
			quota: quota ?? this.quota,
			duration: duration ?? this.duration,
			used: used ?? this.used,
			qosOverwrite: qosOverwrite ?? this.qosOverwrite,
			note: note ?? this.note,
			status: status ?? this.status,
			statusExpires: statusExpires ?? this.statusExpires,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				id,
				siteId,
				createTime,
				code,
				forHotspot,
				adminName,
				quota,
				duration,
				used,
				qosOverwrite,
				note,
				status,
				statusExpires,
		];
	}
}
