class Endpoints {
  static final hotspot = 'api/s/%site%/cmd/hotspot';
  static final staVoucher = 'api/s/%site%/stat/voucher';

  static final staMgr = 'api/s/%site%/cmd/stamgr';
  static final statGuest = 'api/s/%site%/stat/guest';
}

class Commands {
  static final createVoucher = 'create-voucher';
  static final deleteVoucher = 'delete-voucher';

  static final authorize = 'authorize-guest';
  static final unauthorize = 'unauthorize-guest';
  static final kick = 'kick-sta';
  static final block = 'block-sta';
  static final unblock = 'unblock-sta';
  static final forget = 'forget-sta';
  static final extend = 'extend';
}
