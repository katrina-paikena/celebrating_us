import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:celebrating_us/model/celebration.dart';
import 'storage_service.dart';

class SqliteStorageService extends StorageService {
  late Database _database;

  Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'calendar.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
        CREATE TABLE celebrations(
          id INTEGER PRIMARY KEY,
          name TEXT,
          date INTEGER,
          type INTEGER
        )
      ''');
        });
  }

  @override
  Future<List<Celebration>> getCelebrationsDate(DateTime dateTime) async {
    if (_database.isOpen == false) {
      await open();
    }

    final result = await _database.query(
      'celebrations',
      where: 'date = ?',
      whereArgs: [dateTime.millisecondsSinceEpoch],
    );

    return result.map((e) => Celebration(
      id: e['id'] as int,
      name: e['name'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(e['date'] as int),
      type: CelebrationType.values[e['type'] as int],
    )).toList();
  }

  @override
  Stream<List<Celebration>> getAllCelebrations() {
    if (_database.isOpen == false) {
      open();
    }

    return _database
        .query('celebrations')
        .asStream()
        .map((rows) => rows.map((e) => Celebration(
      id: e['id'] as int,
      name: e['name'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(e['date'] as int),
      type: CelebrationType.values[e['type'] as int],
    )).toList());
  }

  @override
  Future<void> saveCelebration(Celebration celebration) async {
    if (_database.isOpen == false) {
      await open();
    }

    await _database.insert(
      'celebrations',
      celebration.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  void clearAllCelebrations() async {
    if (_database.isOpen == false) {
      await open();
    }

    await _database.delete('celebrations');
  }
}