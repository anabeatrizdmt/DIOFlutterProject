import 'package:dioproject/model/bmi_detail.dart';
import 'package:dioproject/sqlite/sqliteDatabase.dart';
import 'package:flutter/material.dart';

class BmiRepository {
  Future<List<BmiDetail>> getData() async {
    List<BmiDetail> bmiDetails = [];
    var db = await SQLiteDatabase().getDataBase();
    var dbResult = await db.rawQuery('SELECT * FROM bmi');
    for (var item in dbResult) {
      debugPrint("Row: $item");
      bmiDetails.add(BmiDetail(
        int.parse(item['id'].toString()),
        DateTime.parse(item['date'].toString()),
        double.parse(item['weight'].toString()),
        double.parse(item['height'].toString()),
      ));
    }
    return bmiDetails;
  }

  Future<void> save(BmiDetail bmiDetail) async {
    var db = await SQLiteDatabase().getDataBase();
    await db.rawInsert(
        'INSERT INTO bmi (date, weight, height, bmi, bmiClassification) VALUES (?, ?, ?, ?, ?)',
        [
          bmiDetail.date.toString(),
          bmiDetail.weight,
          bmiDetail.height,
          bmiDetail.bmi,
          bmiDetail.bmiClassification
        ]);

    var dbResult = await db.rawQuery('SELECT * FROM bmi');
    for (var item in dbResult) {
      debugPrint("Row: $item");
    }
  }

  Future<void> delete(BmiDetail bmiDetail) async {
    var db = await SQLiteDatabase().getDataBase();
    await db.rawDelete('DELETE FROM bmi WHERE id = ?', [bmiDetail.id]);
  }
}
