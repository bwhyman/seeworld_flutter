
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/entity.dart';

class TtsProvider extends GetxController {
  static final FlutterTts _tts = _create();


  static FlutterTts _create() {
    FlutterTts tts = FlutterTts();
    tts.setLanguage('zh');

    return tts;
  }

  FlutterTts getTts() {
    return _tts;
  }

  static String _currentRecommendNews = '';

  void speakRecommendNews(News news) async {
    _currentRecommendNews = '标题: ${news.title}. 内容: ${news.content}';
    _tts.speak(_currentRecommendNews);
  }
  void speakNews(News news) async {
    String n = '标题: ${news.title}. 内容: ${news.content}';
    _tts.speak(n);
  }

  Future speakContent(String content) async {
    return _tts.speak(content);
  }

  void speakProceed() async {
    _tts.speak(_currentRecommendNews);
  }
}