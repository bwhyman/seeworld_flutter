
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';


class SettingsScreen extends StatefulWidget {
  static const name = '/SettingsScreen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsScreenState();

}

class SettingsScreenState extends State<SettingsScreen> {
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  bool _yidongYun = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:_appBarProvider.getTitleAppbar('设置'),
      body: Card(
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.electrical_services_outlined,color: Colors.blue,),
              title: Text('服务器地址'),
              subtitle: Text('http://36.138.192.150:3000/'),
            ),
            const ListTile(
              leading: Icon(Icons.electrical_services_outlined,color: Colors.blue,),
              title: Text('移动云服务器地址'),
              subtitle: Text('https://api-wuxi-1.cmecloud.cn:8443'),
            ),
            ListTile(
              leading: const Icon(Icons.graphic_eq_outlined,color: Colors.blue,),
              title: const Text('使用移动云语音合成会极大增加运行延迟'),
              trailing: Switch(
                  value: _yidongYun,
                  onChanged: (_) {
                  _yidongYun = !_yidongYun;
                  setState(() {
                  });
              }),
            ),
            const ListTile(
              leading: Icon(Icons.electrical_services_outlined,color: Colors.blue,),
              title: Text('清空缓存数据'),
              subtitle: Text('当前应用占用 24.7MB'),
            ),
          ],
        ),
      ),
    );
  }
}