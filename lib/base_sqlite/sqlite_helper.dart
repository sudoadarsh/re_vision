import 'package:re_vision/base_sqlite/schema_model.dart';
import 'package:sqflite/sqflite.dart';

import 'base_sqlite_model.dart';

class BaseSqlite {
  static late Database _db;

  /// Initialise the [BaseSqlite] in the main page to use it.
  static Future<Database> init() async {
    _db = await openDatabase('localdb.db', version: 1);
    return _db;
  }

  static Future createTable(
      {required String tableName, required SchemaModel model}) async {
    /* Creating a batch. */
    Batch batch = _db.batch();

    /* Execute batch*/
    batch.execute('''CREATE TABLE IF NOT EXISTS $tableName(
    ${model.getSqlQuery()}
    )''');

    /* Commit the batch. */
    await batch.commit(noResult: true);
  }

  static Future select({
    required String tableName,
    String? where,
    Object? whereArgs,
    String? customWhere,
  }) async {
    /* Execute the branch. */
    return await _db.query(tableName,
        where: customWhere ?? '$where=?', whereArgs: [whereArgs]);
  }

  static Future selectWithoutArgs({required String tableName}) async {
    /* Execute the branch. */
    return await _db.query(
      tableName,
    );
  }

  static Future insert(
      {required String tableName, required BaseSqliteModel data}) async {
    /* Creating a batch. */
    Batch batch = _db.batch();

    /* Execute the batch. */
    batch.insert(tableName, data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort);

    /* Commit the batch. */
    await batch.commit(noResult: true);
  }

  static Future update({
    required String tableName,
    required BaseSqliteModel data,
    String? customWhere,
    required String where,
    required Object? whereArgs,
  }) async {
    /* Creating a batch. */
    Batch batch = _db.batch();

    /* Execute the batch. */
    batch.update(
      tableName,
      data.toJson(),
      where: customWhere ?? '$where=?',
      whereArgs: [whereArgs],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    /* Commit the batch. */
    await batch.commit(noResult: true);
  }

  static Future delete({
    required String tableName,
    required String where,
    required Object? whereArgs,
    String? customWhere,
  }) async {
    /* Creating the batch. */
    Batch batch = _db.batch();

    /* Execute the batch. */
    batch.delete(tableName,
        where: customWhere ?? '$where=?', whereArgs: [whereArgs]);

    /* Commit the batch. */
    await batch.commit(noResult: true);
  }
}