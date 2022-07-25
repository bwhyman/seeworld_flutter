
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/common/newscomment_screen.dart';

class RecommendNewsContainer extends StatefulWidget {
  final News news;

  const RecommendNewsContainer(this.news, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecommendNewsContainerState();
}

class _RecommendNewsContainerState extends State<RecommendNewsContainer> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.news.title,
            style: const TextStyle(fontSize: UI.newsTitleFontSize),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Container(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                      color: _colorProvider.getNewsType(),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    widget.news.type,
                    style: const TextStyle(color: Colors.white, fontSize: UI.newsTypeFontSize),
                  ),
                )),
                Text(
                  widget.news.publishedTime.replaceAll('T', ' ').substring(0, 19),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _widgetProvider.getInfoStatus(widget.news, onCommented: () {
              Get.toNamed(NewsCommentScreen.name, arguments: widget.news);
            }),
          ),
          Expanded(
            child: Text(
              widget.news.content,
              maxLines: 15,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: UI.newsContentFontSize),
            ),
          ),
        ],
      ),
    );
  }
}
