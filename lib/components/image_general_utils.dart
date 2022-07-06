
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'dart:convert';

import 'package:seeworld_flutter/components/signature.dart';


class OcrUtils {

  static const _apiurl = '/api/ocr/v1/general';
  static const _headers = {'Content-Type': "application/json"};

  static String _imageToBase64(String imagePath) {
    var file = File(imagePath);

    var bytes = file.readAsBytesSync();
    Log.d('OcrUtils bytes.length', bytes.length);
    String fileBase64 = const Base64Encoder().convert(bytes);
    return fileBase64;
  }

  static Future<String> send(String imagePath) async {
    String signature = Signature.getSignature(_apiurl, 'POST');
    var url = Uri.parse('https://api-wuxi-1.cmecloud.cn:8443$signature');
    var params = {
      'image': _imageToBase64(imagePath)
    };
    var jsonParams = jsonEncode(params);
    var response = await http.post(url,
        headers: _headers, body: jsonParams);

    var respString = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(respString);
    //print(jsonResponse['items']);
    String result = '';
    for (var item in jsonResponse['items']) {
      result += item['itemstring'];
    }
    return result;
  }

}

