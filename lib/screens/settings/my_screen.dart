import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/Favorites/favorites_screen.dart';
import 'package:seeworld_flutter/screens/settings/login_screen.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(LoginScreen.name);
                  },
                  child: Icon(
                    Icons.person_pin,
                    size: 250,
                    color: _colorProvider.getIconColor(),
                  ),
                ),
                const Text(
                  '未登录',
                )
              ],
            ),
            const Divider(),
            _widgetProvider.getListTile(Icons.favorite_outline, '收藏',
                onTaped: () {
              Get.toNamed(FavoritesScreen.name);
            }),
            const Divider(),
            _widgetProvider.getListTile(Icons.settings_outlined, '设置',
                onTaped: () {
              Get.toNamed(SettingsScreen.name);
            })
          ],
        ));
  }
}
