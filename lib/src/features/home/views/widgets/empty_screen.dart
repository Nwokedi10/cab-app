import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';
import 'package:udrive/src/utils/constants/constant_barrel.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(IconlyLight.discovery,
              size: Ui.width(context) * 0.42, color: AppColors.accentColor),
          Ui.boxHeight(24),
          AppText.medium("No rides yet")
        ],
      ),
    );
  }
}
