import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/provider/book_model.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class BookScreen extends StatefulWidget {
  static const name = '/CharlotteWebScreen';

  const BookScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  late double maxShowHeight;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    maxShowHeight = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
      appBar: MyAppBarUtils.getTitleAppbar(context, book.name ?? '',
          items: [
            MyAppBarUtils.selectPopMenuItem(Icons.add, '添加'),
            MyAppBarUtils.selectPopMenuItem(Icons.cast_connected, '扫码'),
          ]),
      body: Consumer<BookModel>(
        builder: (_, bookModel, w) {
          return FutureBuilder(
              future: bookModel.listChaptersByBid(book.id!),
              builder: (context, AsyncSnapshot<List<Chapter>> snapshot) {
                List<Chapter> chapters = snapshot.data!;
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(chapters[index].title!),
                        onTap: () {
                          show(context, chapters[index].content!);
                          FlutterTtsUtils.speakContent(
                              chapters[index].content!);
                        },
                      );
                    },
                    separatorBuilder: (c, _) {
                      return const Divider();
                    },
                    itemCount: snapshot.data?.length ?? 0);
              });
        },
      ),
    );
  }

  show(context, str) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxShowHeight),
                child: Column(
                  children: [
                    IconButton(onPressed: () {
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.close)),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(str)
                        ],
                      ),
                    ),
                  ],
                )),
          );
        }).then((value) {
      FlutterTtsUtils.getTts().stop();
    });
  }
}
