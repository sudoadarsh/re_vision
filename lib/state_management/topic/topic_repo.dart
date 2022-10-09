import 'package:re_vision/common_cubit/common_cubit_repo.dart';
import 'package:re_vision/state_management/topic/topic_provider.dart';

class TopicRepo extends CommonCubitRepo {
  @override
  fetchData({data}) {
    return TopicProvider().readFromDatabase();
  }
}