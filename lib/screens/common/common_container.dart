import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/news.dart';
import 'package:seeworld_flutter/screens/recommend/news_detail_screen.dart';

class CommonContainer extends StatefulWidget {
  const CommonContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CommonContainerState();
}

class CommonContainerState extends State<CommonContainer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<NewsModel>(builder: (context, newModel, w) {
      return ListView.builder(
        itemCount: newModel.listNews().length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              newModel.setCurrentNews(newModel.listNews()[index]);
              Navigator.of(context).pushNamed(NewsDetailsScreen.name);
            },
            child: Card(
              margin: const EdgeInsets.only(top: 8, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newModel.listNews()[index].title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [Text(newModel.listNews()[index].type)],
                  ),
                  Text(
                    newModel.listNews()[index].content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${random100()} 赞同',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Text(' · '),
                      Text('${random10()} 评论',
                          style: const TextStyle(color: Colors.grey))
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  int random100() {
    return Random().nextInt(1000);
  }

  int random10() {
    return Random().nextInt(100);
  }
}
