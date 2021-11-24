import 'package:flutter/foundation.dart';
import 'package:gao_flutter/controllers/attribution.controller.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:gao_flutter/models/computer.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


class Computers extends SQLHelper {

  static Future<int> createComputer(String name) async {
    final db = await SQLHelper.db();
    final data = {'name': name};
    final id = await db.insert('computer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Get all computers
  static Future<List<Computer>> getComputers(date, page) async {
    final computers;
    var attributions;
    final db = await SQLHelper.db();
    await ComputerAPIProvider().fetchComputer(date, page);


    //attributions = await Attributions.getComputerAttribution(db, computerId, date);
    computers =  await db.query('computer', limit: 3, offset: 1);
    print(computers);
    return format(computers, date);
  }

  static getAttributionByComputerId(date, computerId) {
    return Attributions.getComputerAttribution(computerId, date);
  }

  static Future<List<Computer>> format(computers, date) async {
    List<Computer> formattedData = <Computer> [];
    var newFormat;
    var attr;
    date = DateFormat('yyyy-MM-dd').format(date);

    computers.forEach((computer)  async {
      attr = getAttributionByComputerId(date, computer['id']);
      if (attr != null){
        newFormat = {"id": computer["id"], "name": computer["name"], "Attributions" : attr };
      }
      newFormat = {"id": computer["id"], "name": computer["name"], "Attributions" : []};
      formattedData.add(Computer.fromJson(newFormat));
    });
    print({"format", formattedData});
    return formattedData;
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