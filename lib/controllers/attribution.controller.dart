import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:gao_flutter/models/attribution.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';


class Attributions extends SQLHelper{

  static Future createAttribution(db, data) async {
    await db.insert('attribution', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  static Future<List<Map<String, dynamic>>> getComputerAttribution(int computerId, date) async {
    final db = await SQLHelper.db();
    final attr = await db.rawQuery("SELECT * FROM attribution WHERE computerId = " + computerId.toString() + " AND date = '" + date.toString() + "';");
    print({"attribution getting" , attr});
    return attr;
  }

  static Future<List<Map<String, dynamic>>> getAttribution(int id) async {
    final db = await SQLHelper.db();
    return db.query('attribution', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteAttribution(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("attribution", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}