import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:collection/collection.dart';

import 'habits.dart';

class Db {
  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  late String path;

  Future<Database> _initDatabase() async {
    path = await getDatabasesPath();
    path = join(path, 'Habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY,name TEXT, spent INTEGER, goal INTEGER, started BIT)');
  }
}
