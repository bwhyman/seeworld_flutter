
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seeworld_flutter/components/logger_utils.dart';

class RobotUtils {
  static const _base_url = 'http://api.qingyunke.com/api.php?key=free&appid=0&msg=';
  
  static Future<String?> send(String msg) async {
    msg = Uri.encodeComponent(msg);
    var response = await http.get(Uri.parse('$_base_url$msg'));
    var respString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> json = jsonDecode(respString);
    Log.d('json', json['content']);
    return json['content'];
  }
}