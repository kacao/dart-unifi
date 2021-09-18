class Endpoints {
// endpoints
  static final base = 'proxy/network/';
  static final login = 'api/auth/login';
  static final logout = 'api/auth/logout';
  static final websocket = 'wss/s/_site_/events';

  static final hotspot = 'api/s/_site_/cmd/hotspot';
  static final staVoucher = 'api/s/_site_/stat/voucher';

  static final staMgr = 'api/s/_site_/cmd/stamgr';
  static final statGuest = 'api/s/_site_/stat/guest';

  static String formatSiteId(String url, String siteId) =>
      url.replaceAll("_site_", siteId);
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
