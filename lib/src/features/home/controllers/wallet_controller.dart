import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/functions/ui_functions.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/model/wallet.dart';

class WalletController extends GetxController {
  RxInt currentVerification = 0.obs;
  RxString userIDCard = "".obs;
  RxDouble balance = 0.0.obs;
  RxString walletAddress = "5ri674o8yhrfp838yog78ui3389hf89".obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<Wallet> curWallet = Wallet().obs;

  String get totalBalance => balance.value.toInt().toCurrency();

  // bool get isVerified => currentVerification.value == 3;

  @override
  onInit() {
    currentVerification.value = MyPrefs.readData(MyPrefs.walletVerif) ?? 0;
    MyPrefs.listenToPrefChanges(MyPrefs.walletVerif, (value) {
      currentVerification.value = value ?? 0;
    });
    super.onInit();
  }

  saveCurrentVerif() async {
    await MyPrefs.writeData(MyPrefs.walletVerif, currentVerification.value);
  }

  changeUserIDCard(String id) {
    userIDCard.value = id;
  }

  nextProcess() {
    if (currentVerification.value <= 3) {
      currentVerification.value++;
      saveCurrentVerif();
    }
  }

  changeProcess(int i) async {
    if (i <= 3) {
      currentVerification.value = i;
      await saveCurrentVerif();
    }
  }

  resetProcess() {
    currentVerification.value = 0;
    saveCurrentVerif();
    userIDCard.value = "";
  }

  validateIDcard() async {
    if (userIDCard.value.isNotEmpty) {
      final d = await HttpService.createWallet();
      nextProcess();
    }
  }

  approveFund(BuildContext context) async {
    await getWalletBalance();
    final c = int.parse(textEditingController.value.text.split(",").join());
    if (c < balance.value) {
      Ui.showSnackBar("Insufficient Balance");
    } else {
      final d = await HttpService.makePayment(context, c);
      if (d) {
        await getWalletBalance();
        Ui.showSnackBar("Transaction Successful", isError: false);
      } else {
        Ui.showSnackBar("Transaction Failed");
      }
    }
    textEditingController.clear();
  }

  getWalletBalance() async {
    final c = await HttpService.getWalletBalance();
    balance.value = c.toDouble();
  }
}
