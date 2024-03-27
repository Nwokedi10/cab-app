import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/home/views/reason_cancel.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/map/views/trip_ended_screen.dart';
import 'package:udrive/src/global/ui/functions/ui_functions.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/text/app_text.dart';

import '../../../global/ui/widgets/others/containers.dart';
import '../../../src_barrel.dart';

class CancelRideScreen extends StatelessWidget {
  final DeliveryMode deliveryMode;
  const CancelRideScreen({this.deliveryMode = DeliveryMode.none, super.key});

  @override
  Widget build(BuildContext context) {
    String sride = deliveryMode.name;
    return SinglePageScaffold(
      child: Ui.padding(
        child: Column(
          children: [
            Ui.boxHeight(120),
            SizedText.thin(
              "Are you sure you want to cancel the $sride? You will be charged the amount below.",
            ),
            Ui.boxHeight(24),
            AppText.medium(300.toCurrency(),
                fontFamily: 'Roboto', fontSize: 48),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: FilledButton(
                  onPressed: () {
                    Get.to(LoadingScreen("Canceling ${sride.capitalizeFirst}",
                        () {}, ReasonCancelScreen()));
                  },
                  text: "Cancel ${sride.capitalizeFirst}",
                )),
                Ui.boxWidth(8),
                Expanded(
                  child: FilledButton.outline(
                    () {
                      Get.back();
                    },
                    "Continue ${sride.capitalizeFirst}",
                    color: AppColors.primaryColor,
                  ),
                )
              ],
            ),
            Ui.boxHeight(120)
          ],
        ),
      ),
    );
  }
}
