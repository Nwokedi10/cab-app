import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/payment_controller.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});
  final controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Add New Card"),
      body: Ui.padding(
        child: Form(
          key: controller.formkey,
          child: Column(
            children: [
              CustomTextField(
                "John Doe",
                "Card Name",
                controller.textEditinControllers[0],
                varl: FPL.text,
              ),
              CustomTextField(
                "5678 **** **** 5659",
                "Card No",
                controller.textEditinControllers[1],
                varl: FPL.cardNo,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      "123",
                      "CVV",
                      controller.textEditinControllers[2],
                      varl: FPL.cvv,
                    ),
                  ),
                  Ui.boxWidth(24),
                  Expanded(
                    child: CustomTextField(
                      "12/34",
                      "Date",
                      controller.textEditinControllers[3],
                      varl: FPL.dateExpiry,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SafeArea(
                  child: FilledButton.white(() async {
                await controller.addCard();
              }, "Add New Card"))
            ],
          ),
        ),
      ),
    );
  }
}
