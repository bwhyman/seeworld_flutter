import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsUtils {
  static final FlutterTts _tts = _create();
  static FlutterTts _create() {
    FlutterTts tts = FlutterTts();
    return tts;
  }
  static FlutterTts getTts({String lang = 'zh'}) {
    _tts.setLanguage(lang);
    return _tts;
  }
}