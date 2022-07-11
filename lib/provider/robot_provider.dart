
import 'dart:convert';

import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class RobotProvider extends GetConnect{
  static const _base_url = 'http://api.qingyunke.com/api.php?key=free&appid=0&msg=';
  
  Future<String?> send(String msg) async {
    msg = Uri.encodeComponent(msg);
    Response resp = await get('$_base_url$msg');
    Map<String, dynamic> json = jsonDecode(resp.body);
    Log.d('RobotUtils', json['content']);
    return json['content'];
  }
}