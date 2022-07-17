import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class RecommendNewsContainer extends StatefulWidget {
  final News news;

  const RecommendNewsContainer(this.news, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecommendNewsContainerState();
}

class _RecommendNewsContainerState extends State<RecommendNewsContainer> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());

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
            style: const TextStyle(fontSize: 28),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Text(
                  widget.news.type,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Text(
                widget.news.publishedTime.replaceAll('T', ' ').substring(0, 19),
              )
            ],
          ),
          _widgetProvider.getInfoStatus(),
          Expanded(
            child: Text(
              widget.news.content,
              //maxLines: 12,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
