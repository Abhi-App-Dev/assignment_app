import 'package:demoapp/model/user_location_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static sql.Database? _database;

  static Future<void> init() async {
    if (_database != null) {
      return;
    }

    try {
      var databasePath = await sql.getDatabasesPath();
      String _path =
          path.join(databasePath, 'locations.db');
      _database = await sql.openDatabase(_path,
          version: 1, onCreate: onCreate);
      print("Database created:==>$_path");
    } catch (e) {
      print("Database error:==>$e");
    }
  }

  static Future onCreate(
      sql.Database db, int version) async {
    await db.execute(
        'CREATE TABLE location(id INTEGER PRIMARY KEY,lat TEXT,lng TEXT)');
    print("Database Created:==>");
  }

  static Future insert(
      String table, Location location) async {
    try {
      await _database?.insert(table, location.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      print("Database inserted:==>${location.toString()}");
      get(table);
    } catch (e) {
      print('Database not inserted:==>$e');
    }
  }

  static Future<List<Location>?> get(String table) async {
    final dataList = await _database?.query("location");
    var transactions =
        Location.parseTransactionList(dataList!);
    return transactions;
  }

  static Future deleteTable() async {
    print("table deleted");
    await _database?.delete('location');
    init();
  }
}
