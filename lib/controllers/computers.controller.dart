import 'package:flutter/foundation.dart';
import 'package:gao_flutter/controllers/attribution.controller.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:gao_flutter/models/computer.dart';
import 'dart:convert';


class Computers extends SQLHelper {

  static Future<int> createComputer(String name) async {
    final db = await SQLHelper.db();
    final data = {'name': name};
    final id = await db.insert('computer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Get all computers
  Future<List<Computer>> getComputers(date, page) async {
    final db = await SQLHelper.db();
    var computers;
    await ComputerAPIProvider().fetchComputer(date, page);
    computers =  await db.query('computer', orderBy: "id");
    var tcomputers = await formatComputerData(computers, date);
    print({"getComputers", tcomputers});
    return tcomputers;
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

  Future<List<Computer>> formatComputerData(computers, date) async {
    List<Computer> formattedData = <Computer>[];

    print({"formatteed" ,  computers});
    var attributions;
    var data;

    computers.forEach((element) async{
      //attributions = await Attributions().getComputerAttributions(element["id"], date);
      attributions = [];
      data = { "id" : element["id"], "name" : element['name'], "Attributions" : attributions};
      formattedData.add(Computer.fromJson(data));
    });
    return formattedData;
  }

}