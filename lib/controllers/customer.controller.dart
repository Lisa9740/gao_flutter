import 'package:gao_flutter/database/db.provider.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Customers extends SQLHelper {

  static Future create(db, data) async {
    await db.insert('customer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  static Future getAll() async {
    var customer = await DBProvider.instance.queryAllRows("customer", null);
    print({"customer", customer});

    if (customer.length > 0) return customer;
    return [];
  }

  static Future get(int id) async {
    var customer = await DBProvider.instance.queryById(id, "customer");
    print({"customer", customer});

    if (customer.length > 0) return customer;
    return [];
  }


}