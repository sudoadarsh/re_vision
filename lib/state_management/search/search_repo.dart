import 'package:re_vision/common_cubit/common_cubit_repo.dart';
import 'package:re_vision/state_management/search/search_provider.dart';

class SearchRepo extends CommonCubitRepo {
  @override
  fetchData({data}) {
    return SearchProvider().fetch(data);
  }
}