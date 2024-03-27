import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/utils/formatters/date_formatters.dart';
import 'package:udrive/src/utils/formatters/num_formatters.dart';
import '/src/src_barrel.dart';

import '../../ui_barrel.dart';

class CustomTextField extends StatelessWidget {
  final String label, hint;
  final bool isLabel;
  final TextEditingController controller;
  final FPL varl;
  final Color col;
  final VoidCallback? onTap, customOnChanged;
  final TextInputAction tia;
  final IconData? suffix;
  final bool autofocus;
  final double fs;
  final FontWeight fw;
  final bool readOnly, shdValidate;
  final TextAlign textAlign;
  final String? oldPass;
  const CustomTextField(this.hint, this.label, this.controller,
      {this.varl = FPL.text,
      this.fs = 17,
      this.fw = FontWeight.w300,
      this.col = AppColors.white,
      this.tia = TextInputAction.next,
      this.oldPass,
      this.onTap,
      this.autofocus = false,
      this.customOnChanged,
      this.readOnly = false,
      this.shdValidate = true,
      this.textAlign = TextAlign.start,
      this.suffix,
      this.isLabel = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool isShow = varl == FPL.password;
    String? vald;
    int a = isUserVal(controller.value.text) ? 2 : 0;
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: Ui.width(context) - 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLabel) AppText.bold(label),
            if (isLabel)
              const SizedBox(
                height: 8,
              ),
            TextFormField(
              controller: controller,
              readOnly: readOnly,
              textAlign: textAlign,
              autofocus: autofocus,
              onChanged: (s) async {
                if (varl == FPL.cardNo) {
                  setState(() {});
                }
                if (customOnChanged != null) customOnChanged!();
                // if (varl == FPL.password) {
                //   setState(() {
                //     vald = FPLValidator(s).valPassword();
                //   });
                // } else if (hint == "Username") {
                //   if (s.contains(RegExp(r'[^\w.]'))) {
                //     a = 0;
                //   } else if (s.length >= 3) {
                //     a = 2;
                //     if (s != CurrentUser().rawUsername) {
                //       setState(() {
                //         a = 1;
                //       });

                //       final b = await HttpService.checkUsername(s);
                //       a = b ? 2 : 0;
                //     }
                //   } else if (s.length > 1) {
                //     a = 1;
                //   }
                //   setState(() {});
                // }
              },
              keyboardType: varl.textType,
              textInputAction: tia,
              maxLines: varl == FPL.multi ? 5 : 1,
              maxLength: varl.maxLength,
              onTap: onTap,
              inputFormatters: [
                if (varl == FPL.cardNo) CreditCardFormatter(),
                if (varl == FPL.money) ThousandsFormatter(),
                // if (varl == FPL.dateExpiry) DateInputFormatter()
              ],

              validator: shdValidate
                  ? (value) {
                      setState(() {
                        vald = oldPass == null
                            ? Validators.validate(varl, value)
                            : Validators.confirmPasswordValidator(
                                value, oldPass!);

                        Future.delayed(const Duration(seconds: 1), () {
                          vald = null;
                        });
                        if (hint == "Username" && a != 2) {
                          vald = "Only letters,0-9,_,. are accepted";
                        }
                        if (label == "Name" &&
                            !(value?.contains(" ") ?? true)) {
                          vald = "First and last name required";
                        }
                      });
                      return vald == null ? null : "";
                    }
                  : null,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
              obscureText: varl == FPL.password && isShow,
              textAlignVertical:
                  varl == FPL.multi ? TextAlignVertical.top : null,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: col),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: col),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: col),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: col),
                ),
                counter: SizedBox.shrink(),
                errorStyle: const TextStyle(height: 0),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: col),
                ),
                suffixIcon: suffix != null
                    ? Icon(suffix, color: AppColors.accentColor)
                    : varl == FPL.password
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isShow = !isShow;
                              });
                            },
                            icon: Icon(
                                isShow ? IconlyLight.show : IconlyLight.hide,
                                color: col))
                        : hint == "Username"
                            ? defChecker(a)
                            : varl == FPL.cardNo
                                ? PaymentCardIcon(
                                    Validators.getCardTypeFrmNumber(
                                        controller.value.text))
                                : null,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: fs,
                    fontWeight: FontWeight.w300,
                    color: col.withOpacity(0.3)),
              ),
            ),
            vald == null
                ? const SizedBox(
                    height: 32,
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryColorBackground),
                        child: Text.rich(TextSpan(children: [
                          const WidgetSpan(
                              child: Icon(
                                IconlyLight.danger,
                                size: 18,
                                color: AppColors.red,
                              ),
                              alignment: PlaceholderAlignment.middle),
                          TextSpan(
                              text: "  $vald",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.white))
                        ]))),
                  )
          ],
        ),
      );
    });
  }

  static Widget defChecker(int a) {
    final progress = CircularProgress(
      12,
      primaryColor: Colors.blueAccent,
      secondaryColor: Colors.blueAccent.withOpacity(0.1),
      strokeWidth: 5,
    );
    const correct = Icon(
      Icons.check,
      color: AppColors.secondaryColor,
    );
    const wrong = Icon(
      Icons.close,
      color: AppColors.red,
    );

    Widget? b;

    switch (a) {
      case 0:
        b = wrong;
        break;
      case 1:
        b = progress;
        break;
      case 2:
        b = correct;
        break;
      default:
        b = null;
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: b,
      ),
    );
  }

  static bool isUserVal(String s) {
    return !(s.isEmpty || s.contains(RegExp(r'[^\w.]')) || s.length < 8);
  }

  static password(String label, TextEditingController controller,
      {String? oldPass, TextInputAction tia = TextInputAction.done}) {
    return CustomTextField(
      "* * * * * * * *",
      label,
      controller,
      isLabel: true,
      tia: tia,
      varl: FPL.password,
      oldPass: oldPass,
    );
  }
}
