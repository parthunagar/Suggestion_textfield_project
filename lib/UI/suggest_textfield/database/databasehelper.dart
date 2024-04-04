import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import '../model/suggetion_api_model.dart';

class DatabaseHelper {

  static const NEW_DB_VERSION = 6;
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await getDB();
      return _db;
    }
  }

  DatabaseHelper.internal();

  Future<Database> getDB() async {
    debugPrint('==> getDB <==');

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'dictionary_database.db');
    var exists = await databaseExists(path);
    debugPrint('exists : ${exists}');

    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets/database', 'dictionary.db'));
      debugPrint('data : $data');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      debugPrint('bytes : $bytes');
      await File(path).writeAsBytes(bytes, flush: true);
    }
    //return await openDatabase(path);
    var bomDataTable = await openDatabase(path, readOnly: true);
    debugPrint('bomDataTable : $bomDataTable');
    return bomDataTable;

  }

  Future<List<Dictionary>> getAllEntries() async {
    List<Dictionary> user = [];
    var dbClient = await db;
    List<Map> maps = await dbClient!.query('entries',
        // columns: ['word']);
        columns: ['id', 'word', 'wordtype', 'definition']);
    if (maps.isNotEmpty) {
      for (var f in maps) {
        user.add(Dictionary.fromMap(f));
        debugPrint('getAllUser : ${Dictionary.fromMap(f).toString()}');
      }
    }
    return user;
  }



  // Future<List<Dictionary>> getDataWithQuery(String findValue) async {
  Future getDataWithQuery(String findValue) async {
    // List<Dictionary> dictionary = [];
    var dbClient = await db;
    // List<Map> maps = await dbClient!.query('entries',
    //     columns: ['word'],where: 'word',whereArgs: ['a%']);
    List<Map> maps = await dbClient!.rawQuery("SELECT rowid,word,wordtype,definition FROM entries WHERE word like '$findValue%' LIMIT 50");
    // columns: ['id', 'word', 'wordtype', 'definition']);
    // if (maps.isNotEmpty) {
    //   for (var f in maps) {
    //     dictionary.add(Dictionary.fromMap(f));
    //     // debugPrint('getDataWithQuery : ${Dictionary.fromMap(f).toString()}');
    //   }
    // }
    return maps;
  }
}