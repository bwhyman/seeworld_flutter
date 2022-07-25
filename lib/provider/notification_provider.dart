
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';


class NotificationController extends GetxController {
  static final FlutterLocalNotificationsPlugin _fp = _create();
  static late News _news;
  static FlutterLocalNotificationsPlugin _create() {
    FlutterLocalNotificationsPlugin fp = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    fp.initialize(InitializationSettings(android: android),
        onSelectNotification: (payload) {
      Get.toNamed(NewsDetailsScreen.name, arguments: _news);
    });
    return fp;
  }

  void showNotification(News news) {
    _news = news;
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var details = NotificationDetails(
      android: androidDetails,
    );
    _fp.show(1001, news.title, '', details);
  }
}