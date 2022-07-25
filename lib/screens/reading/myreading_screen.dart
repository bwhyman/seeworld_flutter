import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/screens/reading/booklist_screen.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';

class MyReadingScreen extends StatelessWidget {
  static const name = "/MyReadingScreen";

  MyReadingScreen({Key? key}) : super(key: key);
  final ColorProvider _colorProvider = Get.put(ColorProvider());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: const Text(
                '我的阅读',
                style: TextStyle(fontSize: UI.functionFontSize),
              ),
              //subtitle: const Text('共2本'),
              leading: Icon(Icons.menu_book_outlined,
                  size: UI.iconleadingSize,
                  color: _colorProvider.getIconColor()),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Get.toNamed(BookListScreen.name);
              },
            ),
            ListTile(
              title: const Text(
                '在线书店',
                style: TextStyle(fontSize: UI.functionFontSize),
              ),
              leading: Icon(Icons.monetization_on_outlined,
                  size: UI.iconleadingSize,
                  color: _colorProvider.getIconColor()),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {},
            ),
            const SizedBox(
              height: 80,
            ),
            ListTile(
              title: const Text(
                '临时阅读',
                style: TextStyle(fontSize: UI.functionFontSize),
              ),
              leading: Icon(Icons.camera_outlined,
                  size: UI.iconleadingSize,
                  color: _colorProvider.getIconColor()),
              onTap: () {
                Get.toNamed(CameraScreen.name, arguments: true);
              },
            ),
          ],
        ));
  }
}
