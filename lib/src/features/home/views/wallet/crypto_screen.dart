import 'package:flutter/material.dart' hide FilledButton;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../../src_barrel.dart';

class CryptoScreen extends StatelessWidget {
  CryptoScreen({super.key});
  final controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Crypto",
      safeArea: true,
      child: Ui.padding(
        child: Column(
          children: [
            SizedText.thin(
                "Convert your cryptocurrency to pay for your rides."),
            Ui.boxHeight(36),
            Ui.align(
                child:
                    AppText.medium("Wallet Address", color: AppColors.white40)),
            Ui.boxHeight(24),
            Row(
              children: [
                Expanded(
                    child: CurvedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  radius: 12,
                  color: AppColors.secondaryColor.withOpacity(0.4),
                  child: AppText.thin(controller.walletAddress.value,
                      overflow: TextOverflow.ellipsis),
                )),
                Ui.boxWidth(12),
                CurvedContainer(
                  padding: EdgeInsets.all(16),
                  radius: 12,
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: controller.walletAddress.value));
                    Ui.showSnackBar("Copied to the clipboard", isError: false);
                  },
                  color: AppColors.secondaryColor.withOpacity(0.4),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: AppColors.white,
                  ),
                )
              ],
            ),
            Ui.boxHeight(40),
            AppText.thin("Or Use External Wallet", color: AppColors.white40),
            Ui.boxHeight(40),
            FilledButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.metamask,
                    width: 32,
                  ),
                  Ui.boxWidth(12),
                  AppText.button("Fund with Metamask")
                ],
              ),
            ),
            const Spacer(),
            SizedText.thin(
                "Convertion charges apply when you fund with cryptocurrency")
          ],
        ),
      ),
    );
  }
}
