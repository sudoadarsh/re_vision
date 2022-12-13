import '../base_sqlite/schema_model.dart';
import '../constants/string_constants.dart';

class Schemas {
  /// The topic schema.
  static SchemaModel topicSchema = SchemaModel(
    dbColumnList: [
      /// The id column which is the primary key of our local database table.
      DbColumn(
        columnName: StringC.id,
        datatype: DbDataType.text,
        dataAttributes: [DbDataAttr.primaryKey, DbDataAttr.notNull],
      ),

      /// The topic column.
      DbColumn(columnName: StringC.topic, datatype: DbDataType.text),

      /// The attachment column.
      DbColumn(columnName: StringC.attachments, datatype: DbDataType.text),

      /// The notes column.
      DbColumn(columnName: StringC.notes, datatype: DbDataType.text),

      /// The label column.
      DbColumn(columnName: StringC.label, datatype: DbDataType.integer),

      /// The created at column. This will store the time at which the task was
      /// first created.
      DbColumn(columnName: StringC.createdAt, datatype: DbDataType.text),

      /// The scheduledTo column. This will store the next schedule for the task.
      DbColumn(columnName: StringC.scheduledTo, datatype: DbDataType.text),

      /// The iteration column. This will store the count of iteration.
      DbColumn(columnName: StringC.iteration, datatype: DbDataType.integer),

      /// The is online column. Is 1 when the revision is uploaded to the cloud.
      DbColumn(columnName: StringC.isOnline, datatype: DbDataType.integer)
    ],
  );

  /// The topic label schema.
  static SchemaModel labelSchema = SchemaModel(
    dbColumnList: [
      /// The id column which is the primary key of our local database table.
      DbColumn(
        columnName: StringC.id,
        datatype: DbDataType.text,
        dataAttributes: [DbDataAttr.primaryKey, DbDataAttr.notNull],
      ),

      /// The name of the label.
      DbColumn(columnName: StringC.label)
    ],
  );
}
