import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:your_app/user.dart';

class DatabaseHelper {
  static late Database _database;
  static bool _isDatabaseInitialized = false;
  static Completer<Database> _dbCompleter = Completer();

  Future<Database> get database async {
    if (!_isDatabaseInitialized) {
      await _initializeDatabase();
    }

    return _dbCompleter.future;
  }

  Future<void> _initializeDatabase() async {
    try {
      sqfliteFfiInit(); // Initialize sqflite_ffi database factory
      databaseFactory = databaseFactoryFfi; // Set databaseFactory to databaseFactoryFfi
      
      final path = await getDatabasesPath();
      _database = await openDatabase(
        join(path, 'users.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)",
          );
        },
        version: 1,
      );
      _dbCompleter.complete(_database);
      _isDatabaseInitialized = true;
    } catch (e) {
      _dbCompleter.completeError(e);
    }
  }

  Future<int> insertUser(User user) async {
    final Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
}
