import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gao_flutter/database/db.provider.dart';
import 'package:gao_flutter/providers/api/AttributionProvider.dart';
import 'package:intl/intl.dart';


class Attributions{
  static Future createAttribution(data) async {
    await DBProvider.instance.insert(data, 'attribution');
    return;
  }

  static Future<List> getComputerAttribution(connectionStatus, int computerId, date) async {
    var attr;
    date = DateFormat('yyyy-MM-dd').format(date);
    attr = await DBProvider.instance.rawQuery("SELECT * FROM attribution WHERE computerId = " + computerId.toString() + " AND date = '" + date.toString() + "';");
    if(attr.length > 0) return attr;
    return [];
  }


/*
  static Future<List<Map<String, dynamic>>> getAttribution(int id) async {
    final db = await SQLHelper.db();
    return db.query('attribution', where: "id = ?", whereArgs: [id], limit: 1);
  }
*/

/*  static Future<void> deleteAttribution(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("attribution", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }*/
}