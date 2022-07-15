import 'dart:io';

import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'dart:convert';
import 'package:seeworld_flutter/components/signature.dart';

class OcrProvider extends GetConnect {
  static const tag_name = 'OcrProvider';
  static const _apiurl = '/api/ocr/v1/general';
  static const _headers = {'Content-Type': "application/json"};

  String _imageToBase64(String imagePath) {

    var file = File(imagePath);
    var bytes = file.readAsBytesSync();
    String fileBase64 = const Base64Encoder().convert(bytes);
    return fileBase64;
  }

  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 16);
  }

  Future<String> send(String imagePath) async {

    String signature = Signature.getSignature(_apiurl, 'POST');
    var params = {'image': _imageToBase64(imagePath)};
    File(imagePath).deleteSync();
    Response resp = await post(
        'https://api-wuxi-1.cmecloud.cn:8443$signature', params,
        headers: _headers);
    String result = '';
    // Log.d('resp', resp);
    if(resp.body == null) {
      return result;
    }
    for (var item in resp.body['items']) {
      result += item['itemstring'];
    }
    return result;
  }
}
