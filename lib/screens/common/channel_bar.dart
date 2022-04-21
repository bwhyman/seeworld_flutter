import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/global_provider.dart';

class MyChannel extends StatelessWidget {
  static const _titles = {
    '国内',
    '国际',
    '政治',
    '军事',
    '财经',
    '体育',
    '生活',
    '教育',
    '科技',
    '娱乐',
    '游戏',
  };

  const MyChannel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: getItems(),
      ),
    );
  }

  List<_ChannelItemWidget> getItems() {
    List<_ChannelItemWidget> items = [];
    for (int i = 0; i < _titles.length; i++) {
      items.add(_ChannelItemWidget(ChannelItem(_titles.elementAt(i), i)));
    }
    return items;
  }
}

class _ChannelItemWidget extends StatefulWidget {
  final ChannelItem item;

  const _ChannelItemWidget(this.item);

  @override
  State<StatefulWidget> createState() => _ChannelItemWidgetState();
}

class _ChannelItemWidgetState extends State<_ChannelItemWidget> {
  @override
  Widget build(BuildContext context) {
    final channelItemProvider = Provider.of<GlobalProvider>(context);
    var item = channelItemProvider.item;
    return GestureDetector(
      onTap: () {
        channelItemProvider.item = widget.item;
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Text(
          widget.item.title,
          style: TextStyle(
              fontSize: 20,
              color: item.index == widget.item.index ? Colors.red : Colors.blue,
              decoration:  item.index == widget.item.index ? TextDecoration.underline : null),
        ),
      ),
    );
  }
}

class ChannelItem {
  String title;
  int index;

  ChannelItem(this.title, this.index);
}
