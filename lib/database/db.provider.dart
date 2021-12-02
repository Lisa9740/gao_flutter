import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider {
  static Database? _database;
  DBProvider._();

  static final DBProvider _db = DBProvider._();

  static final columns = [];
  static DBProvider get instance => _db;


  Future<Database> get database async =>
      _database ??= await initDB();

  // Create the database and the Employee table
  initDB() async {
    final path = join(await getDatabasesPath(), 'gao.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await createTables(db);
    });
  }

  static Future<void> createTables(Database database) async {
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

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(table, options) async {
    Database db = await instance.database;
    if (options != null){
      return await db.query(table, limit: options['limit'] , offset: options['offset']);
    }
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> rawQuery(rawQuery) async {
    Database db = await instance.database;
    return await db.rawQuery(rawQuery);
  }

  deleteQuery(rawQuery) async {
    Database db = await instance.database;
    var batch = db.batch();
    await db.transaction((txn) async { batch.rawQuery(rawQuery);}
    );
  }
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount(table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future queryById(id, table) async {
    Database db = await instance.database;
    return await db.query(table, where: 'id = ?', whereArgs: [id]);
  }
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, column, table) async {
    Database db = await instance.database;
    int id = row[column];
    return await db.update(table, row, where: '$column = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }


}
