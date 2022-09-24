import '../base_sqlite/schema_model.dart';
import '../constants/string_constants.dart';

class Schemas {
  static SchemaModel itemSchema = SchemaModel(
    dbColumnList: [
      /// The id column which is the primary key of our local database table.
      DbColumn(
        columnName: StringConstants.id,
        datatype: DbDataType.integer,
        dataAttributes: [
          DbDataAttr.primaryKey,
          DbDataAttr.autoIncrement,
          DbDataAttr.notNull
        ],
      ),

      /// The topic column.
      DbColumn(columnName: StringConstants.topic, datatype: DbDataType.text),

      /// The attachment column.
      DbColumn(columnName: StringConstants.attachment, datatype: DbDataType.text),
    ],
  );
  
}