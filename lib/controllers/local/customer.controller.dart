import 'package:gao_flutter/database/db.provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Customers{
  static Future create(db, data) async {
    await db.insert('customer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  static Future get(int id) async {
    var customer = await DBProvider.instance.queryById(id, "customer");
    if (customer.length > 0) return customer;
    return [];
  }

  static Future getAll() async {
    var customer = await DBProvider.instance.queryAllRows("customer", null);
    if (customer.length > 0) return customer;
    return [];
  }
}