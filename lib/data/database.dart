import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('car_service_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)',
    );
    await db.execute('''
      CREATE TABLE auth_users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        linkedUserId INTEGER
      )
    ''');
    await db.execute(
      'CREATE TABLE cars (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER NOT NULL, brand TEXT NOT NULL, model TEXT NOT NULL)',
    );

    await db.execute(
      'CREATE TABLE services (id INTEGER PRIMARY KEY AUTOINCREMENT, carId INTEGER NOT NULL, description TEXT NOT NULL, date TEXT NOT NULL, cost REAL NOT NULL, oilUsed TEXT NOT NULL, mileage INTEGER NOT NULL)',
    );

    // Seed default admin account
    final adminLinkedId = await db.insert('users', {'name': 'Admin'});
    await db.insert('auth_users', {
      'firstName': 'Admin',
      'lastName': 'Admin',
      'email': 'admin@carservice.com',
      'username': 'admin',
      'password': 'admin123',
      'role': 'admin',
      'linkedUserId': adminLinkedId,
    });
  }
}