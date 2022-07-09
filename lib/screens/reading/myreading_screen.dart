import 'package:flutter/material.dart';
import 'package:seeworld_flutter/screens/reading/booklist_screen.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';

class ReadingContainer extends StatelessWidget {
  static const name = "/reading";

  const ReadingContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        ListTile(
          title: const Text(
            '我的阅读',
            style: TextStyle(fontSize: 22),
          ),
          //subtitle: const Text('共2本'),
          leading: const Icon(
            Icons.menu_book_outlined,
            color: Colors.blue,
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(BookListScreen.name);
          },
        ),
        ListTile(
          title: const Text(
            '在线书店',
            style: TextStyle(fontSize: 22),
          ),
          leading: const Icon(
            Icons.monetization_on_outlined,
            color: Colors.blue,
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
          },
        ),
        const SizedBox(
          height: 80,
        ),
        ListTile(
          title: const Text(
            '临时阅读',
            style: TextStyle(fontSize: 22),
          ),
          leading: const Icon(
            Icons.camera_outlined,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(TakePictureScreen.name);
          },
        ),
      ],
    );
  }
}
