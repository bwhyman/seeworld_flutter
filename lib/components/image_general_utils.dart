import 'dart:io';

import 'package:dio/dio.dart';
import 'package:seeworld_flutter/components/dio_utils.dart';
import 'dart:convert';

import 'package:seeworld_flutter/components/signature.dart';

class OcrUtils {
  static const _apiurl = '/api/ocr/v1/general';
  static const _headers = {'Content-Type': "application/json"};

  static String _imageToBase64(String imagePath) {
    var file = File(imagePath);
    var bytes = file.readAsBytesSync();
    String fileBase64 = const Base64Encoder().convert(bytes);
    return fileBase64;
  }

  static Future<String> send(String imagePath) async {
    String signature = Signature.getSignature(_apiurl, 'POST');
    var params = {'image': _imageToBase64(imagePath)};
    Response resp = await DioUtils.getDio().post('https://api-wuxi-1.cmecloud.cn:8443$signature',
        options: Options(headers: _headers),data: params);
    String result = '';
    for (var item in resp.data['items']) {
      result += item['itemstring'];
    }
    return result;
  }
}
