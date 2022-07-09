
import 'package:flutter_tts/flutter_tts.dart';
import 'package:seeworld_flutter/provider/news_model.dart';

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

  static String _currentRecommendNews = '';

  static void speakRecommendNews(News news) async {
    _currentRecommendNews = '标题: ${news.title}. 内容: ${news.content}';
    _tts.speak(_currentRecommendNews);
  }
  static void speakNews(News news) async {
    String n = '标题: ${news.title}. 内容: ${news.content}';
    _tts.speak(n);
  }

  static void resume() {
    //_tts.speak(_currentNews.substring(_start, _end));
  }


  static void speakContent(String content) {
    _tts.speak(content);
  }

  static void speakProceed() async {
    _tts.speak(_currentRecommendNews);
  }
}