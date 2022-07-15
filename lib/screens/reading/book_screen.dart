import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';
import 'package:seeworld_flutter/screens/reading/chapter_screen.dart';

class BookScreen extends StatefulWidget {
  static const name = '/BookScreen';

  const BookScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late double maxShowHeight;
  final BookController _bookController = Get.put(BookController());
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final _addChapterController = TextEditingController();
  late Book _book;
  late Offset _downOffset;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _book = ModalRoute.of(context)!.settings.arguments as Book;
    Log.d('_book', _book.id);
    _bookController.listChaptersByBid(_book.id!);
    maxShowHeight = MediaQuery.of(context).size.height * 0.8;
    var chapters = _bookController.chapters;
    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar(_book.name ?? '', items: [
        _appBarProvider.getIconButton(Icons.add, onPressed: addChapter),
        _appBarProvider.getIconButton(Icons.cast_connected),
      ]),
      body: Obx(() => ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapDown: (detail) {
                    _downOffset = detail.globalPosition;
                  },
                  onLongPress: () {
                    final RenderBox renderBox = Overlay.of(context)
                        ?.context
                        .findRenderObject() as RenderBox;
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        _downOffset.dx,
                        _downOffset.dy,
                        renderBox.size.width - _downOffset.dx,
                        renderBox.size.height - _downOffset.dy,
                      ),
                      items: <PopupMenuEntry>[
                        PopupMenuItem<String>(
                            onTap: () {
                              Future.delayed(const Duration(), () {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(Icons.edit_outlined, color: Colors.blue),
                                Text('编辑'),
                              ],
                            )),
                        PopupMenuItem<String>(
                            onTap: () {
                              Future.delayed(const Duration(), () {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(Icons.delete_outline, color: Colors.blue),
                                Text('删除'),
                              ],
                            )),
                      ],
                    );
                  },
                  child: ListTile(
                    title: Text(chapters[index].title!,
                        style: const TextStyle(fontSize: 22)),
                    onTap: () {
                      Get.toNamed(ChapterScreen.name,
                          arguments: chapters[index]);
                    },
                  ),
                );
              },
              separatorBuilder: (c, _) => const Divider(),
              itemCount: chapters.length)),
    );
  }

  /*show(String str) {
    _ttsProvider.speakContent(str);
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
  }*/

  addChapter() {
    {
      return showDialog(
        barrierDismissible: true,
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('添加章节'),
            elevation: 24,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _addChapterController,
                        decoration: const InputDecoration(hintText: '章节名称'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              var name =
                                  _addChapterController.value.text.trim();
                              if (name.isNotEmpty) {
                                Chapter c = Chapter(
                                    bid: _book.id,
                                    title: name,
                                    content: '',
                                    inserttime: DateTime.now().toString());
                                _bookController.insertChapter(c);
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('保存')),
                      )
                    ],
                  ))
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }
}
