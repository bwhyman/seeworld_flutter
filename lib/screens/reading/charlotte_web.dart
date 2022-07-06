import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class CharlotteWebScreen extends StatefulWidget {
  static const name = '/CharlotteWebScreen';

  const CharlotteWebScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CharlotteWebScreenState();
}

class CharlotteWebScreenState extends State<CharlotteWebScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBarUtils.getTitleAppbar(context, '夏洛的网'),
      body: ListView(
        children: [
          const ListTile(
            title: Text('一 早餐之前'),
          ),
          const Divider(),
          const ListTile(
            title: Text('二 小猪威伯'),
          ),
          const Divider(),
          const ListTile(
            title: Text('三 逃走'),
          ),
          const Divider(),
          const ListTile(
            title: Text('四 孤独'),
          ),
          const Divider(),
          ListTile(
            title: const Text('五 夏洛'),
            onTap: () {
              show(context);
              FlutterTtsUtils.speakContent(_ch);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  _selectView(IconData icon, String text) {
    return PopupMenuItem<String>(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(icon, color: Colors.blue),
        Text(text),
      ],
    ));
  }

  show(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(8),
              child: const Text(_ch));
        }).then((value) {
      FlutterTtsUtils.getTts().stop();
    });
  }

  static const _ch = '''
  夜好像变长了。威伯的肚子是空的，脑子里却装得满满的。当你的肚子是空的，可脑子里却满是心事的时候，总是很难入睡的。
　　这一夜，威伯醒了很多次。醒时他就拼命朝黑暗中望着，听着，想弄明白是几点钟了。谷仓从没有完全安静的时候，甚至在半夜里也还是老有响动。
　　第一次醒来时，他听到坦普尔曼在谷仓里打洞的声音。坦普尔曼的牙使劲儿地嗑着木头，弄出很大的动静。“那只疯耗子！”威伯想。“为什么他整夜的在那里磨牙，破坏人们的财产？为什么他不去睡觉，像任何一只正常的动物那样？”
　　第二次醒来时，威伯听到母鹅在她的窝里来回挪着，自顾自的傻笑。
　　“几点了？”威伯低声问母鹅。
　　“可能-能-能十一点半了吧，”母鹅说。“你为什么不睡，威伯？”
　　“我脑子里的东西太多了。”威伯说。
　　“唔，”母鹅说。“我没这样的麻烦。我脑子里什么东西都没有，不过我的屁股下面倒有很多东西。你试过坐在八个蛋上睡觉吗？”
　　“没有，”威伯回答。“我猜那一定很不舒服，一个鹅蛋得孵多久？”
　　“他们说大约-约要三十天，”母鹅回答。“可我有时会偷懒。在温暖的午后，我常衔来一些稻草把蛋盖上，一个人去散步。”
　　威伯打了个哈欠，进入了梦乡。梦里他又仿佛听到了那个声音，“我将成为你的朋友。去睡吧——明早你会看见我。”
''';
}
