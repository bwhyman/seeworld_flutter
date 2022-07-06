
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seeworld_flutter/screens/recommend/news_detail_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyHomeState();

}

class MyHomeState extends State<MyHome> {
  final FlutterLocalNotificationsPlugin fp = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
  }

  show() {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    fp.initialize(InitializationSettings(android: android),
        onSelectNotification: (payload) {
          Navigator.of(context).pushNamed(NewsDetailsScreen.name);
    });
    var androidDetails = const AndroidNotificationDetails(
        'id 描述',
        '名称描述',
        importance: Importance.max,
        priority: Priority.high,
    );
    var details = NotificationDetails(
      android: androidDetails,
    );
    Future.delayed(const Duration(seconds: 2), () async {
      await fp.show(1, 'title', '', details);
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: TextButton(
        onPressed: () {
          show();
        },
        child: Text('add'),
      ),
    );
  }
}
