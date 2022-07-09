
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/sqlite_utils.dart';
import 'package:seeworld_flutter/provider/book_model.dart';
import 'package:sqflite/sqflite.dart';

class BookInit {

  static void initBook(BuildContext context) async {
    Database db = await SqliteUtils.getDatabase();
    List<Map<String, dynamic>> maps = await db.query(Book.table_name);
    if(maps.isNotEmpty) {
      return;
    }

    String json = await DefaultAssetBundle.of(context).loadString('assets/books/swarm.json');
    Map<String, dynamic> map = jsonDecode(json);
    Book b = Book(name: map['name'], inserttime: DateTime.now().toString());
    int bid = await db.insert(Book.table_name, b.toMap());

    Chapter ch = Chapter(title: '第一章', content: map['content'], bid: bid, inserttime: DateTime.now().toString());
    int cid = await db.insert(Chapter.table_name, ch.toMap());
  }
}