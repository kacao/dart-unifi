List<Map<String, dynamic>> toList(dynamic data) {
  return List.from(data.map((e) => e as Map<String, dynamic>));
}

Map<String, dynamic> toMap(dynamic data) {
  return data as Map<String, dynamic>;
}
