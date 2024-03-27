import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class LoginHeader extends StatelessWidget {
  LoginHeader({super.key});
  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      color: AppColors.primaryColorBackground,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
            children: List.generate(controller.loginStates.length,
                (index) => Expanded(child: item(index)))),
      ),
    );
  }

  Widget item(int i) {
    return Obx(() {
      return CurvedContainer(
        color: i == controller.loginState.value
            ? AppColors.accentColor
            : AppColors.transparent,
        radius: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
          child: AppText.thin(controller.loginStates[i],
              alignment: TextAlign.center),
        ),
        onPressed: () {
          controller.changeLoginState(i);
        },
      );
    });
  }
}
