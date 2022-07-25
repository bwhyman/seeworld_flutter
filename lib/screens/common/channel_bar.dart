import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/controller/common_controller.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';

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
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  @override
  Widget build(BuildContext context) {
    var isRGBlinding = _colorProvider.isRGBlinding;
    var cItem = _commonController.currentItem;
    return GestureDetector(
      onTap: () {
        if (cItem.value.title == item.title) {
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
                  color: _colorProvider.getFontColor(cItem.value.title == item.title),
                  decoration: cItem.value.title == item.title
                      ? TextDecoration.underline
                      : null),
            )),
      ),
    );
  }
}
