import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:udrive/src/features/home/controllers/others.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/searchfields.dart';
import 'package:udrive/src/global/model/loc.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../global/ui/widgets/fields/custom_textfield.dart';
import '../../../../global/ui/widgets/others/containers.dart';
import '../../../../src_barrel.dart';

class CarTypeDropDown extends StatefulWidget {
  final CustomDropDownController ddc;
  const CarTypeDropDown(this.ddc, {super.key});

  @override
  State<CarTypeDropDown> createState() => _CarTypeDropDownState();
}

class _CarTypeDropDownState extends State<CarTypeDropDown> {
  List<String> options = [
    "Mercedes",
    "Toyota",
    "Bugatti",
    "Supra",
    "Range Rover",
    "Innoson"
  ];

  String curOption = "Mercedes";

  @override
  void initState() {
    widget.ddc.value = curOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TitleTile(
      "Select Car Type",
      child: CurvedContainer(
        radius: 12,
        color: AppColors.secondaryColor,
        // border: Border.all(color: AppColors.white),
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
                  widget.ddc.value = curOption;
                });
              }),
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  final CounterController counterController;
  const CounterWidget(this.counterController, {super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 1;

  @override
  void initState() {
    // TODO: implement initState

    widget.counterController.value = count.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      radius: 12,
      color: AppColors.secondaryColor,
      padding: EdgeInsets.all(8),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CurvedContainer(
            radius: 8,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: AppText.thin(count.toString()),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  count++;
                  widget.counterController.value = count.toString();
                });
              },
              child: Icon(
                IconlyLight.plus,
                color: AppColors.accentColor,
              )),
          SvgIconButton(
            Assets.minus,
            () {
              if (count == 1) return;
              setState(() {
                count--;
                widget.counterController.value = count.toString();
              });
            },
            padding: 4,
            color: AppColors.accentColor,
          )
        ],
      ),
    );
  }
}

class BookingFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  const BookingFields(this.controllers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleTile(
            "Select Date",
            padding: 0,
            child: CustomTextField(
              "dd/mm/yy",
              "",
              controllers[0],
              readOnly: true,
              isLabel: false,
              suffix: IconlyLight.calendar,
              onTap: () async {
                final newDateTime = await showRoundedDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(Duration(hours: 25)),
                  firstDate: DateTime.now().add(Duration(days: 1)),
                  lastDate: DateTime(DateTime.now().year + 10),
                  borderRadius: 16,
                  height: Ui.height(context) / 2,
                  styleDatePicker: MaterialRoundedDatePickerStyle(
                    textStyleDayOnCalendarSelected:
                        TextStyle(color: AppColors.white),
                    textStyleButtonNegative:
                        TextStyle(color: AppColors.primaryColor),
                    textStyleButtonPositive:
                        TextStyle(color: AppColors.primaryColor),
                    decorationDateSelected: BoxDecoration(
                        color: AppColors.primaryColor, shape: BoxShape.circle),
                    paddingMonthHeader: EdgeInsets.all(12),
                  ),
                  styleYearPicker: MaterialRoundedYearPickerStyle(
                    textStyleYearSelected:
                        TextStyle(color: AppColors.primaryColor),
                  ),
                  theme: ThemeData(
                      primaryColor: AppColors.primaryColor,
                      // accentColor: AppColors.accentColor,
                      colorScheme:
                          ColorScheme.light(secondary: AppColors.primaryColor)),
                );
                if (newDateTime == null) return;
                String date = DateFormat('dd-MM-yy').format(newDateTime);
                controllers[0].text = date;
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleTile(
            "Enter Pick Up Time",
            top: 0,
            padding: 0,
            child: CustomTextField(
              "12:00pm",
              "",
              controllers[1],
              readOnly: true,
              isLabel: false,
              onTap: () async {
                final timePicked = await showRoundedTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    theme: ThemeData(
                      primarySwatch: AppColors.primaryColor,
                    ));
                if (timePicked == null) return;
                String date =
                    "${timePicked.hour}:${timePicked.minute.toString().padLeft(2, "0")}${timePicked.period.name}";
                controllers[1].text = date;
              },
            ),
          ),
        ),
        SearchFields(Loc(name: controllers[2]), Loc(name: controllers[3])),
      ],
    );
  }
}
