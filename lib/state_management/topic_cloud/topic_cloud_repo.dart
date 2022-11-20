import 'package:re_vision/common_button_cubit/common_button_repo.dart';
import 'package:re_vision/state_management/topic_cloud/topic_cloud_provider.dart';

class TopicCloudRepo extends CommonButtonCubitRepo {
  @override
  fetchData({data}) {
    return TopicCloudProvider().fetchData(data);
  }
}