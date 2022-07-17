import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/common_controller.dart';

class ChannelList extends StatelessWidget {
  ChannelList({Key? key}) : super(key: key);
  final CommonController _commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _getItems(),
      ),
    );
  }

  List<_ChannelItemWidget> _getItems() {
    return List.generate(_commonController.channelItems.length,
        (index) => _ChannelItemWidget(_commonController.channelItems[index]));
  }
}

class _ChannelItemWidget extends StatelessWidget {
  final ChannelItem item;

  _ChannelItemWidget(this.item);

  final CommonController _commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    var cItem = _commonController.currentItem;
    return GestureDetector(
      onTap: () {
        if (cItem.value.index == item.index) {
          return;
        }
        cItem.value = item;
        _commonController.listNews(item.title);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Obx(() => Text(
              item.title,
              style: TextStyle(
                  fontSize: 20,
                  color: cItem.value.index == item.index
                      ? Colors.red
                      : Colors.blue,
                  decoration: cItem.value.index == item.index
                      ? TextDecoration.underline
                      : null),
            )),
      ),
    );
  }
}
