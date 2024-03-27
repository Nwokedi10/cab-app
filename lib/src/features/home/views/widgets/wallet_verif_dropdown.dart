import 'package:flutter/material.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../global/ui/widgets/others/containers.dart';
import '../../../../src_barrel.dart';

class IDWalletDropDown extends StatelessWidget {
  IDWalletDropDown({super.key});

  List<String> options = [
    "National Identity Card",
    "Voters Card",
    "International Passport"
  ];
  String curOption = "National Identity Card";

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return CurvedContainer(
        radius: 12,
        color: AppColors.transparent,
        border: Border.all(color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton<String>(
              value: curOption,
              isExpanded: true,
              elevation: 0,
              hint: AppText.thin(curOption),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accentColor,
              ),
              borderRadius: Ui.circularRadius(12),
              dropdownColor: AppColors.primaryColor,
              underline: SizedBox(),
              items: options
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: AppText.thin(e)))
                  .toList(),
              onChanged: (value) async {
                setState(() {
                  curOption = value!;
                });
              }),
        ),
      );
    });
  }
}
