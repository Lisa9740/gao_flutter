import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/db.provider.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';



class Computers{
  static Future createComputer(String name, context) async {
    await ComputerAPIProvider().createComputer(name, context);
    return 'ok';
  }

  // Get all computers
  static Future<List> getComputers(connectionStatus, date, page)  async {
    var computers;
    var offset = (page - 1) * 3;
    // If no connection fetch data from API
    if (connectionStatus != ConnectivityResult.none){
      computers = await ComputerAPIProvider().fetchComputer(date, page);
      return computers;
    };
    computers = await DBProvider.instance.queryAllRows('computer', {"limit": 3, "offset": offset});
    return computers;
  }

  // Update an item by id
  static Future<int> updateComputer(int id, String name) async {
    final data = {'name': name };
    final result = await DBProvider.instance.update(data, id, 'computer');
    return result;
  }

  // Delete
  static Future<void> deleteComputer(int id) async {
    try {
      await DBProvider.instance.delete(id, "computer");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}