class BaseSqliteSelectModel {
  final String tableName;
  final String? where;
  final Object? whereArgs;

  BaseSqliteSelectModel({required this.tableName, this.where, this.whereArgs});
}