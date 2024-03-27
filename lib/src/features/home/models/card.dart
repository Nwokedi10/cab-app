import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class Card {
  String? cardNo, cardName, cardExpiryDate, cardCVV;

  Card(
      {this.cardNo = "5678686709899685",
      this.cardName = "Adam Junior",
      this.cardCVV = "356",
      this.cardExpiryDate = "12/22"});

  CardType get cardType => Validators.getCardTypeFrmNumber(cardNo ?? "111");

  String get obscureNo =>
      "${cardNo!.substring(0, 4)} **** **** ${cardNo!.substring(cardNo!.length - 5, cardNo!.length)}";
}
