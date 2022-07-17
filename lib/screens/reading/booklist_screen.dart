import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _bookController.loadBooks();
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('我的阅读', items: [
        _widgetProvider.getIconButton(Icons.add, onPressed: _addBook),
        _widgetProvider.getIconButton(Icons.cast_connected),
      ]),
      body: _BookList(),
    );
  }

  @override
  void dispose() {
    _addBookController.dispose();
    super.dispose();
  }

  _addBook() {
    _dialogProvider.addDialog(_addBookController, '添加读物', '书名', () {
      var name = _addBookController.value.text.trim();
      if (name.isNotEmpty) {
        Book b = Book(name: name, inserttime: DateTime.now().toString());
        _bookController.insertBook(b);
      }
      Get.back();
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
  final WidgetProvider _appBarProvider = Get.put(WidgetProvider());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Book> books = _bookController.books;
    return Obx(() => ListView.builder(
        itemCount: books.length,
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
                  _appBarProvider.getPopupMenuItem(Icons.edit_outlined, '编辑',
                      onTaped: () {
                    Future.delayed(const Duration(), () {
                      _editBookController.value = _editBookController.value
                          .copyWith(text: books[index].name);
                      _editBookName(books[index]);
                    });
                  }),
                  _appBarProvider.getPopupMenuItem(Icons.delete_outline, '删除',
                      onTaped: () {
                    Future.delayed(const Duration(), () {
                      _deleteBook(books[index]);
                    });
                  }),
                ],
              );
            },
            child: ListTile(
              title: Text(
                '${books[index].name}',
                style: const TextStyle(fontSize: 22),
              ),
              leading: const Icon(
                Icons.bookmark_border_outlined,
                color: Colors.blue,
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Get.toNamed(BookScreen.name, arguments: books[index]);
              },
            ),
          );
        }));
  }

  _editBookName(Book book) {
    _dialogProvider.editDialog(_editBookController, '编辑', () {
      var name = _editBookController.value.text.trim();
      if (name.isNotEmpty) {
        book.name = name;
        _bookController.updateBookName(book);
      }
      Get.back();
    });
  }

  _deleteBook(Book book) {
    _dialogProvider.deleteDialog('确定删除书籍', book.name!, () {
      _bookController.deleteBook(book.id!);
      Get.back();
    });
  }

  @override
  void dispose() {
    _editBookController.dispose();
    super.dispose();
  }
}
