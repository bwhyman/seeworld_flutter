/*
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordProvider extends GetConnect {
  static const _fileName = '/temp.mkv';
  final record = Record();
  static String _path = '';

  init() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
  }

  recorded() async {
    if (await record.hasPermission()) {
      var root = await getTemporaryDirectory();
      _path = root.path + _fileName;
      await record.start(
        path: _path,
        encoder: AudioEncoder.opus, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }
  }
  stop() async {
    await record.stop();
  }

  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 12);
  }
}
*/
