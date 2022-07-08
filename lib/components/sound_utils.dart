import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seeworld_flutter/components/dio_utils.dart';
import 'package:seeworld_flutter/components/robot.dart';
import 'dart:convert';

import 'package:seeworld_flutter/components/signature.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/tts_answers.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/screens/reading/book_favorites.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';

import '../screens/reading/camera.dart';

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
    await _player.openPlayer();
    _path = root.path + _fileName;

    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
  }

  static void record() async {
    Log.d('record()', 'record()');
    await _recorder.openRecorder();
    await _recorder.startRecorder(
        codec: _codec, toFile: _path, sampleRate: 16000, numChannels: 1);
  }

  static FlutterSoundPlayer getPlayer() {
    return _player;
  }

  static void stop(BuildContext context) async {
    String? result = await _recorder.stopRecorder();
    Log.d(_tag, 'stop');
    await _recorder.closeRecorder();
    send().then((value) {
      if (value.contains('设置')) {
        Navigator.of(context).pushNamed(SettingsScreen.name);
        return;
      }
      if (value.contains('同学')) {
        RobotUtils.send(value.replaceAll('同学', '')).then((value) {
          FlutterTtsUtils.getTts().speak(value!);
        });
        return;
      }
      if (value.contains('临时阅读')) {
        Navigator.of(context).pushNamed(TakePictureScreen.name);
        return;
      }
      if (value.contains('我的阅读')) {
        Navigator.of(context).pushNamed(BookFavoritiesScreen.name);
        return;
      }
      FlutterTtsUtils.getTts().speak(TtsAnswersUtils.getUnknowns());
    });
  }

  static void play() async {
    await _player.startPlayer(
        fromURI: _path, codec: Codec.pcm16, numChannels: 1, sampleRate: 16000);
    Log.d(_tag, 'play');
  }

  static const _ttsPath =
      '/sdcard/Android/data/com.example.seeworld_flutter/files/current.wav';
  static int currentPos = 0;

  // 提交接口
  static const _postApiurl = '/api/lingxiyun/cloud/iat/send_request/v1';

  static Future<String> send() async {
    String signature = Signature.getSignature(_postApiurl, 'POST');
    var file = File(_path);

    _streamId = DateTime.now().millisecondsSinceEpoch.toString();
    _headers['streamId'] = _streamId;
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
      Response resp = await DioUtils.getDio().post(
          'https://api-wuxi-1.cmecloud.cn:8443$signature',
          options: Options(headers: _headers),
          data: jsonParams);
      Log.d('Response', resp);
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
    _getHeaders['streamId'] = _streamId;
    Response resp = await DioUtils.getDio().get(
        'https://api-wuxi-1.cmecloud.cn:8443$signature',
        options: Options(headers: _headers));
    List<dynamic> json3 = resp.data['body']['frame_results'];
    var result = '';
    for (var value in json3) {
      result += value['ansStr'];
    }
    Log.d(_tag, 'result: $result');

    return result;
  }
}
