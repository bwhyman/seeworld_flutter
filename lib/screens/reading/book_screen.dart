import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';

class BookScreen extends StatefulWidget {
  static const name = '/BookScreen';

  const BookScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  late double maxShowHeight;
  final BookController _bookController = Get.put(BookController());
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    maxShowHeight = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar(book.name ?? '', items: [
        _appBarProvider.selectPopMenuItem(Icons.add, '添加'),
        _appBarProvider.selectPopMenuItem(Icons.cast_connected, '扫码'),
      ]),
      body: FutureBuilder(
          future: _bookController.listChaptersByBid(book.id!),
          builder: (context, AsyncSnapshot<List<Chapter>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Chapter> chapters = snapshot.data!;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(chapters[index].title!, style: const TextStyle(fontSize: 22)),
                    onTap: () {
                      show(chapters[index].content!);
                      _ttsProvider.speakContent(chapters[index].content!);
                    },
                  );
                },
                separatorBuilder: (c, _) {
                  return const Divider();
                },
                itemCount: snapshot.data?.length ?? 0);
          }),
    );
  }

  show(str) {
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
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        children: [Text(str)],
                      ),
                    ),
                  ],
                )),
          );
        }).then((value) {
      _ttsProvider.getTts().stop();
    });
  }
}
