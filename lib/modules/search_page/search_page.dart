import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  /// The list of friends to send the request to.
  late List<Map<String, UserFBDm>> _requestsMade;

  @override
  void initState() {
    super.initState();
    _requestsMade = [];
    _sc = TextEditingController();
    _searchCubit = CommonCubit(SearchRepo());
    _getFriends();
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
    _searchCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const BaseText(StringC.search),
          backgroundColor: ColorC.secondary,
        ),
        body: SafeArea(
          child: Column(
            children: [
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
                            onAdd: (user) {
                              _requestsMade.add({filterD[ind].id: user});
                            },
                            onRemove: (user) {
                              _requestsMade.removeWhere((element) =>
                                  element.keys.first.toString() ==
                                  filterD[ind].id);
                            },
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
        ),
      ),
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

  /// Function to perform when [SearchPage] is exited.
  Future<bool> _onWillPop() async {
    if (_requestsMade.isEmpty) return true;

    Navigator.of(context).pop(_requestsMade);
    return true;
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
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  final UserFBDm data;
  final String userId;
  final List<String> frs;
  final Function(UserFBDm) onAdd;
  final Function(UserFBDm) onRemove;

  @override
  State<_UserResult> createState() => _UserResultState();
}

class _UserResultState extends State<_UserResult> {
  /// Boolean to live update the button.
  late bool _send;

  /// Boolean to check if the other user is already a friend.
  late bool _alreadyAFr;

  /// The list of current friends of the user.
  List<String> get _frs => widget.frs;

  @override
  void initState() {
    super.initState();
    _send = true;
    _alreadyAFr = false;
    _checkFr();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BaseText(widget.data.name ?? ""),
      subtitle: BaseText(widget.data.email ?? ""),
      trailing: _alreadyAFr
          ? SizeC.none
          : _send
              ? _requestButton()
              : _requestedButton(),
    );
  }

  BaseElevatedButton _requestButton() {
    return BaseElevatedButton(
      backgroundColor: ColorC.secondary,
      size: SizeC.elevatedButton,
      onPressed: () {
        widget.onAdd(widget.data);
        _changeButton();
      },
      child: const BaseText(StringC.add, color: ColorC.white),
    );
  }

  BaseOutlineButton _requestedButton() {
    return BaseOutlineButton(
      borderColor: Colors.black,
      onPressed: () {
        widget.onRemove(widget.data);
        _changeButton();
      },
      child: const BaseText(StringC.remove),
    );
  }

  // --------------------------- Functions -------------------------------------

  /// To change the current button.
  void _changeButton() {
    _send = !_send;
    setState(() {});
  }

  /// To check if the other user is already a friend.
  void _checkFr() {
    String fr = _frs.firstWhere(
      (element) => element == widget.userId,
      orElse: () => "",
    );

    if (fr.isNotEmpty) {
      _alreadyAFr = true;
      setState(() {});
    }
  }
}
