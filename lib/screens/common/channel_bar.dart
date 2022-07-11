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
        children: getItems(),
      ),
    );
  }

  List<_ChannelItemWidget> getItems() {
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
    return GestureDetector(
      onTap: () {
        if (_commonController.currentItem.value.index == item.index) {
          return;
        }
        _commonController.currentItem.value = item;
        _commonController.listNews(item.title);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Obx(() => Text(
              item.title,
              style: TextStyle(
                  fontSize: 20,
                  color: _commonController.currentItem.value.index == item.index
                      ? Colors.red
                      : Colors.blue,
                  decoration:
                      _commonController.currentItem.value.index == item.index
                          ? TextDecoration.underline
                          : null),
            )),
      ),
    );
  }
}
