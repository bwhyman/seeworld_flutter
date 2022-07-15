import 'dart:math';

import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/sqlite_provider.dart';
import 'package:sqflite/sqflite.dart';

class Favorite {
  static const table_name = 'Favorite';
  int? id;
  int? nid;
  String? title;
  String? content;
  String? publishedTime;
  String? insertTime;

  Favorite(
      {this.id,
      this.nid,
      this.title,
      this.content,
      this.publishedTime,
      this.insertTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nid': nid,
      'title': title,
      'content': content,
      'publishedTime': publishedTime,
      'insertTime': insertTime,
    };
  }
}

class FavoritesController extends GetxController {
  final SqliteProvider _sqliteProvider = Get.put(SqliteProvider());
  var favoritesList = <Favorite>[].obs;


  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }


  _loadFavorites() async {
    Database db = await _sqliteProvider.getDatabase();
    List<Map<String, dynamic>> maps = await db.query(Favorite.table_name);
    List<Favorite> l = List.generate(
        maps.length,
        (index) => Favorite(
              id: maps[index]['id'],
              nid: maps[index]['nid'],
              title: maps[index]['title'],
              content: maps[index]['content'],
              publishedTime: maps[index]['publishedTime'.toLowerCase()],
              insertTime: maps[index]['insertTime'.toLowerCase()],
            ));
    favoritesList.addAll(l);
  }


  insert(Favorite favorite) async {
    Database db = await _sqliteProvider.getDatabase();
    int fid = await db.insert(Favorite.table_name, favorite.toMap());
    favorite.id = fid;
    favoritesList.add(favorite);
  }
  delete(int id) async {
    Database db = await _sqliteProvider.getDatabase();
    await db.delete(Favorite.table_name, where: 'id=?', whereArgs: [id]);
  }
}
