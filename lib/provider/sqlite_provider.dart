
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
          'create table if not exists book(id integer primary key AUTOINCREMENT, name VARCHAR(20), inserttime text)');
      db.execute(
          'create table if not exists chapter(id integer primary key AUTOINCREMENT, bid integer, title VARCHAR(20), content text, inserttime text)');
      db.execute('create index if not exists index_bid on chapter(bid)');
    }, version: 1);
    return database;
  }

  Future<Database> getDatabase() {
    return _db;
  }

}
