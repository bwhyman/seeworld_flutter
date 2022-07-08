
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:seeworld_flutter/components/dio_utils.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class RobotUtils {
  static const _base_url = 'http://api.qingyunke.com/api.php?key=free&appid=0&msg=';
  
  static Future<String?> send(String msg) async {
    msg = Uri.encodeComponent(msg);
    Response resp = await DioUtils.getDio().get('$_base_url$msg');
    Map<String, dynamic> json = jsonDecode(resp.data);
    Log.d('RobotUtils', json['content']);
    return json['content'];
  }
}