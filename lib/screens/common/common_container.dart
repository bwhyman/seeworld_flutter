import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/common_controller.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';

class CommonContainer extends StatelessWidget {
  CommonContainer({Key? key}) : super(key: key);
  final CommonController _commonController = Get.put(CommonController());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _commonController.listNews(_commonController.channelItems.first.title);
    var newsList = _commonController.commonNews;
    return Obx(() => _commonController.commonNews.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              _ttsProvider.speakContent(
                  '为您加载${_commonController.commonNews.length}条${_commonController.currentItem.value.title}新闻');
              return GestureDetector(
                onTap: () {
                  Get.toNamed(NewsDetailsScreen.name,
                      arguments: newsList[index]);
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
                            '${newsList[index].likes} 赞同',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Text(' · '),
                          Text('${newsList[index].comments} 评论',
                              style: const TextStyle(color: Colors.grey))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ));
  }
}
