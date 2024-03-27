import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/src_barrel.dart';

class AddPhoneScreen extends StatelessWidget {
  AddPhoneScreen({super.key});
  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Ui.padding(
          child: Form(
            key: controller.pformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ui.boxHeight(56),
                const AppText(
                  "Almost There!",
                  color: AppColors.accentColor,
                  fontSize: 28,
                ),
                Ui.boxHeight(14),
                AppText.thin("Enter your mobile number."),
                Ui.boxHeight(32),
                CustomTextField(
                  "0906 xxx 6789",
                  "Phone Number",
                  controller.textControllers[6],
                  varl: FPL.phone,
                ),
                const Spacer(),
                FilledButton.white(() async {
                  await controller.verifyPhone();
                }, "Verify Account"),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
