import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class DeliveryRecipientScreen extends StatelessWidget {
  DeliveryRecipientScreen({super.key});
  final controller = Get.find<DeliveryController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Recipient Details",
      safeArea: true,
      child: Ui.padding(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextField(
                "John Doe",
                "Enter Recipient Full Name",
                controller.conts[0],
              ),
              CustomTextField(
                "0906 xxx 6789",
                "Enter Recipient Phone Number",
                controller.conts[1],
                varl: FPL.phone,
              ),
              CustomTextField(
                "Item Description",
                "Enter Item Description",
                controller.conts[2],
              ),
              const Spacer(),
              FilledButton.white(() {
                if (controller.confirmOrder()) {
                  Get.to(LoadingScreen(
                      "Connecting you to a driver...",
                      () async {
                        final c = await controller.searchForDriver();
                        return c;
                      },
                      HomeScreen(),
                      onBack: () async {
                        await controller.terminateRide();
                        Get.back();
                      }));
                }
              }, "Confirm Order"),
            ],
          ),
        ),
      ),
    );
  }
}
