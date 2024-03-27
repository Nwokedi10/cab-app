import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/payment_controller.dart';
import 'package:udrive/src/global/ui/functions/ui_functions.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/text/app_text.dart';
import 'package:udrive/src/src_barrel.dart';

class PaymentCardChooser extends StatelessWidget {
  PaymentCardChooser({super.key});

  final controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return controller.cards.isNotEmpty
        ? Obx(() {
            return Column(
              children: [
                ...List.generate(
                    controller.cards.length, (index) => item(index))
              ],
            );
          })
        : SizedBox();
  }

  Widget item(int i) {
    return Row(
      children: [
        Radio<int>(
            value: i,
            groupValue: controller.currentCard,
            onChanged: (i) {
              controller.changeCard(i ?? 0);
            }),
        Ui.boxWidth(4),
        AppText.thin(controller.cards[i].obscureNo),
        const Spacer(),
        PaymentCardIcon(controller.cards[i].cardType),
        Ui.boxWidth(4),
        IconButton(
            onPressed: controller.removeCard(i),
            icon: Icon(
              IconlyLight.delete,
              color: AppColors.white,
              size: 16,
            ))
      ],
    );
  }
}
