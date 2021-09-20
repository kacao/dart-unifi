class Cookies {
  Map<String, String> _cookies = {};
  get cookies => _cookies;
  get cookieString =>
      _cookies.entries.map((e) => "${e.key}=${e.value}").join(';');
  get hasCookies => _cookies.length > 0;

  void collect(Map<String, String> headers) {
    if (headers.containsKey('set-cookie')) {
      headers['set-cookie']!.split(',').forEach((setCookie) {
        setCookie.split(';').forEach((rawCookie) {
          _collectCookie(rawCookie);
        });
      });
    }
  }

  void clear() => _cookies.clear();

  ///
  /// parse a cookie key=value andd
  ///
  void _collectCookie(String rawCookie) {
    if (rawCookie.isNotEmpty) {
      var cookie = rawCookie.split('=');
      if (cookie.length == 2) {
        var key = cookie[0].trim();
        if (key != 'path' && key != 'expires') _cookies[key] = cookie[1];
      }
    }
  }
}
