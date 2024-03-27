import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import '/src/global/ui/ui_barrel.dart' as ui_barrel;
import '/src/global/ui/widgets/others/others.dart';

class SuccessDialog extends StatelessWidget {
  final String? animationGif;
  final VoidCallback onContinuePressed;
  final String continueText;
  final bool isBottomDialog;

  const SuccessDialog({
    Key? key,
    required this.onContinuePressed,
    this.animationGif,
    this.continueText = "Continue",
    this.isBottomDialog = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          isBottomDialog ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: ui_barrel.Ui.circularRadius(14),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
            child: Column(
              children: [
                ui_barrel.Ui.boxHeight(43),
                SizedBox(
                  height: 156,
                  width: 177,
                  // child: WidgetOrNull(
                  //   animationGif != null,
                  //   child: Lottie.asset(animationGif!),
                  // ),
                ),
                ui_barrel.Ui.boxHeight(53),
                ui_barrel.FilledButton(
                  onPressed: onContinuePressed,
                  child: ui_barrel.AppText.button(continueText),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
