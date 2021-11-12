import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Computers extends SQLHelper {
  static Future<int> createComputer(String name) async {
    final db = await SQLHelper.db();

    final data = {'name': name};
    final id = await db.insert('computer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getComputers() async {
    final db = await SQLHelper.db();
    return db.query('computer', orderBy: "id");
  }


  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getComputer(int id) async {
    final db = await SQLHelper.db();
    return db.query('computer', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateComputer(
      int id, String name) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
    };

    final result =
    await db.update('computer', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteComputer(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("computer", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}