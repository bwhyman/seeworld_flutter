
import 'package:flutter/material.dart';
import 'package:seeworld_flutter/provider/news.dart';

class RecommendNewsContainer extends StatefulWidget {
  final News news;

  const RecommendNewsContainer(this.news, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecommendNewsContainerState();
}

class _RecommendNewsContainerState extends State<RecommendNewsContainer> {
  static const _iconSize = 40.0;

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
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Text(
                  widget.news.type,
                  style: const TextStyle(
                      color: Colors.white,
                    fontSize: 18
                  ),
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
            widget.news.content,
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
