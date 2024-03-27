import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';

class CircleDot extends StatelessWidget {
  final Color color;
  final double size;

  const CircleDot({
    Key? key,
    this.color = AppColors.primaryColor,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.3),
      radius: size / 2,
      child: CircleAvatar(
        radius: size / 4,
        backgroundColor: AppColors.accentColor,
      ),
    );
  }
}
