import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class WidgetProvider extends GetxController {
  AppBar getHomeAppbar() {
    return AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark));
  }

  AppBar getTitleAppbar(String title, {List<IconButton> items = const []}) {
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
            Icon(icon, color: Colors.blue),
            Text(text),
          ],
        ));
  }

  IconButton getIconButton(IconData iconData, {void Function()? onPressed}) {
    return IconButton(
        onPressed: () => Future.delayed(const Duration(), () => onPressed!()),
        icon: Icon(iconData, color: Colors.blue));
  }

  Widget getInfoStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            _getIcon(Icons.thumb_up_alt_outlined),
            Text('${_random100()}')
          ],
        ),
        Column(
          children: [
            _getIcon(Icons.replay_outlined),
            Text('${_random10()}')
          ],
        ),
        Column(
          children: [
            _getIcon(Icons.favorite_outline),
            Text('${_random10()}')
          ],
        ),
      ],
    );
  }
  Icon _getIcon(IconData iconData) {
    return Icon(
      iconData,
      color: Colors.indigo,
      size: 32,
    );
  }
  final Random _r = Random();
  int _random100() {
    return _r.nextInt(1000);
  }

  int _random10() {
    return _r.nextInt(100);
  }
}
