import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/db.provider.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
      computers = await ComputerAPIProvider().fetchComputer(date, page, connectionStatus);
      return computers;
    };
    computers = await DBProvider.instance.queryAllRows('computer', {"limit": 3, "offset": offset, 'orderBy':'id ASC'});
    print(await DBProvider.instance.queryRowCount("computer"));

    return computers;
  }

  static Future getComputerSize(connectionStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pageSize;
    if (connectionStatus != ConnectivityResult.none) {
       pageSize = await ComputerAPIProvider().fetchPageSize();
      await prefs.setString('computerLength', pageSize.toString());
    }
    pageSize = prefs.getString('computerLength');

    return pageSize;

  }

}