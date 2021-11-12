import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Attributions extends SQLHelper{
  static Future<int> createAttribution(int hour, int computerId, int customerId, String firstname, String lastname) async {
    final db = await SQLHelper.db();
    final data = {'date': null, 'hour': hour, 'computerId': computerId, 'customerId': customerId};
    final attr = await db.insert('attribution', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return attr;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getAttributions() async {
    final db = await SQLHelper.db();
    return db.query('attribution', orderBy: "id");
  }


  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getAttribution(int id) async {
    final db = await SQLHelper.db();
    return db.query('attribution', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Delete
  static Future<void> deleteAttribution(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("attribution", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}