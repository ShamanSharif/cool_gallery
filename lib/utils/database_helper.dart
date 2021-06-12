import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();
  static Database _database;

  static final albumTableName = "albums";
  static final photoTableName = "photos";
  static final colName = "fetched_data";

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'twelve_clock_data.db'),
        onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $albumTableName (
          $colName TEXT PRIMARY KEY
        )''');
      await db.execute('''CREATE TABLE $photoTableName (
          $colName TEXT PRIMARY KEY
        )''');
    }, version: 1);
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }
}
