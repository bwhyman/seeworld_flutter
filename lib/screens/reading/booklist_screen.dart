import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/screens/reading/book_screen.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class BookListScreen extends StatefulWidget {
  static const name = '/BookListScreen';

  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _addBookController = TextEditingController();
  final BookController _bookController = Get.put(BookController());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final DialogProvider _dialogProvider = Get.put(DialogProvider());
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  late RxList<Book> books;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _bookController.loadBooks().then((value) {
      books = value!;
      _speak();
    });
  }

  _speak() {
    String msg = '您有${books.length}本书。';
    msg = '$msg包括，';
    for (var b in books) {
      msg = '$msg${b.name}。';
    }
    _ttsProvider.speakContent(msg);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('我的阅读', items: [
        _widgetProvider.getIconButton(Icons.add, onPressed: _addBook),
        _widgetProvider.getIconButton(Icons.cast_connected),
      ]),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _floatingButtonProvider.getFloatingRecordButton(
          onRecorded: _onRecord),
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      body: _BookList(),
    );
  }

  _onRecord(String recordText) {
    var b =
        books.firstWhereOrNull((element) => recordText.contains(element.name!));
    if (b != null) {
      Get.toNamed(BookScreen.name, arguments: b)?.then((value) {
        Future.delayed(const Duration(seconds: 1), () => _speak());
      });
    }
  }

  @override
  void dispose() {
    _addBookController.dispose();
    _ttsProvider.getTts().stop();
    super.dispose();
  }

  _addBook() {
    _dialogProvider.addDialog(_addBookController, '添加读物', '书名', () async {
      var name = _addBookController.value.text.trim();
      if (name.isNotEmpty) {
        Book b = Book(name: name, inserttime: DateTime.now().toString());
        await _bookController.insertBook(b);
      }
      Get.back();
      _speak();
    });
  }
}

class _BookList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoolListState();
}

class _BoolListState extends State<_BookList> {
  final TextEditingController _editBookController = TextEditingController();
  final BookController _bookController = Get.put(BookController());
  final DialogProvider _dialogProvider = Get.put(DialogProvider());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final RxList<Book> _books = Get.put(BookController()).books;

  _speak() {
    String msg = '您有${_books.length}本书。';
    msg = '$msg包括，';
    for (var b in _books) {
      msg = '$msg${b.name}。';
    }
    _ttsProvider.speakContent(msg);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => ListView.builder(
        itemCount: _books.length,
        itemBuilder: (c, index) {
          late Offset _downOffset;
          return GestureDetector(
            onTapDown: (detail) {
              _downOffset = detail.globalPosition;
            },
            onLongPress: () {
              final RenderBox renderBox =
                  Overlay.of(c)?.context.findRenderObject() as RenderBox;
              showMenu(
                context: c,
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
                      _editBookController.value = _editBookController.value
                          .copyWith(text: _books[index].name);
                      _editBookName(_books[index]);
                    });
                  }),
                  _widgetProvider.getPopupMenuItem(Icons.delete_outline, '删除',
                      onTaped: () {
                    Future.delayed(const Duration(), () {
                      _deleteBook(_books[index]);
                    });
                  }),
                ],
              );
            },
            child: _widgetProvider.getListTile(
                Icons.bookmark_border_outlined, '${_books[index].name}',
                onTaped: () {
              Get.toNamed(BookScreen.name, arguments: _books[index])
                  ?.then((value) {
                Future.delayed(const Duration(seconds: 1), () => _speak());
              });
            }),
          );
        }));
  }

  _editBookName(Book book) {
    _dialogProvider.editDialog(_editBookController, '编辑', () async {
      var name = _editBookController.value.text.trim();
      if (name.isNotEmpty) {
        book.name = name;
        await _bookController.updateBookName(book);
      }
      Get.back();
      _speak();
    });
  }

  _deleteBook(Book book) {
    _dialogProvider.deleteDialog('确定删除书籍', book.name!, () async {
      await _bookController.deleteBook(book.id!);
      Get.back();
      _speak();
    });
  }

  @override
  void dispose() {
    _editBookController.dispose();
    super.dispose();
  }
}
