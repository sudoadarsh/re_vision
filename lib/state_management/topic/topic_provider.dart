import 'package:re_vision/base_sqlite/sqlite_helper.dart';
import 'package:re_vision/constants/string_constants.dart';

class TopicProvider {
  Future readFromDatabase() async {
    return BaseSqlite.selectWithoutArgs(tableName: StringC.topicTable);
  }
}