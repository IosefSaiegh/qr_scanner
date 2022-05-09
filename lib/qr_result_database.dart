import 'dart:async';
import 'package:qr_scanner/models/qr_result_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QrResultDatabase {
  static final QrResultDatabase instance = QrResultDatabase._init();
  static Database? _database;
  QrResultDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qr_result.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableQrResults (
          ${QrResultFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${QrResultFields.data} TEXT NOT NULL,
          ${QrResultFields.time} TEXT NOT NULL,
          ${QrResultFields.type} TEXT NOT NULL)''');
  }

  Future<QrResult> create(QrResult qrResult) async {
    final db = await instance.database;
    final id = await db.insert(tableQrResults, qrResult.toJson());

    return qrResult.copy(id: id);
  }

  Future<QrResult> readQrResult(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableQrResults,
      columns: QrResultFields.values,
      where: '${QrResultFields.id} = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty
        ? QrResult.fromJson(maps.first)
        : throw Exception('No results found');
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableQrResults,
      where: '${QrResultFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<QrResult>> readAllQrResults() async {
    final db = await instance.database;
    final results =
        await db.query(tableQrResults, orderBy: '${QrResultFields.time} DESC');
    return results.map((json) => QrResult.fromJson(json)).toList();
  }

  Future close() async {
    var db = await instance.database;
    return db.close();
  }
}
