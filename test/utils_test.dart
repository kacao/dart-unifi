import 'package:test/test.dart';

import 'package:unifi/src/consts.dart';
import 'package:unifi/src/url.dart';
import 'package:unifi/src/cookie.dart';

void main() {
  setUp(() async {});
  tearDown(() async {});
  group('url', () {
    test('resolve', () async {
      Url url =
          Url(isUnifiOs: true, host: 'localhost', port: 443, siteId: 'default');

      expect(url.login.toString(), equals("https://localhost/api/auth/login"));
      expect(
          url.logout.toString(), equals("https://localhost/api/auth/logout"));
      expect(url.resolve(Endpoints.staVoucher).toString(),
          equals("https://localhost/proxy/network/api/s/default/stat/voucher"));

      url = Url(
          isUnifiOs: false, host: 'localhost', port: 443, siteId: 'default');

      expect(url.login.toString(), equals("https://localhost/api/login"));
      expect(url.logout.toString(), equals("https://localhost/api/logout"));
      expect(url.resolve(Endpoints.staVoucher).toString(),
          equals("https://localhost/api/s/default/stat/voucher"));
    });
  });

  test('cookies', () {
    var cookies = Cookies();
    cookies.collect(<String, String>{
      "set-cookie":
          "TOKEN=eyJNzgxNTM5fQ.Rcv3LXTWtvaO3-3X43jZ5M-n03gaqLlGgcBIYzo3Z0M; path=/; secure; httponly"
    });
    expect(cookies.hasCookies, equals(true));
    expect(cookies.cookieString,
        "TOKEN=eyJNzgxNTM5fQ.Rcv3LXTWtvaO3-3X43jZ5M-n03gaqLlGgcBIYzo3Z0M");
  });
}
