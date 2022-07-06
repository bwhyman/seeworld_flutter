import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/sound_utils.dart';
import 'package:seeworld_flutter/provider/news.dart';

class FlutterTtsUtils {
  static final FlutterTts _tts = _create();


  static FlutterTts _create() {
    FlutterTts tts = FlutterTts();
    tts.setLanguage('zh');

    return tts;
  }

  static FlutterTts getTts() {
    return _tts;
  }

  static String _currentNews = '';
  static int _currentSpeakTime = 0;
  static void speakNews(News news) async {
    _currentNews = '标题: ${news.title}. 内容: ${news.content}';
    // _tts.setProgressHandler((text, start, end, word) {
    //   Log.d('setProgressHandler', 'setProgressHandler');
    // });
    // _currentSpeakTime = DateTime.now().millisecondsSinceEpoch;
    // await _tts.awaitSpeakCompletion(true);
    _tts.speak(_currentNews);
  }

  static void speakSeek({forward = true}) async {
    int temp = DateTime.now().millisecondsSinceEpoch;
    int dist = temp - _currentSpeakTime;
    int start = (dist / 1000).ceil() * 3;
    int pl = start + (forward ? 12 : -12);
    pl = pl <= 0 ? 0 : pl;
    _tts.speak(_currentNews.substring(pl));
  }

  static void resume() {
    //_tts.speak(_currentNews.substring(_start, _end));
  }


  static void speakContent(String content) {
    _tts.speak(content);
  }

  static void speakProceed() async {
    _tts.speak(_currentNews);
  }
}