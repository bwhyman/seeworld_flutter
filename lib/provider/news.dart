import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/dio_utils.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/notification_utils.dart';

class News {
  int nid;
  String title;
  String content;
  String type;
  String publishedTime;

  News(
      {this.nid = 0,
      this.title = '',
      this.content = '',
      this.type = '',
      this.publishedTime = ''});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      nid: json['nid'] ?? 1001,
      title: json['title'],
      content: json['content'].toString().replaceAll('\\n', '.'),
      type: json['type'],
      publishedTime: json['publishedTime'],
    );
  }
}

class NewsModel with ChangeNotifier {
  late final List<News> _newsList = [];
  late News _currentNews;

  Future<bool> loadNews(BuildContext context) async {
    try {
      Response resp = await DioUtils.getDio().get(
          'http://36.138.192.150:3000/api/news/5');
      List<dynamic> newsList = resp.data['data']['news'];
      _newsList.addAll(newsList.map((e) => News.fromJson(e)).toList());
      notifyListeners();
    } catch (e) {
      Log.d('tag', e);
    }
    return false;
  }

  List<News> listNews() {
    return _newsList;
  }

  setCurrentNews(News n) {
    _currentNews = n;
    notifyListeners();
  }

  getCurrentNews() {
    return _currentNews;
  }

  late Timer _timer;

  void setTimer(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Response resp = await DioUtils.getDio().get(
          'http://36.138.192.150:3001/api/news/push');
      if(resp.data['code'] == 400) {
        return;
      }
      _currentNews = News.fromJson(resp.data['data']['news']);
      NotificationUtils.showNotification(_currentNews, context);
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
