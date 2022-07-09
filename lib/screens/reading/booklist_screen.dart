import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/dialog_utils.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/sqlite_utils.dart';
import 'package:seeworld_flutter/provider/book_model.dart';
import 'package:seeworld_flutter/screens/reading/book_screen.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';

class BookListScreen extends StatefulWidget {
  static const name = '/BookListScreen';

  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookListScreenState();
}

class BookListScreenState extends State<BookListScreen> {
  final _addBookController = TextEditingController();
  late BookModel _bookModel;
  late BuildContext _con;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _con = context;
    _bookModel = Provider.of<BookModel>(context, listen: false);
    _bookModel.loadBooks();
    return Scaffold(
      appBar: MyAppBarUtils.getTitleAppbar(context, '我的阅读', items: [
        MyAppBarUtils.selectPopMenuItem(Icons.add, '添加', onTaped: addBook),
        MyAppBarUtils.selectPopMenuItem(Icons.cast_connected, '扫码'),
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
      context: _con,
      builder: (context) {
        return SimpleDialog(
          title: const Text('添加图书'),
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
                              _bookModel.insertBook(b);
                            }
                            Navigator.pop(_con);
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
  late BuildContext _con;
  late TextEditingController _editBookController;
  late BookModel _bookModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _con = context;
    _bookModel = Provider.of<BookModel>(context, listen: false);
    return Consumer<BookModel>(builder: (_, bookModel, __) {
      List<Book> books = bookModel.booksVN.value;
      return ListView.builder(
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
                  Navigator.of(context)
                      .pushNamed(BookScreen.name, arguments: books[index]);
                },
              ),
            );
          });
    });
  }

  editBookName(Book book) {
    _editBookController = TextEditingController(text: book.name);
    showDialog(
      barrierDismissible: true,
      context: _con,
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
                              _bookModel.updateBookName(book);
                            }
                            Navigator.pop(_con);
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
        context: _con,
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
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
                              _bookModel.deleteBook(book.id!);
                              Navigator.pop(_con);
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
