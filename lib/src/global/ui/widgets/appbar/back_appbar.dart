import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar({String? title, Color color = AppColors.white}) {
  return AppBar(
      backgroundColor: Colors.transparent,
      title: title == null
          ? null
          : AppText.bold(title, fontSize: 22, color: color),
      elevation: 0,
      leading: Builder(builder: (context) {
        return SvgIconButton(
          Assets.back,
          () {
            Get.back();
          },
          size: 40,
          padding: 16,
        );
      }));
}
