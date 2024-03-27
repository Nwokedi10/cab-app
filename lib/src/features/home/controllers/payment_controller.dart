import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/model/wallet.dart';
import '../../../global/ui/ui_barrel.dart';
import '../models/card.dart' as cd;

class PaymentController extends GetxController {
  RxList<cd.Card> cards = <cd.Card>[].obs;
  RxInt curCard = 0.obs;
  List<TextEditingController> textEditinControllers =
      List.generate(4, (index) => TextEditingController());
  final formkey = GlobalKey<FormState>();

  int get currentCard => cards.isNotEmpty ? curCard.value : -1;

  changeCard(int i) {
    curCard.value = i;
  }

  @override
  onInit() {
    super.onInit();
    final c = MyPrefs.getCardDetails();
    if (c != null) {
      cards.add(c);
    }
  }

  addCard() async {
    print(cards);
    final form = formkey.currentState!;
    if (form.validate()) {
      cd.Card ccard = cd.Card(
        cardName: textEditinControllers[0].value.text,
        cardNo: textEditinControllers[1].value.text,
        cardCVV: textEditinControllers[2].value.text,
        cardExpiryDate: textEditinControllers[3].value.text,
      );
      cards.add(ccard);
      await MyPrefs.saveCard(ccard);
      Ui.showSnackBar("New card added Successfuly ", isError: false);
    }
    print(cards);
    UtilFunctions.clearTextEditingControllers(textEditinControllers);
  }

  removeCard(int i) {
    cards.removeAt(i);
    if (i == curCard.value && i != 0) {
      curCard.value = 0;
    } else {
      curCard.value = -1;
    }
  }
}
