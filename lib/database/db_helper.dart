import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {

    final path = await getDatabasesPath();

    return await openDatabase(
      join(path, 'app.db'), version: 1,
      onCreate: (db, version) async {
        await db.execute(
            ''' CREATE TABLE users (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  username TEXT NOT NULL UNIQUE,
                  password TEXT NOT NULL,
                  email TEXT NOT NULL UNIQUE,
                  full_name TEXT,
                  phone_number TEXT,
                  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                  updated_at TEXT
                  ) '''
        );
        await db.execute(
            ''' CREATE TABLE passwords ( 
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  userId INTEGER, 
                  title TEXT,
                  username TEXT, 
                  password TEXT, 
                  FOREIGN KEY (userId) REFERENCES users (id)
                  )'''
        );
        },
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }


}