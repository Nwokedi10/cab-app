import 'package:flutter/material.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> options;
  final Function(String?)? onChanged;
  final String curOption;
  const CustomDropDown(
      {this.options = const [],
      this.curOption = "",
      this.onChanged,
      super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String curOption = "";

  @override
  void initState() {
    curOption = widget.curOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return CurvedContainer(
        radius: 12,
        color: AppColors.secondaryColor,
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
              dropdownColor: AppColors.secondaryColor,
              underline: SizedBox(),
              items: widget.options
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: AppText.thin(e)))
                  .toList(),
              onChanged: (value) async {
                setState(() {
                  curOption = value!;
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                });
              }),
        ),
      );
    });
  }
}
