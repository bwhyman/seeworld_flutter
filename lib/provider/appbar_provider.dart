import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';

class AppBarProvider extends GetxController {
  AppBar getHomeAppbar() {
    return AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark));
  }

  AppBar getTitleAppbar(String title, {List<IconButton>? items}) {
    List<IconButton> acts = [];

    if (items != null) {
      acts = items;
    }

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
      actions: acts,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  /*PopupMenuItem<String> selectPopMenuItem(IconData icon, String text,
      {void Function()? onTaped}) {
    return PopupMenuItem<String>(
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
  }*/

  IconButton getIconButton(IconData iconData, {void Function()? onPressed}) {
    return IconButton(
        onPressed: () => Future.delayed(const Duration(), () => onPressed!()),
        icon: Icon(iconData, color: Colors.blue));
  }
}
