import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/reading/booklist_screen.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';

class MyReadingScreen extends StatelessWidget {
  static const name = "/MyReadingScreen";

  MyReadingScreen({Key? key}) : super(key: key);
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            _widgetProvider.getListTile(
                Icons.menu_book_outlined,
                '我的阅读',
            onTaped: () {
              Get.toNamed(BookListScreen.name);
            }),
            _widgetProvider.getListTile(
                Icons.monetization_on_outlined,
                '在线书店',
            onTaped: () {}),
            const SizedBox(
              height: 80,
            ),
            _widgetProvider.getListTile(
                Icons.camera_outlined,
                '临时阅读',
                onTaped: () {
                  Get.toNamed(CameraScreen.name, arguments: true);
                })
          ],
        ));
  }
}
