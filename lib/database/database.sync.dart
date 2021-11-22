import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DataBaseSync extends SQLHelper{

  sync(data) async {
    await SQLHelper.syncDatabase();
    await syncComputers(data);
  }

  syncComputers(data) async{
    final db = await SQLHelper.db();
    var computer = {"id": data['id'], "name": data['name']};
    var attribution = data['Attributions'];


    if (attribution.length > 0 ){
      await syncAttributions(db, attribution, data["id"]);
    }
    await db.insert("computer", computer,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  syncCustomers(db, data) async{
    var customer = {"id" : data['id'], "firstname" : data['firstname'],  "lastname" : data['lastname'] };
    await db.insert("customer", customer, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  syncAttributions(db, datas, computerId) async{
    var attribution;
    datas[0].forEach((data) async {
      await syncCustomers(db, data['Customer']);
      attribution = { "id" : data['id'], "hour": data['hour'], "date" : data['date'], "customerId": data['Customer']['id'], "computerId": computerId};
      await db.insert("attribution", attribution, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });
    return;
  }
}