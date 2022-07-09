import 'package:flutter/foundation.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/sqlite_utils.dart';
import 'package:sqflite/sqflite.dart';

class Book {
  static const table_name = 'book';
  int? id;
  String? name;
  String? inserttime;

  Book({this.id, this.name, this.inserttime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inserttime': inserttime,
    };
  }
}

class Chapter {
  static const table_name = 'chapter';
  int? id;
  String? title;
  int? bid;
  String? content;
  String? inserttime;

  Chapter({this.id, this.title, this.content, this.inserttime, this.bid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bid': bid,
      'title': title,
      'content': content,
      'inserttime': inserttime,
    };
  }
}

class BookModel with ChangeNotifier {
  late List<Book> books = [];
  ValueNotifier<List<Book>> booksVN = ValueNotifier(List.empty());

  void loadBooks() async {
    if(booksVN.value.isNotEmpty) {
      return;
    }
    Database database = await SqliteUtils.getDatabase();
    List<Map<String, dynamic>> maps = await database.query(Book.table_name);
    booksVN.value = List.generate(
        maps.length,
            (index) => Book(
            id: maps[index]['id'],
            name: maps[index]['name'],
            inserttime: maps[index]['inserttime']));
    notifyListeners();
  }

  /*Book getBook(int id) async {

  }*/

  void insertBook(Book book) async {
    Database database = await SqliteUtils.getDatabase();
    database.insert(Book.table_name, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    booksVN.value.clear();
    loadBooks();
  }

  void updateBookName(Book book) async {
    Database database = await SqliteUtils.getDatabase();
    database.update(Book.table_name, book.toMap(), where: 'id=?', whereArgs: [book.id]);
    booksVN.value.clear();
    loadBooks();
  }

  void deleteBook(int id) async {
    Database database = await SqliteUtils.getDatabase();
    database.delete(Book.table_name, where: 'id=?', whereArgs: [id]);
    booksVN.value.clear();
    loadBooks();
  }

  Future<List<Chapter>> listChaptersByBid(int bid) async {
    Database database = await SqliteUtils.getDatabase();
    List<Map<String, dynamic>> maps = await database.query(Chapter.table_name, where: 'bid=?', whereArgs: [bid]);
    List<Chapter> chapters = List.generate(
        maps.length,
            (index) => Chapter(
            id: maps[index]['id'],
            title: maps[index]['title'],
            content: maps[index]['content'],
            inserttime: maps[index]['inserttime']));
    return chapters;

  }

}
