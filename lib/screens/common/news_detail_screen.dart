import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/common/newscomment_screen.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const name = '/NewsDetailsScreen';

  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  late News _news;
  final ColorProvider _colorProvider = Get.put(ColorProvider());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _news = Get.arguments as News;
    _ttsProvider.speakNews(_news);
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('新闻'),
      floatingActionButton:
          _floatingButtonProvider.getFloatingRecordButton(onRecorded: onRecord),
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      body: GestureDetector(
        onDoubleTap: () => _ttsProvider.getTts().stop(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _news.title,
                style: const TextStyle(fontSize: UI.newsTitleFontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Container(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                            color: _colorProvider.getNewsType(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Text(
                          _news.type,
                          style: const TextStyle(
                              color: Colors.white, fontSize: UI.newsTypeFontSize),
                        ),
                      )),
                  Text(
                    _news.publishedTime.replaceAll('T', ' ').substring(0, 19),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _widgetProvider.getInfoStatus(_news, onCommented: () {
                Get.toNamed(NewsCommentScreen.name, arguments: _news);
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                _news.content,
                style: const TextStyle(fontSize: UI.newsContentFontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }

  void onRecord(String string) {
    if (string == '加载评论') {
      Get.toNamed(NewsCommentScreen.name, arguments: _news);
    }
  }
}
