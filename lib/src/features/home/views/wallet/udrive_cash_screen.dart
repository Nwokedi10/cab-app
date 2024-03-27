import 'package:flutter/material.dart' hide FilledButton;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/payment_controller.dart';
import 'package:udrive/src/features/home/controllers/settings_controller.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/payment_card_chooser.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class UdriveCashScreen extends StatelessWidget {
  UdriveCashScreen({super.key});
  final walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Udrive Cash",
      child: Ui.padding(
        child: Column(
          children: [
            SizedText.thin(
                "Fund your Udrive wallet with cash from your bank account"),
            // Ui.boxHeight(24),
            // Ui.align(
            //     child: AppText.medium("Virtual Account",
            //         color: AppColors.white40)),
            // Ui.boxHeight(24),
            // Ui.align(
            //   child: CurvedContainer(
            //     padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            //     radius: 12,
            //     color: AppColors.secondaryColor.withOpacity(0.4),
            //     child: AppText.thin(walletController.curWallet.value.bank ?? "",
            //         overflow: TextOverflow.ellipsis),
            //   ),
            // ),
            // Ui.boxHeight(12),
            // Ui.align(
            //   child: CurvedContainer(
            //     padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            //     radius: 12,
            //     color: AppColors.secondaryColor.withOpacity(0.4),
            //     child: AppText.thin(
            //         walletController.curWallet.value.bankName ?? "",
            //         overflow: TextOverflow.ellipsis),
            //   ),
            // ),
            // Ui.boxHeight(12),
            // Row(
            //   children: [
            //     Expanded(
            //         child: CurvedContainer(
            //       padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            //       radius: 12,
            //       color: AppColors.secondaryColor.withOpacity(0.4),
            //       child: AppText.thin(
            //           walletController.curWallet.value.bankAcctNo ?? "",
            //           overflow: TextOverflow.ellipsis),
            //     )),
            //     Ui.boxWidth(12),
            //     CurvedContainer(
            //       padding: EdgeInsets.all(16),
            //       radius: 12,
            //       onPressed: () async {
            //         await Clipboard.setData(ClipboardData(
            //             text: walletController.curWallet.value.bankAcctNo));
            //         Ui.showSnackBar("Copied to the clipboard", isError: false);
            //       },
            //       color: AppColors.secondaryColor.withOpacity(0.4),
            //       child: Icon(
            //         Icons.copy_rounded,
            //         size: 16,
            //         color: AppColors.white,
            //       ),
            //     )
            //   ],
            // ),
            // AppText.medium("Cards"),
            // Ui.boxHeight(24),
            // Obx(() {
            //   return walletController.cards.length == 1
            //       ? ListTile(
            //           leading:
            //               AppText.thin(walletController.cards[0].obscureNo),
            //           trailing:
            //               PaymentCardIcon(walletController.cards[0].cardType),
            //         )
            //       : PaymentCardChooser();
            // }),
            const Spacer(),
            SafeArea(
                child: FilledButton.white(() {
              Get.to(UdriveFundWalletScreen());
            }, "Enter Amount"))
          ],
        ),
      ),
    );
  }
}

class UdriveFundWalletScreen extends StatelessWidget {
  UdriveFundWalletScreen({super.key});
  final controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Udrive Cash",
      safeArea: true,
      child: Ui.padding(
        child: Column(
          children: [
            Ui.boxHeight(40),
            AppText.thin("Enter Amount", color: AppColors.white40),
            Ui.boxHeight(64),
            CustomTextField("0.00", "", controller.textEditingController,
                textAlign: TextAlign.center,
                isLabel: false,
                fs: 36,
                autofocus: true,
                varl: FPL.money,
                fw: FontWeight.w500),
            const Spacer(),
            FilledButton.white(() async {
              if (UtilFunctions.nullOrEmpty(
                  controller.textEditingController.value.text)) {
                Ui.showSnackBar("Field can not be empty");
                return;
              }
              await controller.approveFund(context);
            }, "Fund Wallet")
          ],
        ),
      ),
    );
  }
}
