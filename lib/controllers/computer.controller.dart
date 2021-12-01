import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/db.provider.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';



class Computers extends SQLHelper {

  static Future createComputer(String name, context) async {
    await ComputerAPIProvider().createComputer(name, context);
    return 'ok';
  }

  // Get all computers
  static Future<List> getComputers(connectionStatus, date, page)  async {
    var computers;
    var offset = (page - 1) * 3;
    // If no connection fetch data from API
    if (connectionStatus != ConnectivityResult.none){ await ComputerAPIProvider().fetchComputer(date, page); };
    computers = await DBProvider.instance.queryAllRows('computer', {"limit": 3, "offset": offset});
    return computers;
  }


  // Update an item by id
  static Future<int> updateComputer(int id, String name) async {
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