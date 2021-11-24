import 'package:gao_flutter/controllers/attribution.controller.dart';
import 'package:gao_flutter/controllers/customer.controller.dart';
import 'package:gao_flutter/database/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;

class LocalDatabase{

  static sync(data) async {
    final db = await SQLHelper.db();
    print("SYNCING TO LOCALDATABASE...");
    await syncComputers(db, data);
  }

  static syncComputers(db, data) async{
    print({"sync computer data", data});
    var computer = {"id": data.id, "name": data.name};
    var attribution = data.attributions;

    if (attribution.length > 0 ){
      await syncAttributions(db, attribution, data.id);
    }
    await db.insert("computer", computer,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return;
  }

  static syncCustomers(db, data) async{
    print({"sync customer data", data});
    var customer = {"id" : data['id'], "firstname" : data['firstname'],  "lastname" : data['lastname'] };
    await Customers.create(db, customer);
  }

  static syncAttributions(db, datas, computerId) async{
    print({"sync attribution data", datas});
    var attribution;
    datas[0].forEach((data) async {
      await syncCustomers(db, data['Customer']);
      attribution = { "id" : data['id'], "hour": data['hour'], "date" : data['date'], "customerId": data['Customer']['id'], "computerId": computerId};
      await Attributions.createAttribution(db, attribution);
    });
    return;
  }
}