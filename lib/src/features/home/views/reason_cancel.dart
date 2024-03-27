import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:udrive/src/features/map/views/trip_ended_screen.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/ui/ui_barrel.dart';

class ReasonCancelScreen extends StatefulWidget {
  const ReasonCancelScreen({super.key});
  static const List<String> reasons = [
    "My Driver was rude",
    "Wrong destination",
    "My Driver took the wrong route",
    "I do not want a ride again"
  ];

  @override
  State<ReasonCancelScreen> createState() => _ReasonCancelScreenState();
}

class _ReasonCancelScreenState extends State<ReasonCancelScreen> {
  int curSel = 0;

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Reason For Cancellation",
      child: Ui.padding(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (_, i) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            curSel = i;
                          });
                        },
                        title: AppText.thin(ReasonCancelScreen.reasons[i],
                            color: AppColors.white),
                        tileColor: curSel == i
                            ? AppColors.accentColor
                            : AppColors.transparent,
                      );
                    })),
            FilledButton(
              onPressed: () {
                Get.to(TripEndedScreen(
                  reason: ReasonCancelScreen.reasons[curSel],
                ));
              },
              text: "Confirm Cancellation",
            ),
            Ui.boxHeight(24)
          ],
        ),
      ),
    );
  }
}
