import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';
import '../../models/message.dart';

class ChatBoxWidget extends StatelessWidget {
  final Messages msg;
  ChatBoxWidget(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = Ui.width(context) - 48;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
          msg.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CurvedContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color:
              msg.isSentByMe ? AppColors.secondaryColor : AppColors.accentColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: c - (c / 3)),
            child: AppText.thin(
              msg.desc!,
            ),
          ),
        ),
      ],
    );
  }
}
