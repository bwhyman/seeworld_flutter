import 'dart:convert';

import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/provider/sqlite_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

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

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        id: map['id'],
        title: map['title'],
        bid: map['bid'],
        content: map['content'],
        inserttime: map['inserttime']);
  }
}

class BookController extends GetxController {
  var books = <Book>[].obs;
  final SqliteProvider _sqliteProvider = Get.put(SqliteProvider());
  var chapters = <Chapter>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initBook();
  }

  void _initBook() async {
    Database db = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await db.query(Book.table_name);
    if (maps.isNotEmpty) {
      return;
    }
    String json = await DefaultAssetBundle.of(Get.context!)
        .loadString('assets/books/swarm.json');
    Map<String, dynamic> map = jsonDecode(json);
    Book b = Book(name: map['name'], inserttime: DateTime.now().toString());
    int bid = await db.insert(Book.table_name, b.toMap());
    b.id = bid;
    Chapter ch = Chapter(
        title: '第一章',
        content: map['content'],
        bid: bid,
        inserttime: DateTime.now().toString());
    int cid = await db.insert(Chapter.table_name, ch.toMap());
    books.add(b);
  }

  void loadBooks() async {
    if (books.isNotEmpty) {
      return;
    }
    Database database = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await database.query(Book.table_name);
    books.addAll(List.generate(
        maps.length,
        (index) => Book(
            id: maps[index]['id'],
            name: maps[index]['name'],
            inserttime: maps[index]['inserttime'])));
  }

  /*Book getBook(int id) async {

  }*/

  void insertBook(Book book) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.insert(Book.table_name, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    books.clear();
    loadBooks();
  }

  void updateBookName(Book book) async {
    Database database = await _sqliteProvider.getDatabase();
    database.update(Book.table_name, book.toMap(),
        where: 'id=?', whereArgs: [book.id]);
    books.clear();
    loadBooks();
  }

  void deleteBook(int id) async {
    Database database = await _sqliteProvider.getDatabase();
    database.delete(Book.table_name, where: 'id=?', whereArgs: [id]);
    books.clear();
    loadBooks();
  }

  Future<List<Chapter>> listChaptersByBid(int bid) async {
    Database database = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await database
        .query(Chapter.table_name, where: 'bid=?', whereArgs: [bid]);
    List<Chapter> chapters =
        List.generate(maps.length, (index) => Chapter.fromMap(maps[index]));
    this.chapters.value = chapters;
    return chapters;
  }

  insertChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.insert(Chapter.table_name, chapter.toMap());
    chapters.add(chapter);
  }

  updateChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.update(Chapter.table_name,
        {'title': chapter.title, 'content': chapter.content},
        where: "id=?", whereArgs: [chapter.id]);
    await listChaptersByBid(chapter.bid!);
  }

  void deleteChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.delete(Chapter.table_name, where: 'id=?', whereArgs: [chapter.id]);
    await listChaptersByBid(chapter.bid!);
  }
}
