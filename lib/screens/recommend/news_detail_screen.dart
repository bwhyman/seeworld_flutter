
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/provider/news.dart';
import 'package:seeworld_flutter/screens/recommend/recommend_container.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const name = '/NewsDetailsScreen';

  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewsDetailsScreenState();

}

class NewsDetailsScreenState extends State<NewsDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Consumer<NewsModel>(
      builder: (_, newsModel, w) {
        FlutterTtsUtils.speakNews(newsModel.getCurrentNews());
        return Scaffold(
          appBar: MyAppBarUtils.getTitleAppbar(context, '新闻'),
          body: RecommendNewsContainer(newsModel.getCurrentNews()),
        );
      },
    );
  }

  @override
  void dispose() {
    FlutterTtsUtils.getTts().stop();
    super.dispose();
  }
}