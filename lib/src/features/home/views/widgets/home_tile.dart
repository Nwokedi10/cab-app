import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class HomeTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Widget? child;
  const HomeTile(this.title, {this.onTap, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Column(
        children: [
          ListTile(
            leading: AppText.medium(title),
            onTap: onTap,
            trailing: onTap != null
                ? Icon(
                    IconlyLight.arrow_right_2,
                    color: AppColors.accentColor,
                    size: 14,
                  )
                : null,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
