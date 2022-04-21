import 'dart:io';

import 'package:path_provider/path_provider.dart';

writeFile() async {
  var dir = await getTemporaryDirectory();
  print(dir);
  var file = File('$dir/a.txt');
  file.createSync();
  //file.writeAsBytesSync(bytes)
}