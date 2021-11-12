import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE computer(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,   
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT,   
        password TEXT,   
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""CREATE TABLE customer(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstname TEXT,   
        lastname TEXT,   
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""CREATE TABLE attribution(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        hour INTEGER,
        date DATETIME,   
        customerId INTEGER,  
        computerId INTEGER, 
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'gao.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await database.insert('customer', { 'firstname': 'LOLO', 'lastname': 'Lidzad'}, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      },
    );
  }

}