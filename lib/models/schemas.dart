import '../base_sqlite/schema_model.dart';
import '../constants/string_constants.dart';

class Schemas {
  static SchemaModel topicSchema = SchemaModel(
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
      DbColumn(columnName: StringConstants.attachments, datatype: DbDataType.text),

      /// The created at column. This will store the time at which the task was
      /// first created.
      DbColumn(
          columnName: StringConstants.createdAt, datatype: DbDataType.text),

      /// The scheduledTo column. This will store the next schedule for the task.
      DbColumn(
          columnName: StringConstants.scheduledTo, datatype: DbDataType.text),

      /// The iteration column. This will store the count of iteration.
      DbColumn(
          columnName: StringConstants.iteration, datatype: DbDataType.integer)
    ],
  );
  
}