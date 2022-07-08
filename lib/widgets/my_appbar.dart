import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBarUtils {
  static AppBar getHomeAppbar() {
    return AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark));
  }

  static AppBar getTitleAppbar(BuildContext context, String title, {isActions: true}) {
    List<Widget> acts = _listActions();
    if(!isActions) {
      acts = [];
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white70,
      actions: acts,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  static List<Widget> _listActions() {
    return [ PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        _selectView(Icons.add, '添加'),
        _selectView(Icons.edit, '编辑'),
        _selectView(Icons.cast_connected, '扫码'),
      ],
    )];
  }

  static _selectView(IconData icon, String text) {
    return PopupMenuItem<String>(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(icon, color: Colors.blue),
        Text(text),
      ],
    ));
  }
}
