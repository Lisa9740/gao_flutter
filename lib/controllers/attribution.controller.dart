import 'package:flutter/foundation.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:gao_flutter/models/attribution.dart';
import 'package:gao_flutter/models/attribution.dart';
import 'package:gao_flutter/models/attribution.dart';
import 'package:gao_flutter/models/attribution.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

import 'customer.controller.dart';


class Attributions extends SQLHelper{

  static Future<int> createAttribution(int hour, int computerId, int customerId, String firstname, String lastname) async {
    final db = await SQLHelper.db();
    final data = {'date': null, 'hour': hour, 'computerId': computerId, 'customerId': customerId};
    final attr = await db.insert('attribution', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return attr;
  }

  Future<List> getComputerAttributions(computerId, date) async {
    final db = await SQLHelper.db();
    var attribution = [];
    date = DateFormat('yyyy-MM-dd').format(date);

    attribution = (await db.rawQuery("SELECT * FROM attribution WHERE computerId = " + computerId.toString() + " AND date = '" +  date.toString()  + "';")).cast<Attribution>();
    attribution = await formatData(attribution);
    return attribution;
  }

  Future<List> formatData(attributions) async {
    var customer;
    var data;
    List formattedData = [];
    print({"attr data", attributions});

    attributions.forEach((element) async{
      customer = await Customers.get(element['customerId']);
      data = { "id" : element["id"], "hour" : element['hour'], "date" : element['date'], "computerId" : element['computerId'], "Customer" : customer};
      print({"attr data", data});

      formattedData.add(data);
    });

    print({"attr formateed data", formattedData});
    return formattedData;
  }


  static Future<List<Map<String, dynamic>>> getAttribution(int id) async {
    final db = await SQLHelper.db();
    return db.query('attribution', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteAttribution(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("attribution", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}