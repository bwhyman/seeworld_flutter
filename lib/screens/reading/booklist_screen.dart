import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/screens/reading/book_screen.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';

class BookListScreen extends StatefulWidget {
  static const name = '/BookListScreen';

  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _addBookController = TextEditingController();
  final BookController _bookController = Get.put(BookController());
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _bookController.loadBooks();
    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar('我的阅读', items: [
        _appBarProvider.getIconButton(Icons.add,  onPressed: addBook),
        _appBarProvider.getIconButton(Icons.cast_connected),
      ]),
      body: _BookList(),
    );
  }

  @override
  void dispose() {
    _addBookController.dispose();
    super.dispose();
  }

  addBook() {
    return showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          title: const Text('添加读物'),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _addBookController,
                      decoration: const InputDecoration(hintText: '书名'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            var name = _addBookController.value.text.trim();
                            if (name.isNotEmpty) {
                              Book b = Book(
                                  name: name,
                                  inserttime: DateTime.now().toString());
                              _bookController.insertBook(b);
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

class _BookList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoolListState();
}

class _BoolListState extends State<_BookList> {
  late Offset _downOffset;
  final TextEditingController _editBookController = TextEditingController();
  final BookController _bookController = Get.put(BookController());


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Book> books = _bookController.books;
    return Obx(() => ListView.builder(
        itemCount: books.length,
        itemBuilder: (c, index) {
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
                  PopupMenuItem<String>(
                      onTap: () {
                        Future.delayed(const Duration(), () {
                          _editBookController.value = _editBookController.value.copyWith(text: books[index].name);
                          editBookName(books[index]);
                        });
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
                        Future.delayed(const Duration(), () {
                          deleteBook(books[index]);
                        });
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
                Log.d('books[index]', books[index].id);
                Get.toNamed(BookScreen.name, arguments: books[index]);
              },
            ),
          );
        }));
  }

  editBookName(Book book) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('编辑名称'),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _editBookController,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            var name = _editBookController.value.text.trim();
                            if (name.isNotEmpty) {
                              book.name = name;
                              _bookController.updateBookName(book);
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

  deleteBook(Book book) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('警告'),
            elevation: 24,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: '确定删除书籍',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: book.name,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(
                                text: '?',
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              _bookController.deleteBook(book.id!);
                              Navigator.pop(context);
                            },
                            child: const Text('删除')),
                      )
                    ],
                  ))
            ],
          );
        });
  }

  @override
  void dispose() {
    _editBookController.dispose();
    super.dispose();
  }
}
