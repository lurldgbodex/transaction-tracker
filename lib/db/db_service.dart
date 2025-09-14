import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static Database? _db;
  Completer<Database>? _dbCompleter;

  Future<Database> get database async {
    if (_db != null) return _db!;

    if (_dbCompleter != null) {
      return _dbCompleter!.future;
    }
    _dbCompleter = Completer<Database>();
    try {
      _db = await _initDb();
      _dbCompleter!.complete(_db);
      return _db!;
    } catch (e) {
      _dbCompleter!.completeError(e);
      _dbCompleter = null;
      rethrow;
    }
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            type TEXT,
            category TEXT,
            note TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTransaction(TransactionModel tx) async {
    final db = await database;
    return await db.insert(
      'transactions',
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
