import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/password_item.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // Set the database factory for web
      databaseFactory = databaseFactoryFfiWeb;
    }

    final path =
        kIsWeb ? 'passkey.db' : join(await getDatabasesPath(), 'passkey.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        notes TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  /// Add a new password
  Future<int> addPassword(PasswordItem passwordItem) async {
    final db = await database;
    return await db.insert('passwords', passwordItem.toMap());
  }

  /// Get all passwords
  Future<List<PasswordItem>> getAllPasswords() async {
    final db = await database;
    final maps = await db.query('passwords', orderBy: 'updatedAt DESC');
    return List.generate(maps.length, (i) => PasswordItem.fromMap(maps[i]));
  }

  /// Update a password
  Future<int> updatePassword(PasswordItem passwordItem) async {
    final db = await database;
    return await db.update(
      'passwords',
      passwordItem.toMap(),
      where: 'id = ?',
      whereArgs: [passwordItem.id],
    );
  }

  /// Delete a password
  Future<int> deletePassword(int id) async {
    final db = await database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get password by ID
  Future<PasswordItem?> getPasswordById(int id) async {
    final db = await database;
    final maps = await db.query(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PasswordItem.fromMap(maps.first);
    }
    return null;
  }
}
