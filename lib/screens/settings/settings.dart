import 'package:flutter/material.dart';
import 'package:seeworld_flutter/screens/settings/login_screen.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Column(
          children:  [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(LoginScreen.name);
              },
              child: const Icon(
                Icons.person_pin,
                size: 250,
                color: Colors.indigo,
              ),
            ),
            const Text(
              '未登录',
              style: TextStyle(color: Colors.indigo),
            )
          ],
        ),
        const Divider(),
        ListTile(
          title: const Text(
            '设置',
            style: TextStyle(fontSize: 22),
          ),
          leading: const Icon(
            Icons.settings_outlined,
            color: Colors.blue,
          )
          ,
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(SettingsScreen.name);
          },
        )
      ],
    );
  }
}
