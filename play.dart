import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:path/path.dart' as path;

const epBase = 'proxy/network/';
const endpoint = 'api/s/default/sta/voucher';

void main() {
  var p = path.join(epBase, endpoint);
  print(p);
  Uri uri = Uri(host: '10.0.245.39');
  print('uri: $uri');
  print(uri.resolve(p));
}
