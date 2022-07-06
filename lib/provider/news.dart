import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class News {
  int nid;
  String title;
  String content;
  String type;
  String publishedTime;

  News(
      {this.nid = 0, this.title = '', this.content = '', this.type = '', this.publishedTime = ''});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      nid: json['nid'],
      title: json['title'],
      content: json['content'],
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
      Response resp = await get(
          Uri.parse('http://36.138.192.150:3000/api/news/5'));
      var respString = utf8.decode(resp.bodyBytes);
      respString = respString.replaceAll('\\n', '');
      var jsonResponse = jsonDecode(respString);
      List<dynamic> newsList = jsonResponse['data']['news'];
      _newsList.addAll(newsList.map((e) => News.fromJson(e)).toList());
      notifyListeners();
      return true;
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
}