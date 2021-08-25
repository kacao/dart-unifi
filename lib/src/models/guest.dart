part of models;

@JsonSerializable()
class Guest {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'authorized_by')
  final String authorizedBy;

  @JsonKey(name: 'unauthorized_by')
  final String unauthorizedBy;

  final String mac;

  @JsonKey(name: 'site_id')
  final String siteId;

  final int start;
  final int end;

  Guest(
      {required this.id,
      required this.authorizedBy,
      required this.unauthorizedBy,
      required this.mac,
      required this.siteId,
      required this.start,
      required this.end});

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);
  Map<String, dynamic> toJson() => _$GuestToJson(this);
}
