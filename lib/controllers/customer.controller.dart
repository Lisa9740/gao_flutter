import 'package:gao_flutter/database/sql_helper.dart';

class Customers extends SQLHelper {
  static Future<List<Map<String, dynamic>>> get(int id) async {
    final db = await SQLHelper.db();
    return db.query('customer', where: "id = ?", whereArgs: [id], limit: 1);
  }
}