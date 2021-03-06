import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gao_flutter/database/db.provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class LocalDatabase{


  static cleanDatabase() async*{
     await deleteAllFromTable("computer");
     await deleteAllFromTable("customer");
     await deleteAllFromTable("attribution");
  }


  static sync(data) async {
    print("SYNCING TO LOCALDATABASE...");
    await cleanDatabase();
    await syncComputers(data);
  }

  static deleteAllFromTable(table) async {
    print({"deletion of " + table});
    await DBProvider.instance.deleteQuery("delete from "+ table);
  }

  static syncComputers(data) async{
    print({"sync computer data", data});
    var computer = {"id": data.id, "name": data.name};
    var attribution = data.attributions;
    if (attribution.length > 0 ) await syncAttributions(attribution, data.id);

    await DBProvider.instance.insert(computer, "computer");
    return;
  }

  static syncCustomers(data) async{
    print({"sync customer data", data});
    var customer = {"id" : data['id'], "firstname" : data['firstname'],  "lastname" : data['lastname'] };
    await DBProvider.instance.insert(customer, "customer");
  }

  static syncAttributions(datas, computerId) async{
    print({"sync attribution data", datas});
    var attribution;
    datas[0].forEach((data) async {
      await syncCustomers(data['Customer']);
      attribution = { "id" : data['id'], "hour": data['hour'], "date" : data['date'], "customerId": data['Customer']['id'], "computerId": computerId};
      await DBProvider.instance.insert(attribution, "attribution");
    });
    return;
  }
}