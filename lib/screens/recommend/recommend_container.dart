import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';

class RecommendNewsContainer extends StatefulWidget {
  final News news;

  const RecommendNewsContainer(this.news, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecommendNewsContainerState();
}

class _RecommendNewsContainerState extends State<RecommendNewsContainer> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.news.title,
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
            widget.news.content,
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
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
}
