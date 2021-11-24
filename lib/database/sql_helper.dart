import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS computer(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT 
      )
      """);

    await database.execute("""CREATE TABLE IF NOT EXISTS user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT,   
        password TEXT   
      )
      """);

    await database.execute("""CREATE TABLE IF NOT EXISTS customer(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstname TEXT,   
        lastname TEXT
      )
      """);

    await database.execute("""CREATE TABLE IF NOT EXISTS attribution(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        hour INTEGER,
        date DATETIME,   
        customerId INTEGER,  
        computerId INTEGER, 
        FOREIGN KEY(customer_id) REFERENCES customer(id),
        FOREIGN KEY(computer_id) REFERENCES computer(id)
      )
      """);
  }


  static Future<void> cleanDatabase(db) async{
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.delete('computer');
      batch.delete('attribution');
      batch.delete('customer');
      await batch.commit();
    });

  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'gao.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

}