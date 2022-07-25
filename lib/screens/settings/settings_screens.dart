import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const name = '/SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  bool _yidongYun = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('设置'),
      body: Obx(() => Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.electrical_services_outlined,
                    color: _colorProvider.getIconColor(),
                    size: UI.iconleadingSize,
                  ),
                  title: const Text(
                    '服务器地址',
                    style: TextStyle(fontSize: UI.functionFontSize),
                  ),
                  subtitle: const Text('http://36.138.192.150:3000/'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.electrical_services_outlined,
                    color: _colorProvider.getIconColor(),
                    size: UI.iconleadingSize,
                  ),
                  title: const Text(
                    '移动云服务器地址',
                    style: TextStyle(fontSize: UI.functionFontSize),
                  ),
                  subtitle: const Text('https://api-wuxi-1.cmecloud.cn:8443'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.graphic_eq_outlined,
                    color: _colorProvider.getIconColor(),
                    size: UI.iconleadingSize,
                  ),
                  title: const Text(
                    '使用移动云语音合成会极大增加运行延迟',
                    style: TextStyle(fontSize: UI.functionFontSize),
                  ),
                  trailing: Switch(
                      value: _yidongYun,
                      onChanged: (_) {
                        _yidongYun = !_yidongYun;
                      }),
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_sweep_outlined,
                    color: _colorProvider.getIconColor(),
                    size: UI.iconleadingSize,
                  ),
                  title: const Text(
                    '清空缓存数据',
                    style: TextStyle(fontSize: UI.functionFontSize),
                  ),
                  subtitle: const Text('当前应用占用 24.7MB'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.satellite_outlined,
                    color: _colorProvider.getIconColor(),
                    size: UI.iconleadingSize,
                  ),
                  title: const Text(
                    '启用红绿色盲设置',
                    style: TextStyle(fontSize: UI.functionFontSize),
                  ),
                  trailing: Obx(() => Switch(
                      value: _colorProvider.isRGBlinding.value,
                      onChanged: (_) {
                        _colorProvider.isRGBlinding.value =
                            !_colorProvider.isRGBlinding.value;
                        _colorProvider
                            .setRGBinding(_colorProvider.isRGBlinding.value);
                      })),
                ),
              ],
            ),
          )),
    );
  }
}
