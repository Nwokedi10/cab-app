import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class PaymentDropDown extends StatefulWidget {
  const PaymentDropDown({this.dm = DeliveryMode.none, super.key});

  final DeliveryMode dm;

  @override
  State<PaymentDropDown> createState() => _PaymentDropDownState();
}

class _PaymentDropDownState extends State<PaymentDropDown> {
  List<String> options = [];
  String curOption = "";

  @override
  void initState() {
    // TODO: implement initState
    options = widget.dm == DeliveryMode.none
        ? ["Cash", "Udrive Wallet", "Card"]
        : ["Udrive Wallet"];
    curOption = widget.dm == DeliveryMode.none
        ? MyPrefs.readData(MyPrefs.mpUdrivePaym) ?? "Cash"
        : "Udrive Wallet";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            items: options
                .map((e) =>
                    DropdownMenuItem<String>(value: e, child: AppText.thin(e)))
                .toList(),
            onChanged: (value) async {
              setState(() {
                curOption = value!;
              });
              await MyPrefs.savePaymentMethod(curOption);
            }),
      ),
    );
  }
}
