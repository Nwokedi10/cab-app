import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/payment_controller.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/home/views/payment/add_card_screen.dart';
import 'package:udrive/src/features/home/views/wallet/wallet_explorer.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/payment_card_chooser.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../widgets/payment_dropdown.dart';

class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({super.key});

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  final controller = Get.find<PaymentController>();
  final walletController = Get.find<WalletController>();

  final screens = [cashScreen(), udriveScreen(), flutterwaveScreen()];
  List<String> options = ["Cash", "Udrive Wallet", "Card"];
  RxString curOption = "Cash".obs;

  @override
  void initState() {
    curOption.value = MyPrefs.readData(MyPrefs.mpUdrivePaym) ?? "Cash";
    MyPrefs.listenToPrefChanges(MyPrefs.mpUdrivePaym, (value) {
      curOption.value = value ?? "Cash";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Payment Options"),
      body: Ui.padding(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ui.align(
                  child: AppText.medium("Payment Method",
                      color: AppColors.white40)),
              Ui.boxHeight(12),
              PaymentDropDown(),
              Ui.boxHeight(24),
              Obx(() {
                return screens[options.indexOf(curOption.value)];
              }),
              // AppText.medium("Cards"),
              // Ui.boxHeight(24),
              // Obx(() {
              //   return controller.cards.length == 1
              //       ? ListTile(
              //           leading: AppText.thin(controller.cards[0].obscureNo),
              //           trailing: PaymentCardIcon(controller.cards[0].cardType),
              //         )
              //       : PaymentCardChooser();
              // }),
              // Ui.boxHeight(24),
              // Ui.align(
              //   align: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       Get.to(AddCardScreen());
              //     },
              //     child: const Text(
              //       "Add New Card",
              //       style: TextStyle(
              //           color: AppColors.accentColor,
              //           decoration: TextDecoration.underline),
              //     ),
              //   ),
              // ),

              Obx(() {
                return curOption.value == options[1]
                    ? Obx(() {
                        return walletController.currentVerification.value == 3
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    Ui.boxHeight(72),
                                    AppText.medium("Udrive Wallet"),
                                    Ui.boxHeight(16),
                                    SizedBox(
                                      width: Ui.width(context) - 48,
                                      child: AppText.thin(
                                          "Add a few more details to secure your Udrive wallet account"),
                                    ),
                                  ]);
                      })
                    : curOption.value == options[2]
                        ? Obx(() {
                            return controller.cards.length == 1
                                ? ListTile(
                                    leading: AppText.thin(
                                        controller.cards[0].obscureNo),
                                    trailing: PaymentCardIcon(
                                        controller.cards[0].cardType),
                                  )
                                : PaymentCardChooser();
                          })
                        : SizedBox();
              }),
              const Spacer(),

              Obx(() {
                return curOption.value == options[1]
                    ? Obx(() {
                        return FilledButton.white(() {
                          Get.to(WalletExplorer());
                        },
                            walletController.currentVerification.value == 3
                                ? "My Wallet"
                                : "Create Wallet");
                      })
                    : curOption.value == options[2]
                        ? FilledButton.white(() {
                            Get.to(AddCardScreen());
                          }, "Add New Card")
                        : SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }

  static Widget cashScreen() {
    return SizedText.thin("Use your physical cash to pay for rides.");
  }

  static Widget flutterwaveScreen() {
    return SizedText.thin("Use your card to pay for your rides.");
  }

  static Widget udriveScreen() {
    return SizedText.thin(
        "Use your Udrive wallet to pay for your rides within the app. Note: This wallet is required to access our delivery and errands services.");
  }
}
