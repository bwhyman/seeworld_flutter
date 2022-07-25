import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/screens/Favorites/favorites_screen.dart';
import 'package:seeworld_flutter/screens/settings/login_screen.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => Column(
      children: [
        Column(
          children:  [
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
             const Text('未登录',)
          ],
        ),
        const Divider(),
        ListTile(
          title: const Text(
            '收藏',
            style: TextStyle(fontSize: UI.functionFontSize),
          ),
          leading: Icon(
            Icons.favorite_outline,
            size: UI.iconleadingSize,
            color: _colorProvider.getIconColor(),
          )
          ,
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Get.toNamed(FavoritesScreen.name);
          },
        ),
        const Divider(),
        ListTile(
          title: const Text(
            '设置',
            style: TextStyle(fontSize: UI.functionFontSize),
          ),
          leading:  Icon(
            Icons.settings_outlined,
            size: UI.iconleadingSize,
            color: _colorProvider.getIconColor(),
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Get.toNamed(SettingsScreen.name);
          },
        )
      ],
    ));
  }
}
