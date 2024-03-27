import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class StarRateWidget extends StatefulWidget {
  const StarRateWidget({super.key});

  @override
  State<StarRateWidget> createState() => _StarRateWidgetState();
}

class _StarRateWidgetState extends State<StarRateWidget> {
  int curStar = -1;
  bool onPressed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: onPressed
          ? SizedBox(
              width: Ui.width(context),
              child: Center(
                child: CircularProgress(24),
              ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  5,
                  (index) => IconButton(
                        onPressed: onPressed
                            ? () {}
                            : () {
                                setState(() {
                                  curStar = index;
                                  onPressed = true;
                                });
                                Future.delayed(Duration(seconds: 3), () {
                                  Get.offAll(HomeScreen());
                                });
                              },
                        icon: Icon(IconlyBold.star),
                        iconSize: 40,
                        color: curStar < index
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      )),
            ),
    );
  }
}
