
import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/provider/news_model.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const name = '/NewsDetailsScreen';
  const NewsDetailsScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => NewsDetailsScreenState();

}

class NewsDetailsScreenState extends State<NewsDetailsScreen> {

  static const _iconSize = 40.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final news = ModalRoute.of(context)!.settings.arguments as News;
    FlutterTtsUtils.speakNews(news);
    return Scaffold(
      appBar: MyAppBarUtils.getTitleAppbar(context, '新闻'),
      body: ListView(
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
              children: const [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.indigo,
                  size: _iconSize,
                ),
                Icon(
                  Icons.replay_outlined,
                  color: Colors.indigo,
                  size: _iconSize,
                ),
                Icon(
                  Icons.favorite_border,
                  color: Colors.indigo,
                  size: _iconSize,
                ),
                Icon(
                  Icons.star_outline_rounded,
                  color: Colors.indigo,
                  size: _iconSize,
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              news.content,
              style:
              const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    FlutterTtsUtils.getTts().stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }
}