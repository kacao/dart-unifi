Map<String, String> mergeMaps(Map<String, String> a, b) {
  var c = Map<String, String>.of(a);
  c.addAll(b);
  return c;
}

String addSiteId(String url, String siteId) {
  return url.replaceAll("%site%", siteId);
}

List<Map<String, dynamic>> toList(dynamic data) {
  return List.from(data.map((e) => e as Map<String, dynamic>));
}

Map<String, dynamic> toMap(dynamic data) {
  return data as Map<String, dynamic>;
}
