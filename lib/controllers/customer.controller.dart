import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Customers extends SQLHelper {

  static Future create(db, data) async {
    await db.insert('customer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  static Future<List<Map<String, dynamic>>> get(int id) async {
    final db = await SQLHelper.db();
    return db.query('customer', where: "id = ?", whereArgs: [id], limit: 1);
  }


}