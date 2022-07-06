
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeworld_flutter/screens/reading/charlotte_web.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class BookFavoritiesScreen extends StatelessWidget {
  static const name = '/BookFavoritiesScreen';
  const BookFavoritiesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBarUtils.getTitleAppbar(context, '我的阅读'),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              '夏洛的网',
              style: TextStyle(fontSize: 22),
            ),
            leading: const Icon(
              Icons.bookmark_border_outlined,
              color: Colors.blue,
            )
            ,
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CharlotteWebScreen.name);
            },
          ),
          ListTile(
            title: const Text(
              '窗边的小豆豆',
              style: TextStyle(fontSize: 22),
            ),
            leading: const Icon(
              Icons.bookmark_border_outlined,
              color: Colors.blue,
            )
            ,
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CharlotteWebScreen.name);
            },
          )
        ],
      ),
    );
  }
  _selectView(IconData icon, String text) {
    return  PopupMenuItem<String>(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: Colors.blue),
            Text(text),
          ],
        )
    );
  }
}