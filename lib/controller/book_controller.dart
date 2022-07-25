import 'dart:convert';

import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/sqlite_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';


class BookController extends GetxController {
  var books = <Book>[].obs;
  final SqliteProvider _sqliteProvider = Get.put(SqliteProvider());
  var chapters = <Chapter>[].obs;

  void initBook() async {
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
        title: map['title'],
        content: map['content'],
        bid: bid,
        inserttime: DateTime.now().toString());
    int cid = await db.insert(Chapter.table_name, ch.toMap());
  }

  Future<RxList<Book>?> loadBooks() async {
    Database database = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await database.query(Book.table_name);
    books.clear();
    books.addAll(List.generate(
        maps.length,
        (index) => Book(
            id: maps[index]['id'],
            name: maps[index]['name'],
            inserttime: maps[index]['inserttime'])));
    return books;
  }

  Future<RxList<Book>?> insertBook(Book book) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.insert(Book.table_name, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    books.clear();
    await loadBooks();
    return books;
  }

  Future<RxList<Book>?> updateBookName(Book book) async {
    Database database = await _sqliteProvider.getDatabase();
    database.update(Book.table_name, book.toMap(),
        where: 'id=?', whereArgs: [book.id]);
    books.clear();
    await loadBooks();
    return books;
  }

  Future<RxList<Book>?> deleteBook(int id) async {
    Database database = await _sqliteProvider.getDatabase();
    database.delete(Book.table_name, where: 'id=?', whereArgs: [id]);
    books.clear();
    await loadBooks();
    return books;
  }

  Future<RxList<Chapter>> listChaptersByBid(int bid) async {
    Database database = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await database
        .query(Chapter.table_name, where: 'bid=?', whereArgs: [bid]);
    List<Chapter> chapters =
        List.generate(maps.length, (index) => Chapter.fromMap(maps[index]));
    this.chapters.clear();
    this.chapters.addAll(chapters);
    return this.chapters;
  }

  Future<RxList<Chapter>> insertChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    int id = await database.insert(Chapter.table_name, chapter.toMap());
    chapter.id = id;
    chapters.add(chapter);
    return chapters;
  }

  Future<RxList<Chapter>> updateChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.update(Chapter.table_name,
        {'title': chapter.title, 'content': chapter.content},
        where: "id=?", whereArgs: [chapter.id]);
    await listChaptersByBid(chapter.bid!);
    return chapters;
  }

  Future<RxList<Chapter>> deleteChapter(Chapter chapter) async {
    Database database = await _sqliteProvider.getDatabase();
    await database.delete(Chapter.table_name, where: 'id=?', whereArgs: [chapter.id]);
    await listChaptersByBid(chapter.bid!);
    return chapters;
  }
}
