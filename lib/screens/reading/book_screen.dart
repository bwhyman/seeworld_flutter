import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/reading/chapter_screen.dart';

class BookScreen extends StatefulWidget {
  static const name = '/BookScreen';

  const BookScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookController _bookController = Get.put(BookController());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final _addChapterController = TextEditingController();
  final DialogProvider _dialogProvider = Get.put(DialogProvider());
  final TextEditingController _editChapterController = TextEditingController();
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  late Book _book;
  late RxList<Chapter> chapters = Get.put(BookController()).chapters;

  _onRecord(String recordText) {
    var c = chapters
        .firstWhereOrNull((element) => recordText.contains(element.title!));
    if (c != null) {
      _route(c);
    }
  }

  _route(Chapter c) {
    Get.toNamed(ChapterScreen.name, arguments: c)!.then((value) {
      Future.delayed(const Duration(seconds: 1), () => _speak());
    });
  }

  _speak() {
    String msg = '${_book.name}，共${chapters.length}章。';
    if (chapters.isNotEmpty) {
      msg = '$msg，章节主题包括：';
      for (var c in chapters) {
        msg = '$msg${c.title}，';
      }
    }
    _ttsProvider.speakContent(msg);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _book = Get.arguments as Book;
    _bookController.listChaptersByBid(_book.id!).then((value) => _speak());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _widgetProvider.getTitleAppbar(_book.name!, items: [
        _widgetProvider.getIconButton(Icons.add, onPressed: _addChapter),
        _widgetProvider.getIconButton(Icons.cast_connected),
      ]),
      floatingActionButton: _floatingButtonProvider.getFloatingRecordButton(
          onRecorded: _onRecord),
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      body: Obx(() => ListView.separated(
          itemBuilder: (context, index) {
            late Offset _downOffset;
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
                    _widgetProvider.getPopupMenuItem(Icons.edit_outlined, '编辑',
                        onTaped: () {
                      Future.delayed(const Duration(), () {
                        _editChapterController.value = _editChapterController
                            .value
                            .copyWith(text: chapters[index].title);
                        _editChapterName(chapters[index]);
                      });
                    }),
                    _widgetProvider.getPopupMenuItem(Icons.delete_outline, '删除',
                        onTaped: () {
                      Future.delayed(const Duration(),
                          () => _deleteChapter(chapters[index]));
                    }),
                  ],
                );
              },
              child: _widgetProvider.getListTile(
                  Icons.bubble_chart_outlined, chapters[index].title!,
                  onTaped: () {
                _route(chapters[index]);
              }),
            );
          },
          separatorBuilder: (c, _) => const Divider(),
          itemCount: chapters.length)),
    );
  }

  _addChapter() {
    _dialogProvider.addDialog(_addChapterController, '添加章节', '章节名称', () async {
      var name = _addChapterController.value.text.trim();
      if (name.isNotEmpty) {
        Chapter c = Chapter(
            bid: _book.id,
            title: name,
            content: '',
            inserttime: DateTime.now().toString());
        await _bookController.insertChapter(c);
      }
      Get.back();
      _speak();
    });
  }

  _deleteChapter(Chapter chapter) {
    _dialogProvider.deleteDialog('确定删除章节', chapter.title!, () async {
      await _bookController.deleteChapter(chapter);
      Get.back();
      _speak();
    });
  }

  _editChapterName(Chapter chapter) {
    _dialogProvider.editDialog(_editChapterController, '编辑', () {
      var name = _editChapterController.value.text.trim();
      if (name.isNotEmpty) {
        chapter.title = name;
        _bookController.updateChapter(chapter);
      }
      Get.back();
      _speak();
    });
  }

  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }
}
