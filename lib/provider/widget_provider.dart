
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';

class WidgetProvider extends GetxController {
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  AppBar getHomeAppbar() {
    return AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark));
  }

  AppBar getTitleAppbar(String title, {List<Widget> items = const []}) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      backgroundColor: Colors.white70,
      actions: items,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarIconBrightness: Brightness.dark),
    );
  }


  PopupMenuItem getPopupMenuItem(IconData icon, String text,
      {void Function()? onTaped}) {
    return PopupMenuItem(
        onTap: () {
          Future.delayed(const Duration(), () => onTaped!());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: _colorProvider.getIconColor()),
            Text(text),
          ],
        ));
  }

  Widget getIconButton(IconData iconData, {void Function()? onPressed}) {
    return IconButton(
        onPressed: () => Future.delayed(const Duration(), () => onPressed!()),
        icon: Icon(iconData, color: _colorProvider.getIconColor()));
  }

  Widget getInfoStatus(News news, {void Function()? onCommented}) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            _getIcon(Icons.thumb_up_alt_outlined),
            Text('${news.likes}')
          ],
        ),
        GestureDetector(
          onTap: () {
            onCommented!();
          },
          child: Column(
            children: [
              _getIcon(Icons.comment_outlined),
              Text('${news.comments}')
            ],
          ),
        ),
        Column(
          children: [
            _getIcon(Icons.favorite_outline),
            Text('${news.favorite}')
          ],
        ),
      ],
    ));
  }
  Icon _getIcon(IconData iconData) {
    return Icon(
      iconData,
      color: _colorProvider.getIconColor(),
      size: 32,
    );
  }

  ListTile getListTile(IconData iconData, String text, {Widget? subtitle , Function()? onTaped}) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: UI.functionFontSize),
      ),
      leading: Icon(
        iconData,
        size: UI.iconleadingSize,
        color: _colorProvider.getIconColor(),
      ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTaped,
      subtitle: subtitle,
    );

  }
}
