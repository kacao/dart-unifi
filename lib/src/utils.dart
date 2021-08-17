Map<String, String> mergeMaps(Map<String, String> a, b) {
  var c = Map<String, String>.from(a);
  c.addAll(b);
  return c;
}

String addSiteId(String url, String siteId) {
  return url.replaceAll("%site%", siteId);
}
