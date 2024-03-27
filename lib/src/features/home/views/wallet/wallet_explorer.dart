import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/home/views/wallet/udrive_cash_home.dart';
import 'package:udrive/src/features/home/views/wallet/verify_id_wallet_screen.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class WalletExplorer extends StatelessWidget {
  WalletExplorer({super.key});
  final controller = Get.find<WalletController>();
  final screens = [
    WalletVerifPage(),
    CheckingVerificationPage(),
    RejectedPage(),
    UdriveWalletScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return screens[controller.currentVerification.value];
    });
  }
}

class CheckingVerificationPage extends StatelessWidget {
  CheckingVerificationPage({super.key});
  final controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      await controller.changeProcess(3);
    });
    return SinglePageScaffold(
        title: "Udrive Cash",
        child: Ui.padding(child: SizedText.thin("Setting your wallet")));
  }
}

class RejectedPage extends StatelessWidget {
  RejectedPage({super.key});
  final controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
        title: "Udrive Cash",
        child: Ui.padding(
            child: Column(
          children: [
            Icon(
              IconlyLight.danger,
              size: 128,
              color: AppColors.red,
            ),
            Ui.boxHeight(24),
            SizedText.thin(
                "Sorry, your ID card was rejected, Please try again and input correct details this time around"),
            Ui.boxHeight(24),
            FilledButton.white(controller.resetProcess, "Retry")
          ],
        )));
  }
}
