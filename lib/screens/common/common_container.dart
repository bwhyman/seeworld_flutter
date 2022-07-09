import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/news_model.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';

import '../../provider/channel_model.dart';

class CommonContainer extends StatefulWidget {
  const CommonContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CommonContainerState();
}

class CommonContainerState extends State<CommonContainer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<ChannelModel>(builder: (context, channelModel, w) {
      List<News> newsList = channelModel.newsList.value;
      if(newsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(NewsDetailsScreen.name, arguments: newsList[index]);
            },
            child: Card(
              margin: const EdgeInsets.only(top: 8, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsList[index].title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [Text(newsList[index].type)],
                  ),
                  Text(
                    newsList[index].content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
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
