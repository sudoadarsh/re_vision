import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_text.dart';
import '../../state_management/labels/labels_cubit.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({Key? key}) : super(key: key);

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  /// The available labels.
  List _labels = [];

  /// The cubit to control the states of label search.
  late final LabelsCubit _labelsCubit;

  /// Text field controller.
  late final TextEditingController _labelC;

  @override
  void initState() {
    super.initState();

    _labelsCubit = LabelsCubit();
    _getJsonLabels();
    _labelC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: AppConfig.height(context) * 0.5,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _labelC,
              decoration: const InputDecoration(hintText: "Search for labels"),
              onChanged: (val) {
                _labelsCubit.searchLabels(_labelC.text, _labels);
              },
            ),
            SizeC.spaceVertical10,
            BlocBuilder(
              bloc: _labelsCubit,
              builder: (context, state) {
                if (state is LabelsEmpty) {

                  print("--------------- is empty");

                } else if (state is LabelsNotFound) {

                  print("create a custom label here");

                } else if (state is LabelsFound) {
                  return _resultLabel(state.result);
                }
                return Flexible(
                  child: ListView.builder(
                    itemCount: _labels.length,
                    itemBuilder: (context, i) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: BaseText(_labels[i]),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizeC.spaceVertical10,
          ],
        ),
      ),
    );
  }

  // -------------------------- Class methods ----------------------------------
  /// To load the labels topic json.
  void _getJsonLabels() async {
    String labels = await rootBundle.loadString('json/topics.json');
    _labels = jsonDecode(labels)["topics"];
  }

  /// The result label builder.
  Widget _resultLabel(List labels) {
    return Flexible(
      child: ListView.builder(
        itemCount: labels.length,
        itemBuilder: (context, i) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: BaseText(labels[i]),
              backgroundColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
