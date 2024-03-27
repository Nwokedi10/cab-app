import 'package:flutter/material.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class HeaderTile extends StatelessWidget {
  final String title;
  final Widget? child;
  final double padding;
  const HeaderTile(this.title, {this.child, this.padding = 64, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.bold(title, fontSize: 22),
          Ui.boxHeight(24),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class TitleTile extends StatelessWidget {
  final String title;
  final Widget? child;
  final double padding, top;
  const TitleTile(this.title,
      {this.child, this.padding = 24, this.top = 32, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.thin(title, color: AppColors.white40),
          Ui.boxHeight(padding),
          if (child != null) child!,
        ],
      ),
    );
  }
}
