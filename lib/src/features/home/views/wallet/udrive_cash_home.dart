import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/home/views/wallet/crypto_screen.dart';
import 'package:udrive/src/features/home/views/wallet/udrive_cash_screen.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class UdriveWalletScreen extends StatefulWidget {
  const UdriveWalletScreen({super.key});

  @override
  State<UdriveWalletScreen> createState() => _UdriveWalletScreenState();
}

class _UdriveWalletScreenState extends State<UdriveWalletScreen> {
  final controller = Get.find<WalletController>();

  @override
  void initState() {
    controller.getWalletBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Udrive Wallet",
      child: Ui.padding(
        padding: 42,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: item(AppColors.secondaryColor, AppColors.accentColor,
                        IconlyLight.work, "Crypto", () {
                  // Get.to(CryptoScreen());
                  Ui.showSnackBar("Coming Soon !!!", isError: false);
                })),
                Ui.boxWidth(24),
                Expanded(
                    child: item(AppColors.accentColor, AppColors.primaryColor,
                        IconlyLight.wallet, "Udrive Cash", () {
                  Get.to(UdriveCashScreen());
                })),
              ],
            ),
            Ui.boxHeight(24),
            CurvedContainer(
              radius: 18,
              color: Color(0xFF090142),
              child: AspectRatio(
                aspectRatio: 1.47,
                child: Column(
                  children: [
                    Ui.boxHeight(24),
                    AppText.thin("Balance:",
                        color: AppColors.white.withOpacity(0.4)),
                    Ui.boxHeight(24),
                    Obx(() {
                      return AppText.medium(controller.totalBalance,
                          fontSize: 36, fontFamily: 'Roboto');
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget item(Color color, Color iconColor, IconData icon, String title,
      VoidCallback onTap) {
    return CurvedContainer(
      radius: 8,
      onPressed: onTap,
      color: color,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Ui.align(child: AppText.thin(title)),
          Ui.boxHeight(12),
          Icon(
            icon,
            size: 54,
            color: iconColor,
          ),
          Ui.boxHeight(32)
        ],
      ),
    );
  }
}
