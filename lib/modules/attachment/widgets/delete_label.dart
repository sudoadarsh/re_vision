import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../../constants/icon_constants.dart';
import '../../../models/attachment_data_dm.dart';
import '../../../state_management/attachment/attachment_cubit.dart';

class DeleteLabel extends StatelessWidget {
  const DeleteLabel({Key? key, required this.data}) : super(key: key);

  final AttachmentDataDm data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: const Color.fromARGB(24, 154, 149, 149),
      height: 30,
      child: Row(
        children: [
          Flexible(child: BaseText(_getFileName(), overflow: TextOverflow.ellipsis)),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onPressed: () {
              context.read<AttachmentCubit>().removeAttachment(data);
            },
            icon: IconC.delete,
          ),
        ],
      ).paddingOnly(left:4.0),
    );
  }

  // --------------------------- Class methods ---------------------------------
  // To get the image name.
  String _getFileName() {
    return data.data?.split('/').last ?? '';
  }
}