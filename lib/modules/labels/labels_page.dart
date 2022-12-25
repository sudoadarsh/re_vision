import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_underline_field.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/modules/labels/labels_view.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_text.dart';
import '../../state_management/labels/labels_cubit.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({Key? key, required this.selectedLabels}) : super(key: key);
  
  final List selectedLabels;

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> with LabelsView {
  /// The available labels.
  List _labels = [];

  /// The selected labels.
  late List _selectedLabels;

  /// The cubit to control the states of label search.
  late final LabelsCubit _labelsCubit;

  /// Text field controller.
  late final TextEditingController _labelC;

  @override
  void initState() {
    super.initState();
    
    _selectedLabels = widget.selectedLabels;

    _labelsCubit = LabelsCubit();
    _getJsonLabels();
    _labelC = TextEditingController();

    _labelsCubit.searchLabels(_labelC.text, _labels);
  }

  @override
  void dispose() {
    super.dispose();
    _labelsCubit.close();
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
            BaseUnderlineField(
              controller: _labelC,
              hintText: StringC.searchLabels,
              prefixIcon: IconC.search,
              onChanged: (val) {
                _labelsCubit.searchLabels(_labelC.text, _labels);
              },
            ),
            SizeC.spaceVertical10,
            BlocBuilder(
              bloc: _labelsCubit,
              builder: (context, state) {
                if (state is LabelsEmpty) {
                  if (_selectedLabels.isEmpty) {
                    return const BaseText(StringC.noLabelsAdded);
                  }
                  return resultBuilder(
                    items: _selectedLabels,
                    itemBuilder: (context, i) {
                      return labelChip(
                        label: _selectedLabels[i],
                        onTap: () => _labelTapped(_selectedLabels[i]),
                        isSelected: true,
                      );
                    },
                  );
                } else if (state is LabelsNotFound) {
                  return labelChip(
                    label: _labelC.text,
                    onTap: () => _labelTapped(_labelC.text),
                    isSelected: _selectedLabels.contains(_labelC.text),
                  );
                } else if (state is LabelsFound) {
                  return resultBuilder(
                    items: state.result,
                    itemBuilder: (context, i) {
                      return labelChip(
                        label: state.result[i],
                        isSelected: _selectedLabels.contains(state.result[i]),
                        onTap: () => _labelTapped(state.result[i]),
                      );
                    },
                  );
                }
                return resultBuilder(
                  items: _labels,
                  itemBuilder: (context, i) {
                    return labelChip(
                      label: _labels[i],
                      isSelected: _selectedLabels.contains(_labels[i]),
                      onTap: () => _labelTapped(_labels[i]),
                    );
                  },
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

  /// Function to add the label to the selected list if doesn't already exist.
  void _labelTapped(String label) {
    if (_selectedLabels.contains(label)) {
      _selectedLabels.remove(label);
    } else {
      _selectedLabels.add(label);
    }
    setState(() {});
  }
}
