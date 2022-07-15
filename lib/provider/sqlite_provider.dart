import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteProvider extends GetxController {
  static final Future<Database> _db = _create();

  static Future<Database> _create() async {
    WidgetsFlutterBinding
        .ensureInitialized(); // Open the database and store the reference.
    Database database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'), onCreate: (db, v) async {
      await db.execute(
          'create table if not exists book(id integer primary key AUTOINCREMENT, name VARCHAR(20), inserttime varchar(30))');
      await db.execute(
          'create table if not exists chapter(id integer primary key AUTOINCREMENT, bid integer, title VARCHAR(20), content text, inserttime varchar(30))');
      await db.execute('create index if not exists index_bid on chapter(bid)');
      await db.execute(
          'create table if not exists favorite(id integer primary key autoincrement,nid integer,title varchar(40),content text,type varchar(20),publishedTime varchar(30),insertTime varchar(30))');
    }, version: 1);
    return database;
  }

  Future<Database> getDatabase() {
    return _db;
  }
}
