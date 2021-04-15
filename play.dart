import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class Ok {
  final String msg;
  Ok(String host, {this.msg = ""});
}

bool _certificateCheck(X509Certificate cert, String host, int port) => true;

http.Client getClient() {
  var ioClient = new HttpClient();
  ioClient.badCertificateCallback = _certificateCheck;
  return IOClient(ioClient);
}

const host = "10.0.245.39";

void main() {
  http.Client client = getClient();
  client.get(Uri.https(host, "")).then((http.Response r) {
    print(r.body);
  });
}
