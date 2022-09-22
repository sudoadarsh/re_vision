import 'package:flutter/foundation.dart';
import 'package:re_vision/base_sqlite/extension.dart';

enum DbDataType { integer, real, text, timestamp, blob }

enum DbDataAttr { primaryKey, autoIncrement, notNull }

class SchemaModel {
  final List<DbColumn> dbColumnList;

  SchemaModel({required this.dbColumnList});

  String sqlQuery = '';

  getSqlQuery() {
    for (int i = 0; i < dbColumnList.length; i++) {
      sqlQuery += dbColumnList[i].getColumnQuery();
      if (i < dbColumnList.length - 1) sqlQuery += ', ';
    }
    return sqlQuery;
  }
}

class DbColumn {
  final String columnName;
  final DbDataType datatype;
  final List<DbDataAttr>? dataAttributes;
  final String defValue;

  DbColumn({
    required this.columnName,
    this.datatype = DbDataType.integer,
    this.dataAttributes,
    this.defValue = '',
  });

  getColumnQuery() {
    return '$columnName ${describeEnum(datatype)} ${dataAttributes?.map((e) => e.getAttr()).join(' ') ?? ''}${defValue.isNotEmpty ? ' DEFAULT $defValue' : ''}';
  }
}
