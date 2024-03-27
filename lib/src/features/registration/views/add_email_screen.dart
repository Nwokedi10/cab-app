import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/src_barrel.dart';

class AddEmailScreen extends StatelessWidget {
  AddEmailScreen({super.key});
  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Ui.padding(
          child: Form(
            key: controller.fpformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ui.boxHeight(56),
                const AppText(
                  "Forgot Password",
                  color: AppColors.accentColor,
                  fontSize: 28,
                ),
                Ui.boxHeight(14),
                AppText.thin("Enter your email"),
                Ui.boxHeight(32),
                CustomTextField(
                  "johndoe@gmail.com",
                  "Email",
                  controller.textControllers[8],
                  varl: FPL.email,
                ),
                const Spacer(),
                FilledButton.white(() async {
                  await controller.forgotPassword();
                }, "Verify"),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
