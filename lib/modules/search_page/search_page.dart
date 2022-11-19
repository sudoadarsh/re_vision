import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_bottom_modal_sheet.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/base_widgets/base_outline_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/user_dm.dart';
import 'package:re_vision/state_management/search/search_repo.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

import '../../common_cubit/common__cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _sc;

  /// The search cubit.
  late final CommonCubit _searchCubit;

  /// The list of friends of the user.
  late final List<String> _friends;

  @override
  void initState() {
    super.initState();
    _sc = TextEditingController();
    _searchCubit = CommonCubit(SearchRepo());
    _getFriends();
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConfig.height(context) * 0.8,
      child: Column(
        children: [
          const BaseNotch(),
          BaseTextFormFieldWithDepth(
            controller: _sc,
            labelText: StringC.search,
            prefixIcon: IconC.search,
            onFieldSubmitted: (val) async {
              _searchCubit.fetchData<QueryDocumentSnapshot>(data: val);
            },
          ),
          BlocBuilder(
            bloc: _searchCubit,
            builder: (context, state) {
              if (state is CommonCubitStateLoading) {
                return Expanded(
                  child: const CupertinoActivityIndicator().center(),
                );
              } else if (state is CommonCubitStateLoaded) {
                List<QueryDocumentSnapshot> data =
                state.data as List<QueryDocumentSnapshot>;
                List<QueryDocumentSnapshot> filterD = data
                    .where((element) =>
                element.id != BaseAuth.currentUser()?.uid)
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    itemCount: filterD.length,
                    itemBuilder: (context, ind) {
                      UserFBDm filterM =
                      UserFBDm.fromJson(filterD[ind].data());
                      return _UserResult(
                        frs: _friends,
                        data: filterM,
                        userId: filterD[ind].id,
                      );
                    },
                  ),
                );
              }
              return SizeC.none;
            },
          )
        ],
      ).paddingDefault(),
    );
  }

  // -------------------------------- Functions --------------------------------

  /// To get the friends of the current user.
  Future<void> _getFriends() async {
    _friends = await BaseCloud.readSCIDs(
      collection: CloudC.users,
      document: BaseAuth.currentUser()?.uid ?? "",
      subCollection: CloudC.friends,
    );
  }
}

/// A [ListTile] representing the user results.
///

class _UserResult extends StatefulWidget {
  const _UserResult({
    Key? key,
    required this.data,
    required this.userId,
    required this.frs,
  }) : super(key: key);

  final UserFBDm data;
  final String userId;
  final List<String> frs;

  @override
  State<_UserResult> createState() => _UserResultState();
}

class _UserResultState extends State<_UserResult> {
  /// Boolean to live update the button.
  late Widget _currentButton;

  @override
  void initState() {
    super.initState();
    _currentButton = _checkReq();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BaseText(widget.data.name ?? ""),
      subtitle: BaseText(widget.data.email ?? ""),
      trailing: _currentButton,
    );
  }

  /// Friend Request.
  void _friendRequest() {
    // todo: add friend request in the request sub-collection.

    _currentButton = _requestedButton();
    setState(() {});
  }

  void _removeRequest() {
    // todo: delete friend request from the sub collection.
    _currentButton = _requestButton();
    setState(() {});
  }

  /// To check whether the searched user is already requested a request.
  Widget _checkReq() {
    return _requestButton();
  }

  BaseElevatedButton _requestButton() {
    return BaseElevatedButton(
      backgroundColor: ColorC.elevatedButton,
      size: const Size(50, 40),
      onPressed: _friendRequest,
      child: const BaseText(StringC.request),
    );
  }

  BaseOutlineButton _requestedButton() {
    return BaseOutlineButton(
      borderColor: Colors.black,
      onPressed: _removeRequest,
      child: const BaseText(StringC.requested),
    );
  }
}
