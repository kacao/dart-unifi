import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client extends Equatable {
	@JsonKey(name: 'site_id') 
	final String? siteId;
	@JsonKey(name: 'assoc_time') 
	final int? assocTime;
	@JsonKey(name: 'latest_assoc_time') 
	final int? latestAssocTime;
	final String? oui;
	@JsonKey(name: 'user_id') 
	final String? userId;
	@JsonKey(name: '_id') 
	final String? id;
	final String? mac;
	@JsonKey(name: 'is_guest') 
	final bool? isGuest;
	@JsonKey(name: 'first_seen') 
	final int? firstSeen;
	@JsonKey(name: 'last_seen') 
	final int? lastSeen;
	@JsonKey(name: 'is_wired') 
	final bool? isWired;
	final String? hostname;
	@JsonKey(name: '_uptime_by_uap') 
	final int? uptimeByUap;
	@JsonKey(name: '_last_seen_by_uap') 
	final int? lastSeenByUap;
	@JsonKey(name: '_is_guest_by_uap') 
	final bool? isGuestByUap;
	@JsonKey(name: 'ap_mac') 
	final String? apMac;
	final int? channel;
	final String? radio;
	@JsonKey(name: 'radio_name') 
	final String? radioName;
	final String? essid;
	final String? bssid;
	@JsonKey(name: 'powersave_enabled') 
	final bool? powersaveEnabled;
	@JsonKey(name: 'is_11r') 
	final bool? is11r;
	final int? ccq;
	final int? rssi;
	final int? noise;
	final int? signal;
	@JsonKey(name: 'tx_rate') 
	final int? txRate;
	@JsonKey(name: 'rx_rate') 
	final int? rxRate;
	@JsonKey(name: 'tx_power') 
	final int? txPower;
	final int? idletime;
	final String? ip;
	@JsonKey(name: 'dhcpend_time') 
	final int? dhcpendTime;
	final int? satisfaction;
	final int? anomalies;
	final int? vlan;
	@JsonKey(name: 'radio_proto') 
	final String? radioProto;
	final int? uptime;
	@JsonKey(name: 'tx_bytes') 
	final int? txBytes;
	@JsonKey(name: 'rx_bytes') 
	final int? rxBytes;
	@JsonKey(name: 'tx_packets') 
	final int? txPackets;
	@JsonKey(name: 'tx_retries') 
	final int? txRetries;
	@JsonKey(name: 'wifi_tx_attempts') 
	final int? wifiTxAttempts;
	@JsonKey(name: 'rx_packets') 
	final int? rxPackets;
	@JsonKey(name: 'bytes-r') 
	final int? bytesR;
	@JsonKey(name: 'tx_bytes-r') 
	final int? txBytesR;
	@JsonKey(name: 'rx_bytes-r') 
	final int? rxBytesR;
	@JsonKey(name: 'qos_policy_applied') 
	final bool? qosPolicyApplied;
	@JsonKey(name: '_uptime_by_usw') 
	final int? uptimeByUsw;
	@JsonKey(name: '_last_seen_by_usw') 
	final int? lastSeenByUsw;
	@JsonKey(name: '_is_guest_by_usw') 
	final bool? isGuestByUsw;
	@JsonKey(name: 'sw_mac') 
	final String? swMac;
	@JsonKey(name: 'sw_depth') 
	final int? swDepth;
	@JsonKey(name: 'sw_port') 
	final int? swPort;
	final String? network;
	@JsonKey(name: 'network_id') 
	final String? networkId;

	const Client({
		this.siteId, 
		this.assocTime, 
		this.latestAssocTime, 
		this.oui, 
		this.userId, 
		this.id, 
		this.mac, 
		this.isGuest, 
		this.firstSeen, 
		this.lastSeen, 
		this.isWired, 
		this.hostname, 
		this.uptimeByUap, 
		this.lastSeenByUap, 
		this.isGuestByUap, 
		this.apMac, 
		this.channel, 
		this.radio, 
		this.radioName, 
		this.essid, 
		this.bssid, 
		this.powersaveEnabled, 
		this.is11r, 
		this.ccq, 
		this.rssi, 
		this.noise, 
		this.signal, 
		this.txRate, 
		this.rxRate, 
		this.txPower, 
		this.idletime, 
		this.ip, 
		this.dhcpendTime, 
		this.satisfaction, 
		this.anomalies, 
		this.vlan, 
		this.radioProto, 
		this.uptime, 
		this.txBytes, 
		this.rxBytes, 
		this.txPackets, 
		this.txRetries, 
		this.wifiTxAttempts, 
		this.rxPackets, 
		this.bytesR, 
		this.txBytesR, 
		this.rxBytesR, 
		this.qosPolicyApplied, 
		this.uptimeByUsw, 
		this.lastSeenByUsw, 
		this.isGuestByUsw, 
		this.swMac, 
		this.swDepth, 
		this.swPort, 
		this.network, 
		this.networkId, 
	});

	factory Client.fromJson(Map<String, dynamic> json) {
		return _$ClientFromJson(json);
	}

	Map<String, dynamic> toJson() => _$ClientToJson(this);

		Client copyWith({
		String? siteId,
		int? assocTime,
		int? latestAssocTime,
		String? oui,
		String? userId,
		String? id,
		String? mac,
		bool? isGuest,
		int? firstSeen,
		int? lastSeen,
		bool? isWired,
		String? hostname,
		int? uptimeByUap,
		int? lastSeenByUap,
		bool? isGuestByUap,
		String? apMac,
		int? channel,
		String? radio,
		String? radioName,
		String? essid,
		String? bssid,
		bool? powersaveEnabled,
		bool? is11r,
		int? ccq,
		int? rssi,
		int? noise,
		int? signal,
		int? txRate,
		int? rxRate,
		int? txPower,
		int? idletime,
		String? ip,
		int? dhcpendTime,
		int? satisfaction,
		int? anomalies,
		int? vlan,
		String? radioProto,
		int? uptime,
		int? txBytes,
		int? rxBytes,
		int? txPackets,
		int? txRetries,
		int? wifiTxAttempts,
		int? rxPackets,
		int? bytesR,
		int? txBytesR,
		int? rxBytesR,
		bool? qosPolicyApplied,
		int? uptimeByUsw,
		int? lastSeenByUsw,
		bool? isGuestByUsw,
		String? swMac,
		int? swDepth,
		int? swPort,
		String? network,
		String? networkId,
	}) {
		return Client(
			siteId: siteId ?? this.siteId,
			assocTime: assocTime ?? this.assocTime,
			latestAssocTime: latestAssocTime ?? this.latestAssocTime,
			oui: oui ?? this.oui,
			userId: userId ?? this.userId,
			id: id ?? this.id,
			mac: mac ?? this.mac,
			isGuest: isGuest ?? this.isGuest,
			firstSeen: firstSeen ?? this.firstSeen,
			lastSeen: lastSeen ?? this.lastSeen,
			isWired: isWired ?? this.isWired,
			hostname: hostname ?? this.hostname,
			uptimeByUap: uptimeByUap ?? this.uptimeByUap,
			lastSeenByUap: lastSeenByUap ?? this.lastSeenByUap,
			isGuestByUap: isGuestByUap ?? this.isGuestByUap,
			apMac: apMac ?? this.apMac,
			channel: channel ?? this.channel,
			radio: radio ?? this.radio,
			radioName: radioName ?? this.radioName,
			essid: essid ?? this.essid,
			bssid: bssid ?? this.bssid,
			powersaveEnabled: powersaveEnabled ?? this.powersaveEnabled,
			is11r: is11r ?? this.is11r,
			ccq: ccq ?? this.ccq,
			rssi: rssi ?? this.rssi,
			noise: noise ?? this.noise,
			signal: signal ?? this.signal,
			txRate: txRate ?? this.txRate,
			rxRate: rxRate ?? this.rxRate,
			txPower: txPower ?? this.txPower,
			idletime: idletime ?? this.idletime,
			ip: ip ?? this.ip,
			dhcpendTime: dhcpendTime ?? this.dhcpendTime,
			satisfaction: satisfaction ?? this.satisfaction,
			anomalies: anomalies ?? this.anomalies,
			vlan: vlan ?? this.vlan,
			radioProto: radioProto ?? this.radioProto,
			uptime: uptime ?? this.uptime,
			txBytes: txBytes ?? this.txBytes,
			rxBytes: rxBytes ?? this.rxBytes,
			txPackets: txPackets ?? this.txPackets,
			txRetries: txRetries ?? this.txRetries,
			wifiTxAttempts: wifiTxAttempts ?? this.wifiTxAttempts,
			rxPackets: rxPackets ?? this.rxPackets,
			bytesR: bytesR ?? this.bytesR,
			txBytesR: txBytesR ?? this.txBytesR,
			rxBytesR: rxBytesR ?? this.rxBytesR,
			qosPolicyApplied: qosPolicyApplied ?? this.qosPolicyApplied,
			uptimeByUsw: uptimeByUsw ?? this.uptimeByUsw,
			lastSeenByUsw: lastSeenByUsw ?? this.lastSeenByUsw,
			isGuestByUsw: isGuestByUsw ?? this.isGuestByUsw,
			swMac: swMac ?? this.swMac,
			swDepth: swDepth ?? this.swDepth,
			swPort: swPort ?? this.swPort,
			network: network ?? this.network,
			networkId: networkId ?? this.networkId,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				siteId,
				assocTime,
				latestAssocTime,
				oui,
				userId,
				id,
				mac,
				isGuest,
				firstSeen,
				lastSeen,
				isWired,
				hostname,
				uptimeByUap,
				lastSeenByUap,
				isGuestByUap,
				apMac,
				channel,
				radio,
				radioName,
				essid,
				bssid,
				powersaveEnabled,
				is11r,
				ccq,
				rssi,
				noise,
				signal,
				txRate,
				rxRate,
				txPower,
				idletime,
				ip,
				dhcpendTime,
				satisfaction,
				anomalies,
				vlan,
				radioProto,
				uptime,
				txBytes,
				rxBytes,
				txPackets,
				txRetries,
				wifiTxAttempts,
				rxPackets,
				bytesR,
				txBytesR,
				rxBytesR,
				qosPolicyApplied,
				uptimeByUsw,
				lastSeenByUsw,
				isGuestByUsw,
				swMac,
				swDepth,
				swPort,
				network,
				networkId,
		];
	}
}
