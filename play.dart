import 'package:dotenv/dotenv.dart' as dotenv;

const epHotspot = 'cmd/%site%/hotspot';

void main() {
  print(epHotspot.replaceAll('%site%', 'ok'));
}
