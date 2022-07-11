import 'dart:async';

import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/notification_provider.dart';

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
      nid: json['nid'] ?? 0,
      title: json['title'],
      content: json['content'].toString().replaceAll('\\n', '.'),
      type: json['type'],
      publishedTime: json['publishedTime'],
    );
  }
}

class _NewsProvider extends GetConnect {
  
  Future<List<News>> loadNews() async {
    Response resp = await get('http://36.138.192.150:3000/api/news/3');
    List<dynamic> newsList = resp.body['data']['news'];
    return newsList.map((e) => News.fromJson(e)).toList();
  }

  Future<News?> getPushNews() async {
    Response resp = await get('http://36.138.192.150:3001/api/news/push');
    if(resp.body['code'] == 400) {
      return Future.value(null);
    }
    return News.fromJson(resp.body['data']['news']);
  }
}

class RecommendController extends GetxController {
  var recommendNews = <News>[].obs;
  final _newsProvider = Get.put(_NewsProvider());
  final _notificationController = Get.put(NotificationController());
  late Timer _timer;

  Future<bool> listNews() async {
    List<News> ns = await _newsProvider.loadNews();
    recommendNews.addAll(ns);
    return true;
  }
  void setTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      News? n = await _newsProvider.getPushNews();
      if(n == null) {
        return;
      }
      _notificationController.showNotification(n);
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
