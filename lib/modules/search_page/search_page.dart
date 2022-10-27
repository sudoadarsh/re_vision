import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/user_dm.dart';
import 'package:re_vision/state_management/search/search_repo.dart';

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

  @override
  void initState() {
    super.initState();
    _sc = TextEditingController();

    _searchCubit = CommonCubit(SearchRepo());
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BaseTextFormFieldWithDepth(
              controller: _sc,
              labelText: StringC.search,
              prefixIcon: IconC.search,
              onFieldSubmitted: (val) async {
                _searchCubit.fetchData<QueryDocumentSnapshot>(data: val);
                // await BaseCloud.db
                //     ?.collection("users")
                //     .where("email", isGreaterThanOrEqualTo: val?.trim())
                //     .get()
                //     .then((value) {
                //       List docs = value.docs;
                //       for (QueryDocumentSnapshot element in docs) {
                //         print (element.data().toString());
                //       }
                //     });
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
                    return Expanded(child: ListView.builder(
                      itemCount: data.length,
                        itemBuilder: (context, ind) {
                        UserFBDm decodedD = UserFBDm.fromJson(data[ind].data());
                        return ListTile(
                          title: BaseText(decodedD.name ?? ""),
                        );
                    }));
                  }
                  return SizeC.none;
                })
          ],
        ).paddingDefault(),
      ),
    );
  }
}
