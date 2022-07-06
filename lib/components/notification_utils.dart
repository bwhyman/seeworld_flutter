
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seeworld_flutter/provider/news.dart';
import 'package:seeworld_flutter/screens/recommend/news_detail_screen.dart';


class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _fp = _create();
  static late BuildContext _context;
  static FlutterLocalNotificationsPlugin _create() {
    FlutterLocalNotificationsPlugin fp = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    fp.initialize(InitializationSettings(android: android),
        onSelectNotification: (payload) {
      Navigator.of(_context).pushNamed(NewsDetailsScreen.name);
    });
    return fp;
  }

  static void showNotification(News news, BuildContext context) {
    _context = context;
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var details = NotificationDetails(
      android: androidDetails,
    );
    _fp.show(news.nid, news.title, '', details);
  }
}