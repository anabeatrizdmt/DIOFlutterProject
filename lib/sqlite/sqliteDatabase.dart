import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

Map<int, String> scripts = {
  1: '''CREATE TABLE bmi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    weight REAL,
    height REAL,
    bmi REAL,
    bmiClassification TEXT
   );''',
};

class SQLiteDatabase {

  static Database? db;

  Future<Database> getDataBase() async {
    db ??= await startDataBase();
    return db!;
  }

  Future<Database> startDataBase() async {
    var bd = await openDatabase(
      path.join(await getDatabasesPath(), 'bmi.db'),
      version: scripts.length, onCreate: (Database db, int version) async {
        for (int i = 1; i <= scripts.length; i++) {
          await db.execute(scripts[i]!);
          debugPrint(scripts[i]!);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (int i = oldVersion + 1; i <= scripts.length; i++) {
          await db.execute(scripts[i]!);
          debugPrint(scripts[i]!);
        }
      }
    );
    return bd;
  }
}
