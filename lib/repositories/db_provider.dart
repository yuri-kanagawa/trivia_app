import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/favorite.dart';
import '../models/trivia.dart';

class DBProvider extends ChangeNotifier {
  bool flg;
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  static final _tableName = "TRIVIA_FAVORITE";

  List<Trivia> TriviaList = [];

  List<Favorite> FavoriteList = [];

  DBProvider();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      // DBがなかったら作る
      _database = await initDB();
      return _database;
    }
  }

  //クライアント端末にSQLite作成
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "TRIVIA_FAVORITE.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  _createTable(Database db, int version) async {
    return await db.execute("CREATE TABLE $_tableName ("
        "id int PRIMARY KEY,"
        "title TEXT NOT NULL,"
        "youtube TEXT,"
        "content1 TEXT NOT NULL,"
        "content2 TEXT,"
        "content3 TEXT,"
        "genre TEXT,"
        "cr_date int"
        ")");
  }

  getAllTrivias() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('trivia')
        .orderBy("id")
        .get();
    final docs = snapshots.docs;
    TriviaList = docs.map((doc) => Trivia(doc)).toList();
    this.TriviaList = TriviaList;
    return TriviaList;
  }

  search(text) async {
    List tmpList = [];

    int number;

    try {
      number = int.parse(text);
      print(number);
    } on FormatException {
      print('Format error!');
    }

    if (text.length > 0) {
      tmpList = this
          .TriviaList
          .where((TriviaList) =>
              TriviaList.content1.contains(text) ||
              TriviaList.content2.contains(text) ||
              TriviaList.content3.contains(text) ||
              TriviaList.title.contains(text) ||
              TriviaList.id == (number) ||
              TriviaList.genre.contains(text))
          .toList();
    } else {
      tmpList = this.TriviaList;
    }
    print(tmpList.length);

    return tmpList;
  }

  getFavoriteId(id) async {
    final db = await database;
    var res = await db.query(_tableName, where: "id = ?", whereArgs: [id]);

    TriviaList =
        res.isNotEmpty ? res.map((c) => Trivia.fromMap(c)).toList() : null;

    if (TriviaList != null) {
      flg = true;
    } else {
      flg = false;
    }
    notifyListeners();
  }

  getFavoriteId2(int id) async {
    final db = await database;
    var res = await db.query(_tableName, where: "id = ?", whereArgs: [id]);

    FavoriteList =
        res.isNotEmpty ? res.map((c) => Favorite.fromMap(c)).toList() : null;

    if (FavoriteList != null) {
      flg = true;
    } else {
      flg = false;
    }
    notifyListeners();
  }

  getAllFavoriteTrivias() async {
    final db = await database;
    var res = await db.query(_tableName, orderBy: 'id');
    FavoriteList =
        res.isNotEmpty ? res.map((c) => Favorite.fromMap(c)).toList() : [];
    this.FavoriteList = FavoriteList;
    return FavoriteList;
  }

  createFavorite(Trivia trivia) async {
    final db = await database;
    var res = await db.insert(_tableName, trivia.toMap());
    return res;
  }

  createFavorite2(Favorite favorite) async {
    final db = await database;
    var res = await db.insert(_tableName, favorite.toMap());
    return res;
  }

  deleteFavorite(int id) async {
    final db = await database;
    var res = db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }

  updateTrivia(trivia) async {
    final db = await database;
    var res = await db.update(_tableName, trivia.toMap(),
        where: "id = ?", whereArgs: [trivia.id]);
    return res;
  }
}
