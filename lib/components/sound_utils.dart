import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seeworld_flutter/components/signature.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class SoundUtils {
  static const _tag = 'SoundUtils';

  // aac; pcm16WAV, wav; pcm16, pcm
  static const Codec _codec = Codec.pcm16;
  static const _fileName = '/temp.pcm';
  static final _recorder = FlutterSoundRecorder();
  static final _player = FlutterSoundPlayer();
  static String _path = '';
  static const _byteLength = 102400;
  static var _streamId = '';
  static final _headers = {
    'Content-Type': 'application/json',
    'streamId': _streamId,
    'userId': '1',
  };

  static final _params = {
    'sessionParam': {
      'sid': '2',
      'aue': 'raw',
      'eos': '3000',
      'bos': '3000',
      'rate': '16000',
      'rst': 'plain',
    },
    'data': ''
  };

  static void init() async {
    var root = await getTemporaryDirectory();
    _path = root.path + _fileName;

    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    Log.d(_tag, 'sound init');
  }

  static void record() async {
    Log.d(_tag, 'record');
    await _recorder.openRecorder();
    await _recorder.startRecorder(
        codec: _codec, toFile: _path, sampleRate: 16000, numChannels: 1);
  }

  static void stop() async {
    String? result = await _recorder.stopRecorder();
    Log.d(_tag, 'stop');
    await _recorder.closeRecorder();
  }

  static void play() async {
    await _player.openPlayer();
    await _player.startPlayer(
        fromURI: _path, codec: Codec.pcm16, numChannels: 1, sampleRate: 16000);
    Log.d(_tag, 'play');
  }
  // 提交接口
  static const _postApiurl = '/api/lingxiyun/cloud/iat/send_request/v1';

  static Future<String> send() async {
    String signature = Signature.getSignature(_postApiurl, 'POST');
    var url = Uri.parse('https://api-wuxi-1.cmecloud.cn:8443$signature');

    //var root = await getTemporaryDirectory();
    //var file = File( root.path + '/flutter_sound_temp.wav');
    var file = File(_path);
    _streamId = DateTime.now().millisecondsSinceEpoch.toString();
    _headers['streamId'] = _streamId;
    Log.d(_tag, '_streamId: $_streamId');
    var bytes = file.readAsBytesSync();

    String fileBase64 = const Base64Encoder().convert(bytes);
    var l = fileBase64.length;

    // 判断是否超过每帧数据最大值
    int number = (fileBase64.length / _byteLength).ceil();
    _params.remove('endFlag');

    for (var i = 0; i < number; i++) {
      if (number == 1) {
        _headers['number'] = number.toString();
        _params['endFlag'] = '1';
        _params['data'] = fileBase64;
      } else {
        _headers['number'] = (i + 1).toString();
        if (i != number - 1) {
          _params['data'] =
              fileBase64.substring(_byteLength * i, _byteLength * (i + 1));
        } else {
          _params['data'] =
              fileBase64.substring(_byteLength * i, fileBase64.length);
          _params['endFlag'] = '1';
        }
      }
      var jsonParams = jsonEncode(_params);
      Log.d(_tag, jsonParams);
      var response = await http.post(url, headers: _headers, body: jsonParams);
      var respString = utf8.decode(response.bodyBytes);
      Log.d(_tag, respString);
    }
    var result = await getStr();
    return result;
  }

  static final _getHeaders = {
    'streamId': _streamId,
  };
  // 查询接口
  static const _getApiurl = '/api/lingxiyun/cloud/iat/query_result/v1';

  static Future<String> getStr() async {
    String signature = Signature.getSignature(_getApiurl, 'GET');
    var url = Uri.parse('https://api-wuxi-1.cmecloud.cn:8443$signature');
    _getHeaders['streamId'] = _streamId;
    var response = await http.get(url, headers: _getHeaders);
    var respString = response.body;

    Log.d(_tag, 'respString: $respString');
    Map<String, dynamic> jsonResponse = jsonDecode(respString);
    Map<String, dynamic> json2 = jsonResponse['body'];
    List<dynamic> json3 = json2['frame_results'];
    var result = '';
    for (var value in json3) {
      result += value['ansStr'];
    }
    Log.d(_tag, 'result: $result');
    return result;
  }
}
