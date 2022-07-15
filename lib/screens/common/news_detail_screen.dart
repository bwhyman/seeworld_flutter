
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const name = '/NewsDetailsScreen';
  const NewsDetailsScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NewsDetailsScreenState();

}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final news = ModalRoute.of(context)!.settings.arguments as News;
    _ttsProvider.speakNews(news);
    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar('新闻'),
      body: GestureDetector(
        onDoubleTap: () => _ttsProvider.getTts().stop(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                news.title,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Text(
                      news.type,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                  Text(
                    news.publishedTime.replaceAll('T', ' ').substring(0, 19),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      _getIcon(Icons.thumb_up_alt_outlined),
                      Text('${_random100()}')
                    ],
                  ),
                  Column(
                    children: [
                      _getIcon(Icons.replay_outlined),
                      Text('${_random10()}')
                    ],
                  ),
                  Column(
                    children: [
                      _getIcon(Icons.favorite_outline),
                      Text('${_random10()}')
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                news.content,
                style:
                const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Icon _getIcon(IconData iconData) {
    return Icon(
      iconData,
      color: Colors.indigo,
      size: 32,
    );
  }

  final Random r = Random();
  int _random100() {
    return r.nextInt(1000);
  }

  int _random10() {
    return r.nextInt(100);
  }

  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }
}