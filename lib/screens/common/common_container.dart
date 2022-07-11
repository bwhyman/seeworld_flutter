import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/common_controller.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';

class CommonContainer extends StatelessWidget {
  CommonContainer({Key? key}) : super(key: key);
  final CommonController _commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _commonController.listNews(_commonController.channelItems.first.title);
    return Obx(() => _commonController.commonNews.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _commonController.commonNews.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(NewsDetailsScreen.name,
                      arguments: _commonController.commonNews[index]);
                },
                child: Card(
                  margin: const EdgeInsets.only(top: 8, left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _commonController.commonNews[index].title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(_commonController.commonNews[index].type)
                        ],
                      ),
                      Text(
                        _commonController.commonNews[index].content,
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
          ));
  }

  int random100() {
    return Random().nextInt(1000);
  }

  int random10() {
    return Random().nextInt(100);
  }
}
